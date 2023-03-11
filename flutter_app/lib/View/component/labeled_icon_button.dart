import 'package:flutter/material.dart';

class LabeledIconButton extends StatelessWidget {
  final String _label;
  final IconData _icon;
  final void Function() _onPushed;
  final bool _available;

  const LabeledIconButton(this._icon, this._label, this._onPushed, this._available,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: _available ? _onPushed : null,
        child: Column(
          children: [
            Icon(_icon),
            Text(
              _label,
              style: const TextStyle(fontSize: 12.0, color: Colors.blueGrey),
            )
          ],
        ));
  }
}
