import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';

// ignore: must_be_immutable
class DialogWidget extends StatelessWidget {
  IconData icon;
  String title;
  String bodyText;
  String btnText;
  Color color;
  Function() function;
  DialogWidget({
    required this.icon,
    required this.title,
    required this.bodyText,
    required this.btnText,
    required this.color,
    required this.function,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(
          height: 50,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                size: 23,
                icon,
                color: color,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(bodyText),
        const SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: function,
          style: TextButton.styleFrom(
              backgroundColor: color.withOpacity(.1), foregroundColor: color),
          child: Text(btnText),
        ),
        const SizedBox(
          height: 50,
        ),
      ]),
    );
  }
}
