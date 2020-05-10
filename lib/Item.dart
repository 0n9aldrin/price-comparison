import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animations/animations.dart';

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
          size: 12,
        ),
      );
    }
    for (int x = 0; x < (5 - widget.rating); x++) {
      stars.add(
        Icon(
          Icons.star_border,
          size: 12,
        ),
      );
    }
    stars.add(
      Text(
        ' (${widget.reviews})',
        style: TextStyle(fontSize: 10),
      ),
    );

    if (widget.website != null) {
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
  final int rating;
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
  final int rating;
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

class _DetailsPage extends StatelessWidget {
  _DetailsPage(
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
  final int rating;
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
                  '$rating/5',
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
  final int rating;
  final int reviews;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return _DetailsPage(
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
