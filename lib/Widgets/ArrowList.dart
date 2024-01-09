import 'package:flutter/material.dart';

class ArrowList extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final Color color;
  final IconData icone;

  ArrowList(
      {required this.title,
      required this.onTap,
      required this.color,
      required this.icone});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: ElevatedButton(
            onPressed: onTap,
            child: Container(
                width: 350,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      icone,
                      color: Colors.white,
                      size: 40.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                )),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(35),
                      topRight: Radius.circular(35))),
            ),
          ),
        ),
      ],
    );
  }
}
