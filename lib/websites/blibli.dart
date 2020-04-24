import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import '../image_model.dart';
import 'dart:developer';

class Blibli {
  String search;
  int searchLength;

  Future<dynamic> getTotal({String searches}) async {
    search = searches;
    search = search.replaceAll(' ', '%20');

    var json = await getJson(page: 0);
    var total = json['data']['paging']['total_item'];
    total = '$total'.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return total;
  }

  Future<List<ImageModel>> getBlibli({String searches, int page}) async {
    search = searches;
    search = search.replaceAll(' ', '%20');

    var json = await getJson(page: page);
    List<ImageModel> items = getData(json: json);

    return items;
  }

  List<ImageModel> getData({var json}) {
    List<ImageModel> items = [];
    for (int x = 0; x < searchLength; x++) {
      ImageModel imageModel = ImageModel();

      String tempPrice =
          json['data']['products'][x]['price']['minPrice'].toStringAsFixed(0);
      tempPrice = '$tempPrice'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      imageModel.title = json['data']['products'][x]['name'];
      imageModel.price = tempPrice;
      imageModel.url =
          'https://www.blibli.com' + json['data']['products'][x]['url'];
      imageModel.img = json['data']['products'][x]['images'][0];
      imageModel.website = 'Blibli';

      items.add(imageModel);
    }
    return items;
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

//
//class BlibliGridView extends StatefulWidget {
//  final search;
//  static int PAGE_SIZE = 32;
//
//  BlibliGridView({Key key, @required this.search}) : super(key: key);
//
//  @override
//  _BlibliGridViewState createState() => _BlibliGridViewState();
//}
//
//class _BlibliGridViewState extends State<BlibliGridView>
//    with AutomaticKeepAliveClientMixin<BlibliGridView> {
//  Blibli blibli = Blibli();
//
//  @override
//  Widget build(BuildContext context) {
//    return PagewiseGridView.count(
//      pageSize: BlibliGridView.PAGE_SIZE,
//      crossAxisCount: 3,
//      mainAxisSpacing: 8.0,
//      crossAxisSpacing: 8.0,
//      childAspectRatio: 0.555,
//      padding: EdgeInsets.all(15.0),
//      retryBuilder: (context, callback) {
//        return RaisedButton(child: Text('Retry'), onPressed: () => callback());
//      },
//      noItemsFoundBuilder: (context) {
//        return Text('No Items Found');
//      },
//      loadingBuilder: (context) {
//        return Center(
//          child: SizedBox(
//              height: 70.0,
//              width: 70.0,
//              child: RefreshProgressIndicator(
//                backgroundColor: Colors.grey,
//                strokeWidth: 5.0,
//              )),
//        );
//      },
//      itemBuilder: this._itemBuilder,
//      pageFuture: (pageIndex) {
//        log('Loading next Blibli page');
//        return blibli.getBlibli(page: pageIndex, searches: widget.search);
//      },
//    );
//  }
//
//  Widget _itemBuilder(BuildContext context, ImageModel entry, int _) {
//    return Container(
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.grey[600]),
//        ),
//        child: Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Expanded(
//                child: GestureDetector(
//                  onTap: () async {
//                    if (await canLaunch(entry.url)) {
//                      await launch(entry.url);
//                    }
//                  },
//                  child: Container(
//                    decoration: BoxDecoration(
//                        color: Colors.grey[200],
//                        image: DecorationImage(
//                            image: NetworkImage(entry.img), fit: BoxFit.fill)),
//                  ),
//                ),
//              ),
//              SizedBox(height: 8.0),
//              Expanded(
//                child: Padding(
//                    padding: EdgeInsets.symmetric(horizontal: 8.0),
//                    child: SizedBox(
//                        height: 30.0,
//                        child: SingleChildScrollView(
//                            child: Text(entry.title,
//                                style: TextStyle(fontSize: 12.0))))),
//              ),
//              SizedBox(height: 8.0),
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 8.0),
//                child: Text(
//                  'RP ${entry.price}',
//                  style: TextStyle(fontWeight: FontWeight.bold),
//                ),
//              ),
//              SizedBox(height: 8.0)
//            ]));
//  }
//
//  @override
//  bool get wantKeepAlive => true;
//}
