import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'const.dart';

import 'websites/blibli.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage(
      {this.title,
      this.url,
      this.price,
      this.image,
      this.website,
      this.rating,
      this.reviews});
  final String title;
  final String url;
  final dynamic price;
  final String image;
  final String website;
  final double rating;
  final int reviews;
  @override
  Widget build(BuildContext context) {
    List<BoxShadow> shadowList = [
      BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
    ];
    Blibli blibli = Blibli();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
                child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                )
              ],
            )),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Image(
                  image: NetworkImage(image),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: colors[website],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.share,
                          color: colors[website],
                        ),
                        onPressed: () {})
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: shadowList,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 500,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: 500,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text('Price: RP$price'),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 120,
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 70,
                      decoration: BoxDecoration(
                          color: colors[website],
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: colors[website],
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Text(
                            'Go to website',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailsPage1 extends StatelessWidget {
  DetailsPage1(
      {this.title,
      this.url,
      this.price,
      this.image,
      this.website,
      this.rating,
      this.reviews});
  final String title;
  final String url;
  final dynamic price;
  final String image;
  final String website;
  final double rating;
  final int reviews;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details page')),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.black38,
            height: 300,
            child: Image(
              image: NetworkImage(image),
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'RP $price',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${rating.toStringAsFixed(1)}/5',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                  child: Text(
                    'Go to website',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
