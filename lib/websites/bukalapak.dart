import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Item.dart';
import '../product.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pricecomparison/main.dart';
import 'dart:io';

class Bukalapak {
  String search;
  int searchLength;
  var future;
  var html;

  Future<dynamic> getTotal({String searches}) async {
    try {
      search = searches;
      search = search.replaceAll(' ', '%20');

      var html = await getHtml(page: 0);
      html = parse(html);
      var a = html.querySelectorAll(
          '#display_product_search > div.product-pagination-wrapper > div.pagination > span.last-page');
      dynamic total = int.parse(a[0].text) * 50;
      total = '$total'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return total;
    } on NoSuchMethodError {}
  }

  Future<dynamic> getTotal1({String searches, int page}) async {
    try {
      future = await getBukalapak(searches: searches, page: page);
      var a = html.querySelectorAll(
          '#display_product_search > div.product-pagination-wrapper > div.pagination > span.last-page');
      dynamic total = int.parse(a[0].text) * 50;
      total = '$total'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return total;
    } on NoSuchMethodError {}
  }

  Future<List<Product>> getBukalapak({String searches, int page}) async {
    try {
      search = searches;
      search = search.replaceAll(' ', '%20');

      html = await getHtml(page: page);
      html = parse(html);
      List<Product> items = getData(html: html);
//    for (int x = 0; x < items.length; x++) {
//      print(items[x].img);
//    }
      return items;
    } on NoSuchMethodError {}
  }

  List<Product> getData({var html}) {
    List<Product> items = [];
    List element = html.querySelectorAll('li.col-12--2');
    for (int x = 0; x < element.length; x++) {
      Product imageModel = Product();
      var nameElement = element[x]
          .querySelector('div.product-card > article > div.product-media > a');
      var priceElement = element[x].querySelector(
          'div.product-card > article > div.product-description > div.product-price');
      var imgElement = element[x].querySelector(
          'div.product-card > article > div.product-media > a > picture > img');
      imageModel.title = nameElement.attributes['title'];
      imageModel.url =
          ('https://www.bukalapak.com' + nameElement.attributes['href']);
      dynamic tempPrice = priceElement.attributes['data-reduced-price'];
      tempPrice = '$tempPrice'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      imageModel.price = tempPrice;
      imageModel.img = imgElement.attributes['data-src'];
      imageModel.img = imageModel.img.replaceAll('s-194-194', 'w-1000');
      imageModel.website = 'Bukalapak';

      if (imageModel.img.contains('jpg') ||
          imageModel.img.contains('jpeg') ||
          imageModel.img.contains('png')) {
        items.add(imageModel);
      } else {
        imageModel.img =
            'https://miro.medium.com/max/1400/1*pUEZd8z__1p-7ICIO1NZFA.png';
        items.add(imageModel);
      }
    }

    return (items);
  }

  Future<dynamic> getHtml({int page}) async {
    http.Response response = await http.get(
        'https://www.bukalapak.com/products/s?from=omnisearch&from_keyword_history=false&page=$page&search%5Bkeywords%5D=$search&search_source=omnisearch_organic&source=navbar&utf8=✓');
    log('Bukalapak http called');
    if (response.statusCode == 200) {
      String data = response.body;
      return data;
    } else {
      throw Exception('Bukalapak error: statusCode= ${response.statusCode}');
    }
  }
}

class BukalapakGridView extends StatefulWidget {
  BukalapakGridView({this.bukalapak});
  Bukalapak bukalapak;
  @override
  State<StatefulWidget> createState() {
    return _BukalapakGridViewState();
  }
}

class _BukalapakGridViewState extends State<BukalapakGridView>
    with AutomaticKeepAliveClientMixin<BukalapakGridView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget buildCtn() {
    if (globalSearch == null) {
      return Center(
        child: Text('Please search item'),
      );
    }
    if (bukalapakItems == null) {
      widget.bukalapak
          .getBukalapak(searches: globalSearch, page: bukalapakCounter)
          .then((result) {
        setState(() {
          bukalapakItems = result;
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
        title: bukalapakItems[i].title,
        url: bukalapakItems[i].url,
        image: bukalapakItems[i].img,
        price: bukalapakItems[i].price,
        website: bukalapakItems[i].website,
        combined: false,
        reviews: 12,
        rating: 4,
      ),
      itemCount: bukalapakItems.length,
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
        if (bukalapakItems != null) {
          if (bukalapakSorted == false) {
            bukalapakItems.clear();
            await Future.delayed(Duration(milliseconds: 1000));
            bukalapakCounter = 1;
            bukalapakItems = await widget.bukalapak
                .getBukalapak(searches: globalSearch, page: bukalapakCounter);
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
        if (bukalapakItems != null) {
          await Future.delayed(Duration(milliseconds: 1000));
          bukalapakCounter++;
          log('Loading Page $bukalapakCounter');
          List<Product> tempList = await widget.bukalapak
              .getBukalapak(searches: globalSearch, page: bukalapakCounter);
          for (int x = 0; x < tempList.length; x++) {
            bukalapakItems.add(tempList[x]);
          }
          if (bukalapakSorted == true) {
            sortDataByPrice(list: bukalapakItems);
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
