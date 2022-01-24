import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:chatdemo/models/Secret.dart';
import 'package:chatdemo/models/UserAgentClient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:chatdemo/models/CustomException.dart';
import 'package:chatdemo/models/User.dart';
import 'package:chatdemo/utilities/constants.dart';

import 'chatScreen.dart';

class LoginQRCodeScreen extends StatefulWidget {
  @override
  _LoginQRCodeScreenState createState() => _LoginQRCodeScreenState();
}

class _LoginQRCodeScreenState extends State<LoginQRCodeScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    _buildLoginBtn()
                  else
                    Text('Scanner un code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            icon: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  IconData i = (snapshot.data == true)
                                      ? Icons.flash_on
                                      : Icons.flash_off;
                                  return Icon(
                                    i,
                                    color: Colors.white,
                                    size: 24.0,
                                  );
                                }),
                            label: Text('Flash'),
                          )),
                      Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            icon: FutureBuilder(
                                future: controller?.getCameraInfo(),
                                builder: (context, snapshot) {
                                  IconData i =
                                      (describeEnum(snapshot.data!) == 'front')
                                          ? Icons.flip_camera_ios_outlined
                                          : Icons.flip_camera_ios;
                                  return Icon(
                                    i,
                                    color: Colors.white,
                                    size: 24.0,
                                  );
                                }),
                            label: Text('Camera'),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return ElevatedButton(
        onPressed: () async {
          try {
            var data = result!.code;
            if (data != null) {
              Uri uri = Uri.parse(data);
              Map<String, String> queryParameters = uri.queryParameters;
              try {
                await _auth(queryParameters['userid'].toString(),
                    queryParameters['qrlogin'].toString());
              } catch (e) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Désolé...'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(e.toString()),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              }
              ;

              setState(() {
                result = null;
              });
            }
          } catch (e) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Désolé...'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(e.toString()),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          }
          ;
        },
        child: Text('Continuer'));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> _auth(String userid, String qrloginkey) async {
    Secret secret = await SecretLoader(secretPath: "secret.json").load();

    // Get General Token from Specific User
    final url = APIConstants.MOODLE_BASE_URL +
        APIOperations.getTokenByLoginMoodle +
        '&username=' +
        Uri.encodeComponent(secret.user) +
        '&password=' +
        Uri.encodeComponent(secret.pwd);

    final resp = await http.get(Uri.parse(url));

    if (resp.statusCode == 200) {
      dynamic data = jsonDecode(resp.body);
      var token = data["token"];

      if (token != null) {
        final url = APIConstants.MOODLE_BASE_URL +
            APIOperations.fetchUserDetailMoodleFromField +
            '&field=id' +
            '&values[0]=' + userid +
            '&wstoken=' + token;

        print(url);

        final resp = await http.get(Uri.parse(url));

        if (resp.statusCode == 200) {

          try {
            User u = User.fromJson2(jsonDecode(resp.body)[0]);

            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => new ChatScreen(user: u)),
            );
          } catch(e) {
            throw CustomException('Impossible de récupérer votre profil');
          }
        }
      } else {
        throw CustomException('Les identifiants sont incorrects');
      }
    } else {
      throw CustomException('Impossible de se connecter au serveur');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
