import 'dart:async';
import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'Local Database/database_helper.dart';
import 'Login.dart';

void main() {
  runApp( const SplashScreen());
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
   const MyHomePage({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  bool hasDataInLocalDB = false;
  LocalDatabaseHelper databaseHelper = LocalDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    checkLocalDBData().then((hasData) {
      setState(() {
        hasDataInLocalDB = hasData;
      });
      Timer(const Duration(seconds: 5), () {
        if (hasDataInLocalDB) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignUp()),
          );
        }
      });
    });
  }

  Future<bool> checkLocalDBData() async {
    final users = await databaseHelper.fetchUsers();
    return users.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD8D8D8),
      child: const Image(
        image: AssetImage('images/3_3.png'),
        height: 200,
        width: 800,
      ),
    );
  }
}
