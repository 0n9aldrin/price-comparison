//import 'package:flutter/material.dart';
//
//Drawer drawer(context) {
//  return Drawer(
//    // Add a ListView to the drawer. This ensures the user can scroll
//    // through the options in the drawer if there isn't enough vertical
//    // space to fit everything.
//    child: ListView(
//      // Important: Remove any padding from the ListView.
//      padding: EdgeInsets.zero,
//      children: <Widget>[
//        DrawerHeader(
//          child: Row(
//            children: <Widget>[
//              SizedBox(
//                width: 10,
//              ),
//              SizedBox(
//                width: 10,
//              ),
//              Expanded(
//                child: Text(
//                  'fullName',
//                  style: TextStyle(color: Colors.white),
//                ),
//              ),
//            ],
//          ),
//          decoration: BoxDecoration(
//            color: Colors.blue,
//          ),
//        ),
//        Column(
//          children: <Widget>[
//            ListTile(
//              leading: Icon(Icons.attach_money),
//              title: Text('Cheapest'),
//              onTap: () {
//                Navigator.of(context).pushAndRemoveUntil(
//                    MaterialPageRoute(builder: (context) {
//                  return Ranking();
//                }), ModalRoute.withName('/ranking'));
//              },
//            ),
//          ],
//        ),
//      ],
//    ),
//  );
//}
