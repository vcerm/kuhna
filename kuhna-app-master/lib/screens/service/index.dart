import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:maks/classes/service/index.dart';
import 'package:maks/screens/account/index.dart';
import 'package:maks/screens/service/edit/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServiceScreen extends StatefulWidget {
  final Service service;

  const ServiceScreen({ Key? key, required this.service }) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  int? userId;

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    setState(() { this.userId = userId; });
  }

  delete() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if ( token.isEmpty ) return false;
    
    try {
      await http.delete(
        Uri.parse('http://localhost:3000/services/${widget.service.id}'),
        headers: { 'Authorization': 'Bearer ' + token }
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AccountScreen()));
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service.number, style: const TextStyle(
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(widget.service.finalAvatarPath)
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
                            child: Text(widget.service.owner.name, 
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(widget.service.owner.email),
                          ),
                          Row(
                            children: [
                              if ( widget.service.owner.id == userId ) IconButton(
                                onPressed: delete, 
                                icon: const Icon(Icons.delete, color: Color.fromARGB(255, 201, 0, 0))
                              ),
                              if ( widget.service.owner.id == userId ) IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => EditService(service: widget.service))
                                ), 
                                icon: Icon(Icons.edit, color: Theme.of(context).primaryColorDark)
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
            Text(
              widget.service.desc,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ]
        )
      )
    );
  }
}