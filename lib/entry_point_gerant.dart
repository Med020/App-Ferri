import 'package:flutter/material.dart';
import 'package:espace_client/Widgets/ArrowList.dart';

import 'TarifScreenE.dart';
import 'TarifScreenGlobal.dart';
import 'TarifScreenM.dart';
import 'TarifScreenO.dart';
import 'TarifScreenP.dart';
import 'NouveauteE.dart';
import 'NouveauteM.dart';
import 'NouveauteO.dart';
import 'PromotionE.dart';
import 'PromotionM.dart';
import 'PromotionO.dart';
import 'PromotionP.dart';
import 'NouveauteP.dart';
import 'FicheT_E.dart';
import 'FicheT_M.dart';
import 'FicheT_O.dart';
import 'FicheT_P.dart';

class EntryPointG extends StatelessWidget {
  final int id;
  const EntryPointG({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EntryPointPageG(id: id),
    );
  }
}

class EntryPointPageG extends StatefulWidget {
  final int id;

  const EntryPointPageG({Key? key, required this.id}) : super(key: key);

  @override
  _EntryPointPageGState createState() => _EntryPointPageGState();
}

class _EntryPointPageGState extends State<EntryPointPageG> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

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
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {},
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NProductScreenE(id: id),
                      ),
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
                          builder: (context) => TarifScreenM(id: id)),
                    );
                  },
                ),
                ArrowList(
                  title: 'Electricité',
                  color: Color(0xFF007971),
                  icone: Icons.electrical_services_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => TarifScreenE(id: id)),
                    );
                  },
                ),
                ArrowList(
                  title: 'Plomberie et Sanitaire',
                  color: Color(0xFF003172),
                  icone: Icons.plumbing_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => TarifScreenP(id: id)),
                    );
                  },
                ),
                ArrowList(
                  title: 'Quincaillerie et Outillage',
                  color: Color(0xFFB1713A),
                  icone: Icons.hardware_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => TarifScreenO(id: id)),
                    );
                  },
                ),
                ArrowList(
                  title: 'Global',
                  color: Color.fromARGB(255, 100, 100, 100),
                  icone: Icons.select_all_rounded,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => TarifScreenG(id: id)),
                    );
                  },
                ),
              ],
            ),
            Column(),
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
            icon: Icon(Icons.price_change_rounded),
            label: 'Tarifs',
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
