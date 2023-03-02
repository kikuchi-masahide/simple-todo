import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final String _label;
  final void Function() _onPushed;
  final bool _available;

  NormalButton(this._label, this._onPushed, this._available);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _available ? _onPushed : null,
      child: Text(_label),
    );
  }
}
