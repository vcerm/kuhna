import 'package:flutter/material.dart';
import 'package:maks/classes/service/index.dart';
import 'package:maks/screens/service/index.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({ Key? key, required this.service }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ServiceScreen(service: service))
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(235, 221, 211, 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(service.finalAvatarPath),
              )
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        service.desc, 
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        service.number,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ),
                  ]
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}