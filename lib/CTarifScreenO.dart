import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Produit.dart';
import 'entry_point_gerant.dart';

class CTarifScreenO extends StatefulWidget {
  final int id;
  const CTarifScreenO({Key? key, required this.id}) : super(key: key);
  @override
  State<CTarifScreenO> createState() => _CTarifScreenStateO();
}

class _CTarifScreenStateO extends State<CTarifScreenO> {
  bool checkBoxValue1 = false;
  bool checkBoxValue2 = false;
  bool checkBoxValue3 = false;
  bool checkBoxValue4 = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Produit> produits = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.6/app_ferri/Tarifs_Outillage.php'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        setState(() {
          produits = jsonData
              .map((item) => Produit(
                    code: item['code'],
                    titre: item['titre'],
                    picture_url: item['picture_url'],
                    PG: item['PG'],
                    PD: item['PD'],
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
        backgroundColor: Colors.white,
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
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => EntryPointG(id: id)),
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Mon Compte'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
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
        body: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  ///////////////////////////////////////////////// Barre de Recherche  /////////////////////////////////////:
                  // Expanded(child: SearchBar()),

                  ///////////////////////////////////////////////// Bouton Recherche  /////////////////////////////////////:
                  // IconeBouton(
                  //     color: Color.fromARGB(255, 27, 104, 100),
                  //     icone: Icons.search,
                  //     onTap: () {}),

                  ///////////////////////////////////////////////// Bouton **  /////////////////////////////////////:
                  // IconeBouton(
                  //     color: Color.fromARGB(255, 27, 104, 100),
                  //     icone: Icons.home,
                  //     onTap: () {}),

                  ///////////////////////////////////////////////// Bouton Setting  /////////////////////////////////////:
                  // IconeBouton(
                  //     color: Color.fromARGB(255, 27, 104, 100),
                  //     icone: Icons.settings,
                  //     onTap: () {}),
                  ///////////////////////////////////////////////// Checkbox  /////////////////////////////////////:
                  Row(
                    children: [CheckBoxArticle()],
                  ),

                  ///////////////////////////////////////////////// Retour  /////////////////////////////////////:
                  Container(
                    color: Colors.green,
                    height: 50,
                    child: Row(
                      children: [
                        Text(
                          "Articles",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ///////////////////////////////////////////////// Articles  /////////////////////////////////////:
            Expanded(
              child: ListView.builder(
                  itemCount: produits.length,
                  itemBuilder: (context, i) {
                    return Container(
                      color: Color.fromARGB(255, 197, 196, 196),
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          color: Color.fromARGB(255, 161, 155, 155),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              height: 200,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 100,
                                      color: Colors.white,
                                      child: Image.network(
                                        produits[i].picture_url,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(produits[i].code),
                            subtitle: Column(
                              children: [
                                Text(
                                  produits[i].titre,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text('PD :' + produits[i].PD),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }

  Widget CheckBoxArticle() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        child: Checkbox(
          value: checkBoxValue1,
          onChanged: (value) {
            setState(() {
              checkBoxValue1 = value!;
            });
          },
        ),
      ),
      Container(
          width: 70,
          child: Text(
            'Quincaillerie & Outillage',
            style: TextStyle(fontSize: 10),
          )),
      Container(
        child: Checkbox(
          value: checkBoxValue2,
          onChanged: (value) {
            setState(() {
              checkBoxValue2 = value!;
            });
          },
        ),
      ),
      Container(
          width: 60,
          child: Text(
            'Plomberie & Sanitaire',
            style: TextStyle(fontSize: 10),
          )),
      Container(
        child: Checkbox(
          value: checkBoxValue3,
          onChanged: (value) {
            setState(() {
              checkBoxValue3 = value!;
            });
          },
        ),
      ),
      Container(
          width: 45,
          child: Text('Electricité', style: TextStyle(fontSize: 10))),
      Container(
        child: Checkbox(
          value: checkBoxValue4,
          onChanged: (value) {
            setState(() {
              checkBoxValue4 = value!;
            });
          },
        ),
      ),
      Container(
          width: 40, child: Text('Maison', style: TextStyle(fontSize: 10))),
    ]);
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: const [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}

class IconeBouton extends StatelessWidget {
  final void Function() onTap;
  final Color color;
  final IconData icone;

  IconeBouton({
    required this.onTap,
    required this.color,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 40,
        height: 40,
        color: color,
        child: Center(
          child: IconButton(
            icon: Icon(
              icone,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}
