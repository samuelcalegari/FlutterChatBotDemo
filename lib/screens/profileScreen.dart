import 'package:flutter/material.dart';
import 'package:chatdemo/utilities/constants.dart';
import 'package:chatdemo/models/User.dart';

Widget _buildLogoutBtn() {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {},
          style: Styles.KButtonStyle,
          child: Text('Se Déconnecter')));
}

Widget _buildBackBtn(BuildContext context) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: Styles.KButtonStyle,
          child: Text('Retour')));
}

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 120.0,
        ),
        child: Column(
          children: <Widget>[
            new Container(
                width: 150.0,
                height: 150.0,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        image: NetworkImage(user.userPictureUrl)
                    )
                )
            ),
            SizedBox(height: 30.0),
            Text(user.firstName + ' ' + user.lastName,
                style: Styles.kTitleStyle),
            SizedBox(height: 30.0),
            _buildBackBtn(context),
            _buildLogoutBtn()
          ],
        ),
      ),
    ));
  }
}
