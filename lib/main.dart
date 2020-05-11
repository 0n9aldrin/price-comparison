import 'package:flutter/material.dart';
import 'package:pricecomparison/fancy_fab.dart';
import 'package:pricecomparison/image_model.dart';
import 'package:pricecomparison/websites/lazada.dart';
import 'package:pricecomparison/websites/shopee.dart';
import 'websites/blibli.dart';
import 'websites/tokopedia.dart';
import 'dart:developer';
import 'websites/ebay.dart';
import 'websites/bukalapak.dart';
import 'combined.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

// Search keyword variable
String globalSearch;

// Page index that increases when user scrolls down
int blibliCounter = 0;
int ebayCounter = 1;
int tokopediaCounter = 0;
int bukalapakCounter = 1;
int lazadaCounter = 1;
int shopeeCounter = 0;
int combinedCounter = 0;

// List of objects (ImageModel) to store product information
List<ImageModel> blibliItems;
List<ImageModel> tokopediaItems;
List<ImageModel> bukalapakItems;
List<ImageModel> ebayItems;
List<ImageModel> lazadaItems;
List<ImageModel> shopeeItems;
List<ImageModel> combinedItems;

// Boolean to determine whether data is sorted
bool combinedSorted = false;
bool tokopediaSorted = false;
bool shopeeSorted = false;
bool lazadaSorted = false;
bool ebaySorted = false;
bool bukalapakSorted = false;
bool blibliSorted = false;

// Converts the price to string and format with commas
void convertPriceToString({List<ImageModel> list}) {
  for (int x = 0; x < list.length; x++) {
    list[x].price = '${list[x].price}'.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

// Converts the price to an integer fro comparisons
void convertPriceToInt({List<ImageModel> list}) {
  for (int x = 0; x < list.length; x++) {
    list[x].price = list[x].price.replaceAll(',', '');
    list[x].price = int.parse(list[x].price);
  }
}

// Sorts the data by price
void sortDataByPrice({List<ImageModel> list}) {
  log('Sorting');
  convertPriceToInt(list: list);
  CombineHelper().mergeSort(list, 0, list.length - 1);
  log('Sorted');
  convertPriceToString(list: list);
}
