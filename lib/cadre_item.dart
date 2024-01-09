import 'package:flutter/material.dart';
import 'product.dart';

class CadreItem extends StatelessWidget {
  final Cadre cadre;

  const CadreItem({Key? key, required this.cadre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cadre.color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              cadre.picture_url,
              height: 200,
              width: 700,
            ),
          ),
          Text(
            cadre.titre,
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
