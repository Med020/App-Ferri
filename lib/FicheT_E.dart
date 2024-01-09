import 'package:espace_client/entry_point.dart';
//import 'package:espace_client/entry_point_commercial.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'dart:convert';
import 'cadre.dart';
//import 'entry_point.dart';

class FProductScreenE extends StatefulWidget {
  final int id;
  const FProductScreenE({Key? key, required this.id}) : super(key: key);

  @override
  State<FProductScreenE> createState() => _FProductScreenStateE();
}

class _FProductScreenStateE extends State<FProductScreenE> {
  List<Cadre> cadres = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.6/app_ferri/FichesTechnique_electricite.php'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        setState(() {
          cadres = jsonData
              .map((item) => Cadre(
                    code: item['code'],
                    titre: item['titre'],
                    picture_url: item['picture_url'],
                    file_path: item['file_path'],
                  ))
              .toList();
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Request failed with error: $error');
    }
  }

  void openPDF(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $url');
    }
  }

  Future<bool> canLaunchUrl(Uri uri) async {
    return await launcher.canLaunch(uri.toString());
  }

  Future<void> launchUrl(Uri uri) async {
    await launcher.launch(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF114D4A),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {},
                ),
                hintText: 'Recherche ...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => EntryPointPage(id: id)),
            );
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: cadres.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                openPDF(cadres[index].file_path);
              },
              child: CadreItem(cadre: cadres[index]),
            ),
          );
        },
      ),
    );
  }
}

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
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
