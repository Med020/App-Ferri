import 'package:flutter/material.dart';

class Cadre {
  final String code;
  final String titre;
  final String picture_url;
  final String file_path;
  final color = const Color.fromARGB(255, 165, 163, 163);

  Cadre({
    required this.code,
    required this.titre,
    required this.picture_url,
    required this.file_path,
  });
}
