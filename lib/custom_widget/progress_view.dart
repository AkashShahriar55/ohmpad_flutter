import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final Widget? child;
  final bool? isShow;
  final double opacity;
  final Color color;

  ProgressWidget({
    Key? key,
    @required this.child,
    @required this.isShow,
    this.opacity = 0.5,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child!);
    if (isShow!) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor))),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
