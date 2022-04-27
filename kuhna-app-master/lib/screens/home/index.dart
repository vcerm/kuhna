import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:maks/classes/service/index.dart';
import 'package:maks/classes/user/index.dart';
import 'package:maks/components/service-card/index.dart';
import 'package:maks/screens/account/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Service> services = [];
  
  void getServices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if ( token == null ) return;

    try {
      final response = await http.get(Uri.parse('http://localhost:3000/services'), headers: {
        'Authorization': 'Bearer ' + token
      });
      
      final data = json.decode(response.body);
      final List<Service> _services = [];
      for (final item in data) {
        _services.add(Service(
          id: item['id'], 
          number: item['number'], 
          desc: item['description'], 
          avatarPath: item['avatar_path'],
          owner: User(
            id: item['owner']['id'],
            name: item['owner']['name'], 
            email: item['owner']['email'], 
            avatarPath: item['owner']['avatar_path']
          ), 
        ));
      }

      setState(() { services = _services; });
    } catch (e) {
      log(e.toString());
    }
  }
  
  @override
  void initState() {
    super.initState();
    getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () => Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => const AccountScreen())
          ),
        ),
        title: const Text('Главная', style: TextStyle(
          color: Colors.white
        )),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: services.map((service) => ServiceCard(service: service)).toList()
        )
      )
    );
  }
}