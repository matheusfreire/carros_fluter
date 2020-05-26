import 'package:flutter/material.dart';

alert(BuildContext context, String msg, {Function callBack}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Carros"),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                if(callBack != null){
                  callBack();
                }
              },
            )
          ],
        ),
      );
    },
  );
}