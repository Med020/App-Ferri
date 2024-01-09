import 'package:flutter/material.dart';

class block extends StatelessWidget {
  final String title;
  final void Function() onTap;



  const block(
      {super.key, required this.title,
        required this.onTap,

        });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 0,),

        Padding(
          padding: const EdgeInsets.all(0.0),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD8D8D8),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5))),
            ),

            child: SizedBox(
                width: 130,
                height: 170,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(title, style: const TextStyle(fontSize: 20,color: Colors.black),
                         ),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
