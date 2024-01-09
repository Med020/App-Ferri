//import 'package:espace_client/products.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:espace_client/Widgets/ArrowList.dart';
import 'FicheT_E.dart';
import 'FicheT_M.dart';
import 'FicheT_O.dart';
import 'FicheT_P.dart';
import 'NouveauteE.dart';
import 'NouveauteM.dart';
import 'NouveauteO.dart';
import 'PromotionE.dart';
import 'PromotionM.dart';
import 'PromotionO.dart';
import 'PromotionP.dart';
import 'NouveauteP.dart';
import 'cadre.dart';

import 'package:http/http.dart' as http;

class EntryPointPage extends StatefulWidget {
  final int id;
  const EntryPointPage({Key? key, required this.id}) : super(key: key);

  @override
  _EntryPointPageState createState() => _EntryPointPageState();
}

class _EntryPointPageState extends State<EntryPointPage> {
  List<Cadre> favoriteCadres = [];

  int _selectedIndex = 0;
  PageController _pageController = PageController();
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.6/app_ferri/FavorisDisplay.php'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        setState(() {
          favoriteCadres = jsonData
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
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    String apiUrl =
                        'http://192.168.1.6/app_ferri/Search.php.php'; // Replace with the actual URL of your PHP file
                    Uri apiUri = Uri.parse(apiUrl);
                    Map<String, String> queryParams = {'query': _searchQuery};
                    Uri searchUri =
                        apiUri.replace(queryParameters: queryParams);

                    http.get(searchUri).then((response) {
                      // Handle the API response here
                      if (response.statusCode == 200) {
                        // Parse the response body (JSON) using the 'dart:convert' package
                        var searchResults = json.decode(response.body);
                        setState(() {
                          _searchResults = searchResults;
                        });
                        print('work');
                        // Update the UI with the search results
                        // ...
                      } else {
                        print('notworking');
                        // Show an error message
                        // ...
                      }
                    }).catchError((error) {
                      // Handle any error that occurred during the API call
                      // ...
                    });
                  },
                ),
                hintText: 'Recherche ...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: const Text('Mon Compte'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
              ),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Theme(
              data: Theme.of(context).copyWith(),
              child: ExpansionTile(
                leading: const Icon(Icons.category),
                title: const Text('Catalogue'),
                children: [
                  ListTile(
                    title: const Text('Quincaillerie'),
                    leading: const Icon(Icons.hardware_rounded),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Outillage'),
                    leading: const Icon(Icons.pan_tool_alt_rounded),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Plomberie'),
                    leading: const Icon(Icons.plumbing_rounded),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Sanitaire'),
                    leading: const Icon(Icons.sanitizer_rounded),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Electricité'),
                    leading: const Icon(Icons.electrical_services_rounded),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Maison'),
                    leading: const Icon(Icons.house),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                ArrowList(
                  title: 'Maison',
                  color: Color(0xFFEC8B39),
                  icone: Icons.home,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => NProductScreenM(id: id)),
                    );
                    print('Maison ');
                  },
                ),
                ArrowList(
                  title: 'Electricité',
                  color: Color(0xFF007971),
                  icone: Icons.electrical_services_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => NProductScreenE(id: id)),
                    );

                    print('Electricite ');
                  },
                ),
                ArrowList(
                  title: 'Plomberie et Sanitaire',
                  color: Color(0xFF003172),
                  icone: Icons.plumbing_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => NProductScreenP(id: id)),
                    );
                    print('P et S ');
                  },
                ),
                ArrowList(
                  title: 'Quincaillerie et Outillage',
                  color: Color(0xFFB1713A),
                  icone: Icons.hardware_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => NProductScreenO(id: id)),
                    );
                    print('Q et O ');
                  },
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                ArrowList(
                  title: 'Maison',
                  color: Color(0xFFEC8B39),
                  icone: Icons.home,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => PProductScreenM(id: id)),
                    );
                    print('Maison ');
                  },
                ),
                ArrowList(
                  title: 'Electricité',
                  color: Color(0xFF007971),
                  icone: Icons.electrical_services_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => PProductScreenE(id: id)),
                    );
                    print('Electricite ');
                  },
                ),
                ArrowList(
                  title: 'Plomberie et Sanitaire',
                  color: Color(0xFF003172),
                  icone: Icons.plumbing_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => PProductScreenP(id: id)),
                    );
                    print('P et S ');
                  },
                ),
                ArrowList(
                  title: 'Quincaillerie et Outillage',
                  color: Color(0xFFB1713A),
                  icone: Icons.hardware_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => PProductScreenO(id: id)),
                    );
                    print('Q et O ');
                  },
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                ArrowList(
                  title: 'Maison',
                  color: Color(0xFFEC8B39),
                  icone: Icons.home,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => FProductScreenM(id: id)),
                    );
                    print('Maison ');
                  },
                ),
                ArrowList(
                  title: 'Electricité',
                  color: Color(0xFF007971),
                  icone: Icons.electrical_services_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => FProductScreenE(id: id)),
                    );
                    print('Electricite ');
                  },
                ),
                ArrowList(
                  title: 'Plomberie et Sanitaire',
                  color: Color(0xFF003172),
                  icone: Icons.plumbing_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => FProductScreenP(id: id)),
                    );
                    print('P et S ');
                  },
                ),
                ArrowList(
                  title: 'Quincaillerie et Outillage',
                  color: Color(0xFFB1713A),
                  icone: Icons.hardware_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => FProductScreenO(id: id)),
                    );
                    print('Q et O ');
                  },
                ),
              ],
            ),
            Column(children: [
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: favoriteCadres.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: CadreItem(cadre: favoriteCadres[index]),
                      ),
                    );
                  },
                ),
              ),
            ]),
            Column(
              children: [
                SizedBox(height: 50),
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Build your custom widget to display each search result item
                      // Here's an example using ListTile:
                      return ListTile(
                        title: Text(_searchResults[index].toString()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF114D4A),
        unselectedItemColor: const Color(0xFFA4A4A4),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases_rounded),
            label: 'Nouveautés',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.discount_rounded),
            label: 'Promotions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_rounded),
            label: 'Fiches Techniques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Favoris',
          ),
        ],
      ),
    );
  }
}

class CadreItem extends StatelessWidget {
  final Cadre cadre;

  CadreItem({required this.cadre});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cadre.color, // Set the card color to cadre color
      child: Column(
        children: [
          Image.network(
            cadre
                .picture_url, // Fetch the image from the server using the imageUrl
            height: 140,
            width: 700,
          ),
          Text(
            cadre.titre,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
