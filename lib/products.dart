import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

class ProductDetailScreen extends StatefulWidget {
  final Cadre product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late SharedPreferences _prefs;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = _prefs.getBool('favorite_${widget.product.code}') ?? false;
    });
  }

  void updateFavoriteStatus() async {
    final url = 'http://192.168.1.6/app_ferri/favoris.php';
    final data = {
      'productCode': widget.product.code,
      'isFavorite': isFavorite ? '1' : '0'
    };

    try {
      final response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        print('Favorite status updated successfully');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Request failed with error: $error');
    }
  }

  void toggleFavoriteStatus() {
    setState(() {
      isFavorite = !isFavorite;
    });

    _prefs.setBool('favorite_${widget.product.code}', isFavorite);

    updateFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
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
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          width: 400,
          height: 600,
          child: Card(
            color: widget.product.color,
            child: Stack(
              children: [
                Column(
                  children: [
                    Image.network(
                      widget.product.picture_url,
                      height: 200,
                      width: 700,
                    ),
                    Text(
                      widget.product.titre,
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      toggleFavoriteStatus();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
