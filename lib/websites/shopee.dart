import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import '../image_model.dart';
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
    search = searches;
    search = search.replaceAll(' ', '%20');

    var json = await getJson(page: 0);
    var total = json['total_count'];
    total = '$total'.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return total;
  }

  Future<dynamic> getTotal1({String searches, int page}) async {
    future = await getShopee(searches: searches, page: page);
    var total = json['total_count'];
    total = '$total'.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return total;
  }

  Future<List<ImageModel>> getShopee({String searches, int page}) async {
    search = searches;
    search = search.replaceAll(' ', '%20');
    json = await getJson(page: page);
    List<ImageModel> items = getData(json: json);

    return items;
  }

  List<ImageModel> getData({var json}) {
    List<ImageModel> items = [];
    for (int x = 0; x < searchLength; x++) {
      ImageModel imageModel = ImageModel();
      String tempPrice =
          (json['items'][x]['price'] / 100000).toStringAsFixed(0);
      tempPrice = '$tempPrice'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      imageModel.title = json['items'][x]['name'];
      imageModel.price = tempPrice;
      String shopId = json['items'][x]['shopid'].toString();
      String itemId = json['items'][x]['itemid'].toString();
      String url = 'https://shopee.co.id/' +
          json['items'][0]['name'].replaceAll(' ', '-') +
          '-i.' +
          shopId +
          '.' +
          itemId;
      imageModel.url = url;
      imageModel.img =
          'https://cf.shopee.co.id/file/' + json['items'][x]['image'];
      log("${json['items'][x]['image']}");
      imageModel.website = 'Shopee';
      imageModel.rating =
          json['items'][x]['item_rating']['rating_star'].round();
      var reviewCount = 0;
      if (imageModel.rating != 0) {
        reviewCount = json['items'][x]['item_rating']['rating_count'][0];
      }

      imageModel.reviews = reviewCount;

      items.add(imageModel);
    }
    return items;
  }

  Future<dynamic> getJson({int page}) async {
    log("Shopee html");
    int start = page * 50;
    var headers = {
      'if-none-match-': '55b03-e17607803099ed81f4097a6d08057af3',
    };

    var params = {
      'by': 'relevancy',
      'keyword': '$search',
      'limit': '50',
      'newest': '$start',
      'order': 'desc',
      'page_type': 'search',
      'version': '2',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var res = await http.get('https://shopee.co.id/api/v2/search_items/?$query',
        headers: headers);
    if (res.statusCode == 200) {
      String data = res.body;
      dynamic json = jsonDecode(data);
      searchLength = json['items'].length;
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
            log('$globalSearch');
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
          List<ImageModel> tempList = await widget.shopee
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
