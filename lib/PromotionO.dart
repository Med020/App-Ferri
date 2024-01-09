import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cadre.dart';
import 'entry_point.dart';
import 'product_zoomedNE.dart';

class PProductScreenO extends StatefulWidget {
  final int id;
  const PProductScreenO({Key? key, required this.id}) : super(key: key);
  @override
  State<PProductScreenO> createState() => _PProductScreenStateO();
}

class _PProductScreenStateO extends State<PProductScreenO> {
  List<Cadre> cadres = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.1.6/app_ferri/Promotions_Outillage.php'));
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

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    return Scaffold(
      appBar: CustomAppBar(
        onBackButtonPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => EntryPointPage(id: id)),
          );
        },
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreenNE(
                      product: cadres[index],
                      id: id,
                    ),
                  ),
                );
              },
              child: CadreItem(cadre: cadres[index]),
            ),
          );
        },
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackButtonPressed;

  const CustomAppBar({Key? key, required this.onBackButtonPressed})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackButtonPressed,
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
