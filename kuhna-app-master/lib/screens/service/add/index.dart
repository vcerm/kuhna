import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maks/screens/account/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddService extends StatefulWidget {
  const AddService({ Key? key }) : super(key: key);

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  String number = '';
  String description = '';
  String avatarPath = '';

  void create() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if ( token == null ) return;
    
    try {
      await http.post(
        Uri.parse('http://localhost:3000/services'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'number': number,
          'description': description,
          'avatar_path': avatarPath,
        })
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AccountScreen()));
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить услугу', style: TextStyle(
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
                  hintText: 'Номер'
                ),
                autofocus: true,
                onChanged: (value) => setState(() { number = value; }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Картинка'
                ),
                onChanged: (value) => setState(() { avatarPath = value; }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Описание'
                ),
                maxLines: 6,
                onChanged: (value) => setState(() { description = value; }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: CupertinoButton(
                child: const Text('Добавить'),
                onPressed: ( number.isEmpty || description.isEmpty )
                  ? null
                  : create,
                color: Theme.of(context).primaryColorDark,
                disabledColor: Theme.of(context).primaryColorLight,
              ),
            ),
          ]
        )
      )
    );
  }
}