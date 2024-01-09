import 'entry_point_commercial.dart';
import 'entry_point_gerant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'entry_point.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

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
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _codeController = TextEditingController();
  String _message = '';
  bool _isObscure = true;

  Future<void> _login() async {
    // Check for internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _message = 'Connexion interrompue';
        _showToast();
      });
      return;
    } else {
      const String url = 'http://10.10.2.168/app_ferri/login.php';
      // Replace with your PHP script URL
      final response = await http.post(
        Uri.parse(url),
        body: {'code': _codeController.text},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);
      setState(() {
        _message = data['message'];
        _showToast();
      });

      if (data['success']) {
        final pdata = json.decode(response.body);
        if (pdata['success']) {
          String profil = pdata['profil'];
          int id = pdata['id'];
          print(pdata['id']);
          // Save the user ID in shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('id', id);

          if (profil == 'client') {
            // Login successful for client, navigate to the next screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => EntryPointPage(id: id)),
            );
          } else if (profil == 'commercial') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => EntryPointCPage(id: id)),
            );
          } else if (profil == 'gerant') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => EntryPointPageG(id: id)),
            );
          }
        }
      }
    }
  }

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast.init(context);
  }

  Future<void> _showToast() async {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
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
    return Scaffold(
      backgroundColor: const Color(0xFFD8D8D8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Image(
            image: AssetImage('images/3_3.png'),
            height: 200,
            width: 800,
          ),
          const SizedBox(
            width: 100.0,
            height: 70.0,
          ),
          Stack(
            children: const <Widget>[
              Center(
                child: Text(
                  "S'identifier",
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
              controller: _codeController,
              obscureText: _isObscure,
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
          Center(
            child: SizedBox(
              width: 180.0,
              height: 40.0,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF114D4A),
                ),
                child: const Text(
                  'Se connecter',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
