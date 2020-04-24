import 'package:flutter/material.dart';
import 'websites/bukalapak.dart';
import 'websites/ebay.dart';
import 'websites/blibli.dart';
import 'websites/tokopedia.dart' as tok;
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:url_launcher/url_launcher.dart';
import 'image_model.dart';
import 'dart:developer';

//class Combined extends StatefulWidget {
//  Combined({Key key, this.search}) : super(key: key);
//  String search;
//
//  @override
//  _CombinedState createState() => _CombinedState();
//}
//
//class _CombinedState extends State<Combined> {
//  CombineHelper combineHelper = CombineHelper();
//  Widget _appBarTitle = Text('Combined Search');
//  Icon _searchIcon = Icon(
//    Icons.search,
//    color: Colors.white,
//  );
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: _appBarTitle,
//        actions: <Widget>[
//          IconButton(
//              icon: _searchIcon,
//              onPressed: () {
//                setState(() {
//                  if (_searchIcon.icon == Icons.search) {
//                    _appBarTitle = TextField(
//                      decoration: new InputDecoration(hintText: 'Search...'),
//                    );
//                    _searchIcon = Icon(
//                      Icons.close,
//                      color: Colors.white,
//                    );
//                  } else {
//                    _searchIcon = Icon(
//                      Icons.search,
//                      color: Colors.white,
//                    );
//                    _appBarTitle = Text('Combined Search');
//                  }
//                });
//              })
//        ],
//      ),
//      body: Column(
//        children: <Widget>[
//          Expanded(
//              child: CombinedGridView(
//            search: widget.search,
//          )),
//          FutureBuilder(
//            builder: (context, snapshot) {
//              return Container(
//                color: Colors.grey,
//                height: 28.0,
//                padding: EdgeInsets.only(right: 20.0),
//                child: Align(
//                    alignment: Alignment.centerRight,
//                    child: Text('Total results: ${snapshot.data}')),
//              );
//            },
//            future: combineHelper.combineTotal(search: widget.search),
//          ),
//        ],
//      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: () {
//          // sort
//        },
//        backgroundColor: Colors.redAccent,
//        label: Text('Filter'),
//        icon: Icon(Icons.filter_list),
//      ),
//    );
//  }
//}

class CombineHelper {
  tok.Tokopedia tokopedia = tok.Tokopedia();
  Ebay ebay = Ebay();
  Bukalapak bukalapak = Bukalapak();
  Blibli blibli = Blibli();

  List<ImageModel> combinedList = [];
  int combinedTotal;

  Future<List<ImageModel>> combineLists({var search, int page}) async {
    combinedList.clear();
    var tokopediaList =
        await tokopedia.getTokopedia(searches: search, page: page);
    log('Combined Tokopedia: ${tokopediaList.length}/60');
    var ebayList =
        await ebay.getEbay(searches: search, page: page, combine: true);
    log('Combined Ebay: ${ebayList.length}/62');
    var bukalapakList =
        await bukalapak.getBukalapak(searches: search, page: page);
    log('Combined Bukalapak: ${bukalapakList.length}/50');
    var blibliList = await blibli.getBlibli(searches: search, page: page);
    log('Combined Blibli: ${blibliList.length}/32');

    for (int x = 0; x < (tokopediaList.length); x++) {
      tokopediaList[x].price = tokopediaList[x].price.replaceAll(',', '');
      tokopediaList[x].price = int.parse(tokopediaList[x].price);
      combinedList.add(tokopediaList[x]);
    }

    for (int x = 0; x < (ebayList.length); x++) {
      ebayList[x].price = ebayList[x].price.replaceAll(',', '');
      ebayList[x].price = int.parse(ebayList[x].price);
      combinedList.add(ebayList[x]);
    }

    for (int x = 0; x < (blibliList.length); x++) {
      blibliList[x].price = blibliList[x].price.replaceAll(',', '');
      blibliList[x].price = int.parse(blibliList[x].price);
      combinedList.add(blibliList[x]);
    }

    for (int x = 0; x < (bukalapakList.length); x++) {
      bukalapakList[x].price = bukalapakList[x].price.replaceAll(',', '');
      bukalapakList[x].price = int.parse(bukalapakList[x].price);
      combinedList.add(bukalapakList[x]);
    }
    log('Combined List Length: ${combinedList.length}');

    mergeSort(combinedList, 0, combinedList.length - 1);
    log('Sorted');

    return combinedList;
  }

  void merge(List list, int leftIndex, int middleIndex, int rightIndex) {
    int leftSize = middleIndex - leftIndex + 1;
    int rightSize = rightIndex - middleIndex;

    List leftList = new List(leftSize);
    List rightList = new List(rightSize);

    for (int i = 0; i < leftSize; i++) leftList[i] = list[leftIndex + i];
    for (int j = 0; j < rightSize; j++)
      rightList[j] = list[middleIndex + j + 1];

    int i = 0, j = 0;
    int k = leftIndex;

    while (i < leftSize && j < rightSize) {
      if (leftList[i].price <= rightList[j].price) {
        list[k] = leftList[i];
        i++;
      } else {
        list[k] = rightList[j];
        j++;
      }
      k++;
    }

    while (i < leftSize) {
      list[k] = leftList[i];
      i++;
      k++;
    }

    while (j < rightSize) {
      list[k] = rightList[j];
      j++;
      k++;
    }
  }

