import 'package:flutter/material.dart';
import 'package:pricecomparison/combined_home.dart';
import 'package:pricecomparison/product.dart';
import 'package:pricecomparison/simple_tab.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'combined.dart';
import 'package:flutter/cupertino.dart';
import 'const.dart';
import 'home_page.dart';
import 'simple_tab.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ColorChange>(
      create: (context) => ColorChange(),
      child: MaterialApp(
        theme: ThemeData.light(),
        home: CombinedHome(),
      ),
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

// List of objects (Product) to store product information
List<Product> blibliItems;
List<Product> tokopediaItems;
List<Product> bukalapakItems;
List<Product> ebayItems;
List<Product> lazadaItems;
List<Product> shopeeItems;
List<Product> combinedItems;

// Boolean to determine whether data is sorted
bool combinedSorted = false;
bool tokopediaSorted = false;
bool shopeeSorted = false;
bool lazadaSorted = false;
bool ebaySorted = false;
bool bukalapakSorted = false;
bool blibliSorted = false;

// Converts the price to string and format with commas
void convertPriceToString({List<Product> list}) {
  for (int x = 0; x < list.length; x++) {
    list[x].price = '${list[x].price}'.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

// Converts the price to an integer fro comparisons
void convertPriceToInt({List<Product> list}) {
  for (int x = 0; x < list.length; x++) {
    list[x].price = list[x].price.replaceAll(',', '');
    list[x].price = int.parse(list[x].price);
  }
}

// Sorts the data by price
void sortDataByPrice({List<Product> list}) {
  log('Sorting');
  convertPriceToInt(list: list);
  CombineHelper().mergeSort(list, 0, list.length - 1);
  log('Sorted');
  convertPriceToString(list: list);
}
