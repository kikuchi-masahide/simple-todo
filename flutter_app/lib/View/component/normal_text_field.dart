import 'package:flutter/material.dart';

class NormalTextField extends StatelessWidget{
  final TextEditingController _controller;
  final String _label;
  final bool _enabled;
  final bool _obscured;

  NormalTextField(this._controller,this._label,this._enabled,[this._obscured = false]);

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(40.0),
     child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_label,style: const TextStyle(fontSize: 18.0),),
          TextField(controller: _controller,obscureText: _obscured,style: const TextStyle(fontSize: 24.0),enabled: _enabled,),
        ],
      ),
    );
  }
}