  void mergeSort(List list, int leftIndex, int rightIndex) {
    if (leftIndex < rightIndex) {
      int middleIndex = (rightIndex + leftIndex) ~/ 2;
      mergeSort(list, leftIndex, middleIndex);
      mergeSort(list, middleIndex + 1, rightIndex);

      merge(list, leftIndex, middleIndex, rightIndex);
    }
  }

  Future<int> combineTotal({var search}) async {
    dynamic tokopediaTotal = await tokopedia.getTotal(searches: search);
    dynamic ebayTotal = await ebay.getTotal(searches: search);
    dynamic bukalapakTotal = await bukalapak.getTotal(searches: search);
    dynamic blibliTotal = await blibli.getTotal(searches: search);

    tokopediaTotal = tokopediaTotal.replaceAll(',', '');
    tokopediaTotal = int.parse(tokopediaTotal);
    ebayTotal = ebayTotal.replaceAll(',', '');
    ebayTotal = int.parse(ebayTotal);
    bukalapakTotal = bukalapakTotal.replaceAll(',', '');
    bukalapakTotal = int.parse(bukalapakTotal);
    blibliTotal = blibliTotal.replaceAll(',', '');
    blibliTotal = int.parse(blibliTotal);

    combinedTotal = tokopediaTotal + ebayTotal + bukalapakTotal + blibliTotal;

    log('Combined total: $combinedTotal');

    return combinedTotal;
  }
}
//
//class CombinedGridView extends StatefulWidget {
//  final search;
//  static int PAGE_SIZE = 205;
//
//  CombinedGridView({Key key, @required this.search}) : super(key: key);
//
//  @override
//  _CombinedGridViewState createState() => _CombinedGridViewState();
//}
//
//class _CombinedGridViewState extends State<CombinedGridView>
//    with AutomaticKeepAliveClientMixin<CombinedGridView> {
//  CombineHelper combineHelper = CombineHelper();
//
//  @override
//  Widget build(BuildContext context) {
//    return PagewiseGridView.count(
//      pageSize: CombinedGridView.PAGE_SIZE,
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
//        log('Loading next page');
//        return combineHelper.combineLists(
//            page: pageIndex, search: widget.search);
//      },
//    );
//  }
//
//  Widget _itemBuilder(BuildContext context, ImageModel entry, int _) {
//    Color getColor() {
//      if (entry.title == 'Error') {
//        return Color(0xFF323131);
//      } else {
//        return Colors.grey[600];
//      }
//    }
//
//    String getTitle() {
//      if (entry.title == 'Error') {
//        return 'Scroll Down For More';
//      } else {
//        return entry.title;
//      }
//    }
//
//    String getWebsite() {
//      if (entry.title == 'Error') {
//        return '';
//      } else {
//        return entry.website;
//      }
//    }
//
//    String getPrice() {
//      if (entry.title == 'Error') {
//        return '';
//      } else {
//        entry.price = '${entry.price}'.replaceAllMapped(
//            new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
//            (Match m) => '${m[1]},');
//        return 'RP ${entry.price}';
//      }
//    }
//
//    String getImage() {
//      if (entry.title == 'Error') {
//        return 'http://pixsector.com/cache/0688783e/avbf566659ab2bdf82f87.png';
//      } else {
//        return entry.img;
//      }
//    }
//
//    return Container(
//      decoration: BoxDecoration(
//        border: Border.all(color: Colors.grey[600]),
//      ),
//      child: GestureDetector(
//        onTap: () {
//          showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                return AlertDialog(
//                  backgroundColor: Color(0xFF323131),
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(20.0)),
//                  content: Container(
//                    height: 400.0,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        Align(
//                            alignment: Alignment.centerRight,
//                            child: Icon(Icons.clear)),
//                        SizedBox(height: 10.0),
//                        Expanded(
//                          flex: 1,
//                          child: Container(
//                            child: Text(getTitle()),
//                          ),
//                        ),
//                        Expanded(
//                          flex: 3,
//                          child: Container(
//                            decoration: BoxDecoration(
//                              color: Colors.grey[200],
//                              image: DecorationImage(
//                                  image: NetworkImage(getImage()),
//                                  fit: BoxFit.fill),
//                            ),
//                          ),
//                        ),
//                        Expanded(
//                          flex: 1,
//                          child: Container(
//                            child: Text('Hello There'),
//                          ),
//                        )
//                      ],
//                    ),
//                  ),
//                );
//              });
//        },
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
//                      color: Colors.grey[200],
//                      image: DecorationImage(
//                          image: NetworkImage(getImage()), fit: BoxFit.fill),
//                    ),
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
//                            child: Text(getTitle(),
//                                style: TextStyle(fontSize: 12.0))))),
//              ),
//              SizedBox(height: 8.0),
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 8.0),
//                child: Text(
//                  getPrice(),
//                  style: TextStyle(fontWeight: FontWeight.bold),
//                ),
//              ),
//              SizedBox(height: 8.0),
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 8.0),
//                child: Text(
//                  getWebsite(),
//                ),
//              ),
//              SizedBox(height: 4.0),
//            ]),
//      ),
//    );
//  }
//
//  @override
//  bool get wantKeepAlive => true;
//}
