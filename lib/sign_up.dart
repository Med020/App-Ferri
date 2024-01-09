import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'Local Database/database_helper.dart';
import 'package:http/http.dart' as http;
//import 'Local Database/local_db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';
import 'package:connectivity/connectivity.dart';

class User {
  final int code;
  final String nom;
  final int tel;
  final String email;
  final String adresse;

  const User({
    required this.code,
    required this.nom,
    required this.tel,
    required this.email,
    required this.adresse,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'nom': nom,
      'tel': tel,
      'email': email,
      'adresse': adresse,
    };
  }

  @override
  String toString() {
    return 'User{code: $code, nom: $nom, tel: $tel, email: $email, adresse: $adresse}';
  }
}

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const appTitle = '';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        primaryColor: Colors.black,
        fontFamily: 'Roboto Slab',
      ),
      home: const Scaffold(
        backgroundColor: Color(0xFFD8D8D8),
        body: MyCustomForm(),
      ),
    );
  }
}

Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String deviceId;

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.androidId;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor;
  }
  return deviceId;
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

@override
class MyCustomFormState extends State<MyCustomForm> {
  String _message = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _code = TextEditingController();
  final TextEditingController _nom = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _tel = TextEditingController();
  final TextEditingController _adresse = TextEditingController();
  bool _isObscure = true;
  Future<void> _submitForm(context) async {
    // Get the values from the controllers
    final code = _code.text;
    final nom = _nom.text;
    final tel = _tel.text;
    final email = _email.text;
    final adresse = _adresse.text;

    late String deviceId;
    deviceId = await getDeviceId();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        print('cnx');
        _message = 'Connexion interrompue';
        _showToast();
      });
      return;
    } else {
      const url = 'http://10.10.2.168/app_ferri/ws_utilisateur.php';
      final response = await http.post(Uri.parse(url), body: {
        'code': code,
        'nom': nom,
        'tel': tel,
        'email': email,
        'adresse': adresse,
        'device_id': deviceId,
      });
      final data = json.decode(response.body);
      setState(() {
        _message = data['message'];
        _showToast();
      });
      if (data['success']) {
        // if(response.statusCode == 200){
        print('succes');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
        _code.clear();
        _nom.clear();
        _tel.clear();
        _email.clear();
        _adresse.clear();
      }
    }
  }

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  void _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12.0,
          ),
          Text(_message),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              width: 100.0,
              height: 70.0,
            ),
            Stack(
              children: const <Widget>[
                Center(
                  child: Text(
                    "S'inscrire",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextFormField(
                controller: _code,
                obscureText: _isObscure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'veuillez saisir votre code client';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  hintText: 'Entrer votre code',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextFormField(
                controller: _nom,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrer votre nom',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextFormField(
                controller: _tel,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrer votre numero Tel',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextFormField(
                controller: _email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  if (!value.contains('@')) {
                    return 'veuillez saisir un email valide';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrer votre Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextFormField(
                controller: _adresse,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrer votre Adresse ',
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 200.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, submit it
                        _submitForm(context);

                        final user = User(
                          code: int.parse(_code.text),
                          nom: _nom.text,
                          tel: int.parse(_tel.text),
                          email: _email.text,
                          adresse: _adresse.text,
                        );

                        await LocalDatabaseHelper.instance.insertUser(user);

                        // Display the fetched users.
                        final List<User> users =
                            await LocalDatabaseHelper.instance.fetchUsers();
                        for (User user in users) {
                          print(user);
                        }
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF114D4A),
                    ),
                  ),
                  child: const Text(
                    'valider',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
