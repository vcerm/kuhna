import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maks/classes/service/index.dart';
import 'package:maks/screens/account/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditService extends StatefulWidget {
  final Service service;

  const EditService({ Key? key, required this.service }) : super(key: key);

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  String number = '';
  String description = '';
  String avatarPath = '';
  
  void update() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if ( token == null ) return;
    
    try {
      await http.put(
        Uri.parse('http://localhost:3000/services/${widget.service.id}'),
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
  void initState() {
    super.initState();

    setState(() {
      number = widget.service.number;
      description = widget.service.desc;
      avatarPath = widget.service.avatarPath ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Обновить услугу', style: TextStyle(
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
                  hintText: 'Номер'
                ),
                autofocus: true,
                onChanged: (value) => setState(() { number = value; }),
                initialValue: number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Картинка'
                ),
                onChanged: (value) => setState(() { avatarPath = value; }),
                initialValue: avatarPath,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Описание'
                ),
                maxLines: 6,
                onChanged: (value) => setState(() { description = value; }),
                initialValue: description,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: CupertinoButton(
                child: const Text('Обновить'),
                onPressed: ( number.isEmpty || description.isEmpty )
                  ? null
                  : update,
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