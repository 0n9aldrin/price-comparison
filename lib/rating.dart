import 'package:flutter/material.dart';

class Rating {
  Rating({this.ratingNumber});
  var ratingNumber;

  List<Widget> getRating() {
    if (ratingNumber >= 0 && ratingNumber < 0.25) {
      List<Widget> temp = [
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
      ];
      return temp;
    } else if (ratingNumber >= 0.25 && ratingNumber < 0.75) {
      List<Widget> temp = [
        Icon(
          Icons.star_half,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
      ];
      return temp;
    } else if (ratingNumber >= 0.75 && ratingNumber < 1.25) {
      List<Widget> temp = [
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
      ];
      return temp;
    } else if (ratingNumber >= 1.25 && ratingNumber < 1.75) {
      List<Widget> temp = [
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star_half,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
      ];
      return temp;
    } else if (ratingNumber >= 1.75 && ratingNumber < 2.25) {
      List<Widget> temp = [
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
      ];
      return temp;
    } else if (ratingNumber >= 2.25 && ratingNumber < 2.75) {
      List<Widget> temp = [
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star_half,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
      ];
      return temp;
    } else if (ratingNumber >= 2.75 && ratingNumber < 3.25) {
      List<Widget> temp = [
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
      ];
      return temp;
    } else if (ratingNumber >= 3.25 && ratingNumber < 3.75) {
      List<Widget> temp = [
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star_half,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
      ];
      return temp;
    } else if (ratingNumber >= 3.75 && ratingNumber < 4.25) {
      List<Widget> temp = [
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star_border,
          size: 15,
        ),
      ];
      return temp;
    } else if (ratingNumber >= 4.25 && ratingNumber < 4.75) {
      List<Widget> temp = [
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star_half,
          size: 15,
        ),
      ];
      return temp;
    } else if (ratingNumber >= 4.75 && ratingNumber <= 5) {
      List<Widget> temp = [
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 15,
        ),
      ];
      return temp;
    }
  }
}
