import 'package:flutter/material.dart';
import 'package:maks/screens/account/index.dart';
import 'package:maks/screens/login/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({ Key? key }) : super(key: key);

  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if ( token.isEmpty ) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(235, 221, 211, 1),
        primaryColorDark: const Color.fromRGBO(125, 85, 56, 1),
        primaryColorLight: const Color.fromRGBO(125, 85, 56, 0.5),
      ),
      home: FutureBuilder<bool>(
        future: checkAuth(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Scaffold(
              body: Text('Загрузка...'),
            );
          }

          var isAuth = snap.requireData;
          return isAuth ? const AccountScreen() : const LoginScreen();
        },
      ),
    );
  }
}