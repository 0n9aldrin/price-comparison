import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    List<Map> drawerItems = [
      {'icon': Icons.access_time, 'title': 'Adoption'},
      {'icon': Icons.mail, 'title': 'Donation'},
      {'icon': Icons.add, 'title': 'Add pet'},
      {'icon': Icons.favorite, 'title': 'Favorites'},
      {'icon': Icons.mail, 'title': 'Messages'},
      {'icon': Icons.person, 'title': 'Profile'},
    ];
    return SafeArea(
      child: Container(
        color: Colors.deepPurple,
        padding: EdgeInsets.only(top: 50, bottom: 70, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Miroslava Savitskaya',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text('Active Status',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))
                  ],
                )
              ],
            ),
            Column(
              children: drawerItems
                  .map((element) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              element['icon'],
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(element['title'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))
                          ],
                        ),
                      ))
                  .toList(),
            ),
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Log out',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
