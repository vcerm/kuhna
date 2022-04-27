import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maks/classes/user/index.dart';
import 'package:http/http.dart' as http;
import 'package:maks/components/service-card/index.dart';
import 'package:maks/screens/account/edit/index.dart';
import 'package:maks/screens/home/index.dart';
import 'package:maks/screens/login/index.dart';
import 'package:maks/screens/service/add/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../classes/service/index.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({ Key? key }) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? user;
  List<Service> userServices = [];
  
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if ( token == null ) return;

    try {
      final response = await http.get(Uri.parse('http://localhost:3000/users/account'), headers: {
        'Authorization': 'Bearer ' + token
      });
      
      final data = json.decode(response.body);
      setState(() {
        user = User(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          avatarPath: data['avatar_path']
        );
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void getUserServices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if ( token == null ) return;

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/users/account/services'), 
        headers: { 'Authorization': 'Bearer ' + token }
      );
      
      final data = json.decode(response.body);
      
      final List<Service> services = [];
      for (var item in data) {
        services.add(Service(
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
      setState(() {
        userServices = services;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getUserServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => const HomeScreen())
          ),
        ),
        title: const Text('Аккаунт', style: TextStyle(
          color: Colors.white
        )),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            user == null 
            ? const Text('Загрузка...')
            : Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(user!.finalAvatarPath)
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(user!.name, 
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(user!.email),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => EditAccountScreen(user: user!))
                                ), 
                                icon: Icon(Icons.edit, color: Theme.of(context).primaryColorDark)
                              ),
                              IconButton(
                                onPressed: logout,
                                icon: Icon(Icons.exit_to_app, color: Theme.of(context).primaryColorDark)
                              )
                            ],
                          )
                        ]
                      ),
                    )
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: userServices.map((service) => ServiceCard(service: service)).toList(),
            ),
            CupertinoButton(
              child: const Text('Добавить услугу'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddService())
              ),
              color: const Color.fromRGBO(125, 85, 56, 1),
            ),
          ]
        ),
      )
    );
  }
}