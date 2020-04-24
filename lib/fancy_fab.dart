import 'dart:math';

import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressedPrice;
  final String tooltip;
  final Color color;

  FancyFab({this.onPressedPrice, this.tooltip, this.color});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 48.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: widget.color,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget search() {
    return Container(
      child: FloatingActionButton.extended(
        onPressed: null,
        tooltip: 'Search',
        label: Text('Search'),
        icon: Icon(Icons.search),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton.extended(
        onPressed: widget.onPressedPrice,
        tooltip: 'Price',
        label: Text('Price'),
        icon: Icon(Icons.attach_money),
      ),
    );
  }

  Widget inbox() {
    return Container(
      child: FloatingActionButton.extended(
        onPressed: null,
        tooltip: 'Rating',
        label: Text('Rating'),
        icon: Icon(Icons.star),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton.extended(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        label: Text('Filter   '),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: search(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: image(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: inbox(),
        ),
        toggle(),
      ],
    );
  }
}
