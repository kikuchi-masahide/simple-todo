import 'package:flutter/material.dart';
import 'package:flutter_app/model/types/home_message_type.dart';
import 'package:flutter_app/view/component/labeled_icon_button.dart';
import 'package:flutter_app/view/home/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeMessageBox extends StatelessWidget {
  static const messageBoxWidth = 400.0;
  static const messageBoxHeight = 70.0;
  static const messageBoxOpacity = 0.7;
  static const messageBoxColor = {
    HomeMessageType.none: Color(0x00000000),
    HomeMessageType.success: Colors.lightGreen,
    HomeMessageType.notice: Colors.orange,
  };

  const HomeMessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0,
      left: _calcLeftX(context),
      width: messageBoxWidth,
      height: messageBoxHeight,
      child: Opacity(
        opacity: messageBoxOpacity,
        child: Container(
          width: messageBoxWidth,
          height: messageBoxHeight,
          color: messageBoxColor[
              context.watch<HomeViewModel>().getHomeMessage().item1],
          child: _createRow(context),
        ),
      ),
    );
  }

  double _calcLeftX(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    return (windowWidth - messageBoxWidth) / 2;
  }

  Row _createRow(BuildContext context) {
    var t = context.watch<HomeViewModel>().getHomeMessage();
    var type = t.item1;
    var message = t.item2;
    var children = <Widget>[];
    if (type == HomeMessageType.success) {
      children.add(Row(
        children: [
          const Icon(Icons.done),
          Text(
            message ?? '',
          ),
        ],
      ));
      children.add(LabeledIconButton(Icons.cancel_outlined, 'メッセージを消す', () {
        context.read<HomeViewModel>().closeHomeMessage();
      }, true));
    } else if (type == HomeMessageType.notice) {
      children.add(Row(
        children: [
          const Icon(Icons.sentiment_dissatisfied),
          Text(
            message ?? '',
          ),
        ],
      ));
      children.add(LabeledIconButton(Icons.cancel_outlined, 'メッセージを消す', () {
        context.read<HomeViewModel>().closeHomeMessage();
      }, true));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
