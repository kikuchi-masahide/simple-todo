import 'package:flutter/material.dart';

class BoxAlert extends StatelessWidget {
  final String? _message;

  BoxAlert(this._message);

  @override
  Widget build(BuildContext context) {
    if (_message != null) {
      return Container(
        padding: const EdgeInsets.only(left: 80.0, right: 80.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.red,),borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          _message as String,
          style: const TextStyle(fontSize: 24.0, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container();
  }
}
