import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlertManager {
  static Future<dynamic> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String cancelActionText,
    required Function(bool) callback,
    required String defaultActionText,
  }) async {
    if (!Platform.isIOS) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            if (cancelActionText != null)
              OutlinedButton(
                child: Text(cancelActionText),
                onPressed: () {
                  callback(false);

                  Navigator.of(context).pop(false);
                },
              ),
            OutlinedButton(
              child: Text(defaultActionText),
              onPressed: () {
                callback(true);

                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );
    }

    // todo : showDialog for ios
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelActionText != null)
            CupertinoDialogAction(
              child: Text(cancelActionText),
              onPressed: () {
                callback(false);

                Navigator.of(context).pop(false);
              },
            ),
          CupertinoDialogAction(
            child: Text(defaultActionText),
            onPressed: () {
              callback(true);
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}
