import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animations/animations.dart';
import 'const.dart';
import 'rating.dart';
import 'details_page.dart';

class Item extends StatefulWidget {
  final String title;
  final String url;
  final dynamic price;
  final String image;
  final String website;
  final double rating;
  final int reviews;
  final bool combined;

  Item(
      {this.title,
      this.url,
      this.price,
      this.image,
      this.website,
      this.rating,
      this.reviews,
      this.combined});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    List<Widget> stars = Rating(ratingNumber: widget.rating).getRating();

    if (widget.combined == true) {
      return OpenContainerWrapper(
        transitionType: ContainerTransitionType.fade,
        title: widget.title,
        image: widget.image,
        url: widget.url,
        price: widget.price,
        website: widget.website,
        rating: widget.rating,
        reviews: widget.reviews,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return CombinedCard(
            openContainer: openContainer,
            title: widget.title,
            url: widget.url,
            price: widget.price,
            image: widget.image,
            website: widget.website,
            rating: widget.rating,
            reviews: widget.reviews,
            stars: stars,
          );
        },
      );
    } else {
      return OpenContainerWrapper(
        transitionType: ContainerTransitionType.fade,
        title: widget.title,
        image: widget.image,
        url: widget.url,
        price: widget.price,
        website: widget.website,
        rating: widget.rating,
        reviews: widget.reviews,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return WebCard(
            openContainer: openContainer,
            title: widget.title,
            url: widget.url,
            price: widget.price,
            image: widget.image,
            website: widget.website,
            rating: widget.rating,
            reviews: widget.reviews,
            stars: stars,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class WebCard extends StatelessWidget {
  WebCard({
    this.openContainer,
    this.title,
    this.url,
    this.price,
    this.image,
    this.website,
    this.rating,
    this.reviews,
    this.stars,
  });

  final VoidCallback openContainer;
  final String title;
  final String url;
  final dynamic price;
  final String image;
  final String website;
  final double rating;
  final int reviews;
  final List<Widget> stars;

  @override
  Widget build(BuildContext context) {
    log('$website');
    return _InkWellOverlay(
      height: 225,
      width: 100,
      openContainer: openContainer,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colors[website]),
//          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.fill),
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
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'RP ${price}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 2.0),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                children: <Widget>[
                  Row(
                    children: stars,
                  ),
                  Text(
                    '($reviews)',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}

class CombinedCard extends StatelessWidget {
  CombinedCard({
    this.openContainer,
    this.title,
    this.url,
    this.price,
    this.image,
    this.website,
    this.rating,
    this.reviews,
    this.stars,
  });

  final VoidCallback openContainer;
  final String title;
  final String url;
  final dynamic price;
  final String image;
  final String website;
  final double rating;
  final int reviews;
  final List<Widget> stars;

  @override
  Widget build(BuildContext context) {
    return _InkWellOverlay(
      height: 225,
      width: 100,
      openContainer: openContainer,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]),
//          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.fill),
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
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'RP ${price}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 2.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: stars,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                website,
                style: TextStyle(fontSize: 12.0),
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    this.openContainer,
    this.width,
    this.height,
    this.child,
  });

  final VoidCallback openContainer;
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Theme(
        data: ThemeData.dark(),
        child: Material(
          child: InkWell(
            onTap: openContainer,
            child: child,
          ),
        ),
      ),
    );
  }
}

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper(
      {this.closedBuilder,
      this.transitionType,
      this.title,
      this.url,
      this.price,
      this.image,
      this.website,
      this.rating,
      this.reviews});

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final String title;
  final String url;
  final dynamic price;
  final String image;
  final String website;
  final double rating;
  final int reviews;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return DetailsPage(
          title: title,
          image: image,
          url: url,
          price: price,
          website: website,
          rating: rating,
          reviews: reviews,
        );
      },
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
