import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import '../product.dart';
import 'dart:developer';
import 'package:pricecomparison/main.dart';
import 'dart:io';
import 'package:pricecomparison/Item.dart';
import 'package:flutter/material.dart';

class Shopee {
  String search;
  int searchLength;
  var future;
  var json;

  Future<dynamic> getTotal({String searches}) async {
    try {
      search = searches;
      search = search.replaceAll(' ', '%20');

      var json = await getJson(page: 0);
      var total = json['total_count'];
      total = '$total'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return total;
    } on NoSuchMethodError {}
  }

  Future<dynamic> getTotal1({String searches, int page}) async {
    try {
      future = await getShopee(searches: searches, page: page);
      var total = json[0]['total'];
      total = '$total'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return total;
    } on NoSuchMethodError {}
  }

  Future<List<Product>> getShopee({String searches, int page}) async {
    try {
      search = searches;
      search = search.replaceAll(' ', '%20');
      json = await getJson(page: page);
      List<Product> items = getData(json: json);

      return items;
    } on NoSuchMethodError {}
  }

  List<Product> getData({var json}) {
    List<Product> items = [];
    for (int x = 1; x < searchLength; x++) {
      Product imageModel = Product();
      String tempPrice = (json[x]['price']).toStringAsFixed(0);
      tempPrice = '$tempPrice'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      imageModel.title = json[x]['name'];
      imageModel.price = tempPrice;
      imageModel.url = json[x]['url'];
      imageModel.img = json[x]['image_url'];
      imageModel.website = 'Shopee';
      imageModel.rating = json[x]['rating'].toDouble();
      var reviewCount = 0;
      if (imageModel.rating != 0) {
        reviewCount = json[x]['review_count'];
      }
      imageModel.reviews = reviewCount;
      items.add(imageModel);
    }
    return items;
  }

  Future<dynamic> getJson({int page}) async {
    var res = await http.get(
        'https://price-web-scraper.herokuapp.com/api/?keyword=$search&page=$page');
    log('Shopee http called');
    if (res.statusCode == 200) {
      String data = res.body;
      dynamic json = jsonDecode(data);
      searchLength = json.length;
      return json;
    } else {
      throw Exception('Blibli error: statusCode= ${res.statusCode}');
    }
  }
}

class ShopeeGridView extends StatefulWidget {
  ShopeeGridView({this.shopee});
  Shopee shopee;
  @override
  State<StatefulWidget> createState() {
    return ShopeeGridViewState();
  }
}

class ShopeeGridViewState extends State<ShopeeGridView>
    with AutomaticKeepAliveClientMixin<ShopeeGridView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget buildCtn() {
    if (globalSearch == null) {
      return Center(
        child: Text('Please search item'),
      );
    }
    if (shopeeItems == null) {
      widget.shopee
          .getShopee(page: shopeeCounter, searches: globalSearch)
          .then((result) {
        setState(() {
          shopeeItems = result;
        });
      });
      return Center(
        child: SizedBox(
          height: 70.0,
          width: 70.0,
          child: Platform.isIOS
              ? CupertinoActivityIndicator(
                  radius: 20,
                )
              : RefreshProgressIndicator(
                  backgroundColor: Colors.grey,
                  strokeWidth: 5.0,
                ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(15.0),
      physics: ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.555,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (c, i) => Item(
        title: shopeeItems[i].title,
        url: shopeeItems[i].url,
        image: shopeeItems[i].img,
        price: shopeeItems[i].price,
        reviews: shopeeItems[i].reviews,
        rating: shopeeItems[i].rating,
        website: shopeeItems[i].website,
        combined: false,
      ),
      itemCount: shopeeItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      child: buildCtn(),
      header: WaterDropHeader(),
      onRefresh: () async {
        //monitor fetch data from network
        if (shopeeItems != null) {
          if (shopeeSorted == false) {
            shopeeItems.clear();
            await Future.delayed(Duration(milliseconds: 1000));
            shopeeCounter = 0;
            shopeeItems = await widget.shopee
                .getShopee(page: shopeeCounter, searches: globalSearch);
          } else {
            setState(() {});
          }
        }

        if (mounted) setState(() {});
        _refreshController.refreshCompleted();

        /*
        if(failed){
         _refreshController.refreshFailed();
        }
      */
      },
      onLoading: () async {
        //monitor fetch data from network
        if (shopeeItems != null) {
          await Future.delayed(Duration(milliseconds: 1000));
          shopeeCounter++;
          List<Product> tempList = await widget.shopee
              .getShopee(page: shopeeCounter, searches: globalSearch);
          for (int x = 0; x < tempList.length; x++) {
            shopeeItems.add(tempList[x]);
          }
          if (shopeeSorted == true) {
            sortDataByPrice(list: shopeeItems);
          }
        }
        if (mounted) setState(() {});
        _refreshController.loadComplete();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
