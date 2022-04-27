import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maks/classes/user/index.dart';
import 'package:maks/screens/account/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAccountScreen extends StatefulWidget {
  final User user;

  const EditAccountScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  String name = '';
  String email = '';
  String avatarPath = '';
  
  void update() async {    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if ( token.isEmpty ) return;

      await http.put(
        Uri.parse('http://localhost:3000/users/account'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'name': name,
          'email': email,
          'avatar_path': avatarPath,
        })
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AccountScreen()));
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      name = widget.user.name;
      email = widget.user.email;
      avatarPath = widget.user.avatarPath ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Обновить аккаунт', style: TextStyle(
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
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Имя'
                ),
                autofocus: true,
                onChanged: (value) => setState(() { name = value; }),
                initialValue: name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Почта'
                ),
                onChanged: (value) => setState(() { email = value; }),
                initialValue: email,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Аватар'
                ),
                onChanged: (value) => setState(() { avatarPath = value; }),
                initialValue: avatarPath,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: CupertinoButton(
                child: const Text('Обновить'),
                onPressed: (email.isEmpty || name.isEmpty) 
                  ? null
                  : update,
                color: Theme.of(context).primaryColorDark,
                disabledColor: Theme.of(context).primaryColorLight,
              )
            )
          ],
        ),
      )
    );
  }
}
