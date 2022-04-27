import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maks/screens/account/index.dart';
import 'package:maks/screens/register/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  
  void login() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        })
      );

      final token = json.decode(response.body)['token'];
      final userId = json.decode(response.body)['id'];
      
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setInt('user_id', userId);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AccountScreen()));
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход', style: TextStyle(
          color: Colors.white
        )),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Почта'
                ),
                autofocus: true,
                onChanged: (value) => setState(() { email = value; }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Пароль'
                ),
                onChanged: (value) => setState(() { password = value; }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: CupertinoButton(
                child: const Text('Войти'),
                onPressed: (email.isEmpty || password.isEmpty) ? null : login,
                color: Theme.of(context).primaryColorDark,
                disabledColor: Theme.of(context).primaryColorLight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: CupertinoButton(
                child: const Text('Регистрация'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen())
                ),
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ],
        ),
      )
    );
  }
}
