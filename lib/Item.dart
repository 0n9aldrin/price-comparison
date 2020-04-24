import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Item extends StatefulWidget {
  final String title;
  final String url;
  final dynamic price;
  final String image;
  final String website;
  final int rating;
  final int reviews;

  Item(
      {this.title,
      this.url,
      this.price,
      this.image,
      this.website,
      this.rating,
      this.reviews});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int x = 0; x < widget.rating; x++) {
      stars.add(
        Icon(
          Icons.star,
          size: 15,
        ),
      );
    }
    for (int x = 0; x < (5 - widget.rating); x++) {
      stars.add(
        Icon(
          Icons.star_border,
          size: 15,
        ),
      );
    }
    stars.add(
      Text(
        ' (${widget.reviews})',
        style: TextStyle(fontSize: 12),
      ),
    );

    if (widget.website == null) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  if (await canLaunch(widget.url)) {
                    await launch(widget.url);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: DecorationImage(
                          image: NetworkImage(widget.image), fit: BoxFit.fill)),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                      height: 30.0,
                      child: SingleChildScrollView(
                          child: Text(widget.title,
                              style: TextStyle(fontSize: 12.0))))),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'RP ${widget.price}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: stars,
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]),
//          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  if (await canLaunch(widget.url)) {
                    await launch(widget.url);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.only(
//                          topRight: Radius.circular(20),
//                          topLeft: Radius.circular(20)),
                      color: Colors.grey[200],
                      image: DecorationImage(
                          image: NetworkImage(widget.image), fit: BoxFit.fill)),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                      height: 30.0,
                      child: SingleChildScrollView(
                          child: Text(widget.title,
                              style: TextStyle(fontSize: 12.0))))),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'RP ${widget.price}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 2.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.website,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: stars,
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
