import 'package:flutter/material.dart';
import 'package:ucl_assistant/widgets/undraw_image.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.message, this.flexible = true});
  final String message;
  final bool flexible;

  @override
  Widget build(BuildContext context) {
    final widget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(message), const UndrawImage('warning')],
    );

    return flexible ? Flexible(child: widget) : widget;
  }
}
