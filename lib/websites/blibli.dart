import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../product.dart';
import 'dart:developer';
import 'package:pricecomparison/main.dart';
import 'dart:io';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pricecomparison/Item.dart';
import 'package:flutter/cupertino.dart';

class Blibli {
  String search;
  int searchLength;
  var json;
  var future;

  Future<dynamic> getTotal({String searches}) async {
    try {
      search = searches;
      search = search.replaceAll(' ', '%20');

      var json = await getJson(page: 0);
      var total = json['data']['paging']['total_item'];
      total = '$total'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return total;
    } on NoSuchMethodError {}
  }

  Future<dynamic> getTotal1({String searches, int page}) async {
    try {
      future = await getBlibli(searches: searches, page: page);
      var total = json['data']['paging']['total_item'];
      total = '$total'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return total;
    } on NoSuchMethodError {}
  }

  Future<List<Product>> getBlibli({String searches, int page}) async {
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
    for (int x = 0; x < searchLength; x++) {
      Product imageModel = Product();

      String tempPrice =
          json['data']['products'][x]['price']['minPrice'].toStringAsFixed(0);
      tempPrice = '$tempPrice'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      imageModel.title = json['data']['products'][x]['name'];
      imageModel.price = tempPrice;
      imageModel.url =
          'https://www.blibli.com' + json['data']['products'][x]['url'];
      imageModel.img = json['data']['products'][x]['images'][0];
      imageModel.img = imageModel.img.replaceAll('medium', 'full');
      imageModel.rating =
          json['data']['products'][x]['review']['rating'].toDouble();
      imageModel.reviews = json['data']['products'][x]['review']['count'];
      imageModel.website = 'Blibli';

      items.add(imageModel);
    }

    return items;
  }

  Future<dynamic> getDescription() async {
    var res = await http.get(
        'https://www.blibli.com/backend/product/products/pc--MTA-3414952/_summary?selectedItemSku=TOD-60083-00010-00001');
    log('Blibli http called');
    dynamic json = jsonDecode(res.body);
    return json['data']['description'];
  }

  Future<dynamic> getJson({int page}) async {
    int start = page * 32;
    http.Response response = await http.get(
        'https://www.blibli.com/backend/search/products?page=$page&start=$start&searchTerm=$search&intent=false&merchantSearch=true&multiCategory=true&customUrl=&sort=0&channelId=mobile-web&catIntent=false&showFacet=true');

    if (response.statusCode == 200) {
      String data = response.body;

      dynamic json = jsonDecode(data);
      searchLength = json['data']['products'].length;
      return json;
    } else {
      throw Exception('Blibli error: statusCode= ${response.statusCode}');
    }
  }
}

class BlibliGridView extends StatefulWidget {
  BlibliGridView({this.blibli});
  Blibli blibli;
  @override
  State<StatefulWidget> createState() {
    return BlibliGridViewState();
  }
}

class BlibliGridViewState extends State<BlibliGridView>
    with AutomaticKeepAliveClientMixin<BlibliGridView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget buildCtn() {
    if (globalSearch == null) {
      return Center(
        child: Text('Please search item'),
      );
    }
    if (blibliItems == null) {
      widget.blibli
          .getBlibli(page: blibliCounter, searches: globalSearch)
          .then((result) {
        setState(() {
          blibliItems = result;
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
        title: blibliItems[i].title,
        url: blibliItems[i].url,
        image: blibliItems[i].img,
        price: blibliItems[i].price,
        reviews: blibliItems[i].reviews,
        rating: blibliItems[i].rating,
        website: blibliItems[i].website,
        combined: false,
      ),
      itemCount: blibliItems.length,
    );
  }

//  @override
//  void initState() {
//    super.initState();
//    blibli.getBlibli(page: counter, searches: globalSearch).then((result) {
//      setState(() {
//        data = result;
//      });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      child: buildCtn(),
      header: WaterDropHeader(),
      onRefresh: () async {
        //monitor fetch data from network
        if (blibliItems != null) {
          if (blibliSorted == false) {
            blibliItems.clear();
            await Future.delayed(Duration(milliseconds: 1000));
            log('$globalSearch');
            blibliCounter = 0;
            blibliItems = await widget.blibli
                .getBlibli(page: blibliCounter, searches: globalSearch);
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
        if (blibliItems != null) {
          await Future.delayed(Duration(milliseconds: 1000));
          blibliCounter++;
          List<Product> tempList = await widget.blibli
              .getBlibli(page: blibliCounter, searches: globalSearch);
          for (int x = 0; x < tempList.length; x++) {
            blibliItems.add(tempList[x]);
          }
          if (blibliSorted == true) {
            sortDataByPrice(list: blibliItems);
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
