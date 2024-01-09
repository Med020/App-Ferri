import 'package:flutter/material.dart';
import 'cadre.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreenNE extends StatefulWidget {
  final Cadre product;
  final int id; // Add the user ID parameter

  ProductDetailScreenNE({required this.product, required this.id});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreenNE> {
  late SharedPreferences _prefs;

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

  bool isFavorite = false;

  void updateFavoriteStatus() async {
    final action = isFavorite ? 'add' : 'delete';

    print(action);
    final url = 'http://10.10.2.168/app_ferri/Favoris.php';
    final data = {
      'product_code': widget.product.code,
      'action': action,
      'user_id': widget.id.toString(), // Pass the user ID in the request
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
        // Handle the back button press
        Navigator.pop(context);
        return false; // Prevent default back navigation
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
