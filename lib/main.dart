import 'package:flutter/material.dart';
import 'package:pricecomparison/fancy_fab.dart';
import 'package:pricecomparison/image_model.dart';
import 'package:pricecomparison/websites/lazada.dart';
import 'package:pricecomparison/websites/shopee.dart';
import 'websites/blibli.dart';
import 'websites/tokopedia.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Item.dart';
import 'dart:developer';
import 'websites/ebay.dart';
import 'websites/bukalapak.dart';
import 'combined.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

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

String globalSearch;
int blibliCounter = 0;
int ebayCounter = 1;
int tokopediaCounter = 0;
int bukalapakCounter = 1;
int lazadaCounter = 1;
int shopeeCounter = 0;
int combinedCounter = 0;
List<ImageModel> blibliItems;
bool blibliSorted = false;
List<ImageModel> tokopediaItems;
bool tokopediaSorted = false;
List<ImageModel> bukalapakItems;
bool bukalapakSorted = false;
List<ImageModel> ebayItems;
bool ebaySorted = false;
List<ImageModel> lazadaItems;
bool lazadaSorted = false;
List<ImageModel> shopeeItems;
bool shopeeSorted = false;
List<ImageModel> combinedItems;
bool combinedSorted = false;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Tokopedia tokopedia = Tokopedia();
  Ebay ebay = Ebay();
  Bukalapak bukalapak = Bukalapak();
  Blibli blibli = Blibli();
  CombineHelper combineHelper = CombineHelper();
  Lazada lazada = Lazada();
  Shopee shopee = Shopee();
  File _file;

  Widget _appBarTitle = Text('Combined Search');
  Icon _searchIcon = Platform.isIOS
      ? Icon(
          CupertinoIcons.search,
          color: CupertinoColors.activeBlue,
        )
      : Icon(
          Icons.search,
          color: Colors.white,
        );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Tokopedia"),
    1: Text("Blibli"),
    2: Text("Ebay"),
    3: Text("Bukalapak"),
    4: Text("Shopee"),
    5: Text("Combined"),
  };

  dynamic whichGrid() {
    if (segmentedControlGroupValue == 0) {
      return TokopediaGridView();
    } else if (segmentedControlGroupValue == 1) {
      return BlibliGridView();
    } else if (segmentedControlGroupValue == 2) {
      return EbayGridView();
    } else if (segmentedControlGroupValue == 3) {
      return BukalapakGridView();
    } else if (segmentedControlGroupValue == 4) {
      return CombinedGridView();
    }
  }

  dynamic whichTotal() {
    if (segmentedControlGroupValue == 0) {
      return tokopedia.getTotal(searches: globalSearch);
    } else if (segmentedControlGroupValue == 1) {
      return blibli.getTotal(searches: globalSearch);
    } else if (segmentedControlGroupValue == 2) {
      return ebay.getTotal(searches: globalSearch);
    } else if (segmentedControlGroupValue == 3) {
      return bukalapak.getTotal(searches: globalSearch);
    } else if (segmentedControlGroupValue == 4) {
      return combineHelper.combineTotal(search: globalSearch);
    }
  }

  Widget totalWidget({Future<dynamic> future}) {
    return FutureBuilder(
        builder: (context, snapshot) {
          return Container(
            color: Colors.grey,
            height: 28.0,
            padding: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Total results: ${snapshot.data}'),
            ),
          );
        },
        future: future);
  }

  Widget mainWidget() {
    if (Platform.isIOS) {
      return Theme(
        data: ThemeData.light(),
        child: SafeArea(
          child: Scaffold(
            appBar: CupertinoNavigationBar(
              leading: IconButton(
                  icon: _searchIcon,
                  onPressed: () {
                    setState(() {
                      if (_searchIcon.icon == CupertinoIcons.search) {
                        _appBarTitle = CupertinoTextField(
                          onSubmitted: (value) {
                            setState(() {
                              globalSearch = value;
                              log('submit: $globalSearch');
                            });
                          },
                          placeholder: 'Search...',
                          placeholderStyle:
                              TextStyle(color: CupertinoColors.activeBlue),
                          style: TextStyle(color: CupertinoColors.activeBlue),
                        );
//                            TextField(
//                          onSubmitted: (value) {
//                            setState(() {
//                              globalSearch = value;
//                              log('submit: $globalSearch');
//                            });
//                          },
//                          decoration:
//                              new InputDecoration(hintText: 'Search...'),
//                        );
                        _searchIcon = Icon(
                          CupertinoIcons.clear_thick,
                          color: CupertinoColors.activeBlue,
                        );
                      } else {
                        _searchIcon = Icon(
                          CupertinoIcons.search,
                          color: CupertinoColors.activeBlue,
                        );
                        _appBarTitle = Text('Combined Search');
                      }
                    });
                  }),
              middle: _appBarTitle,
              trailing: Icon(
                CupertinoIcons.photo_camera_solid,
                color: Colors.blue,
              ),
            ),
            body: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: CupertinoSlidingSegmentedControl(
                      thumbColor: CupertinoColors.activeBlue,
                      groupValue: segmentedControlGroupValue,
                      children: myTabs,
                      onValueChanged: (i) {
                        setState(() {
                          segmentedControlGroupValue = i;
                        });
                      }),
                ),
                Expanded(
                  child: whichGrid(),
                ),
                FutureBuilder(
                  builder: (context, snapshot) {
                    return Container(
                      color: CupertinoColors.inactiveGray,
                      height: 28.0,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Total results: ${snapshot.data}'),
                      ),
                    );
                  },
                  future: whichTotal(),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return DefaultTabController(
        length: 6,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: _appBarTitle,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      try {
                        var file = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (file != null) {
                          setState(() {
                            _file = file;
                          });
                        }
                      } catch (e) {
                        print(e);
                      }
                    })
              ],
              leading: IconButton(
                  icon: _searchIcon,
                  onPressed: () {
                    setState(() {
                      if (_searchIcon.icon == Icons.search) {
                        _appBarTitle = TextField(
                          onSubmitted: (value) {
                            setState(() {
                              globalSearch = value;
                              log('submit: $globalSearch');
                            });
                          },
                          decoration:
                              new InputDecoration(hintText: 'Search...'),
                        );
                        _searchIcon = Icon(
                          Icons.close,
                          color: Colors.white,
                        );
                      } else {
                        _searchIcon = Icon(
                          Icons.search,
                          color: Colors.white,
                        );
                        _appBarTitle = Text('Combined Search');
                      }
                    });
                  }),
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: 'Tokopedia',
                  ),
                  Tab(
                    text: 'Ebay',
                  ),
                  Tab(
                    text: 'Blibli',
                  ),
                  Tab(
                    text: 'Bukalapak',
                  ),
                  Tab(
                    text: 'Shopee',
                  ),
                  Tab(
                    text: 'Combined',
                  ),
                ],
                isScrollable: true,
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                Scrollbar(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: TokopediaGridView(),
                          ),
                          FutureBuilder(
                            builder: (context, snapshot) {
                              return Container(
                                color: Colors.grey,
                                height: 28.0,
                                padding: EdgeInsets.only(left: 20.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text('Total results: ${snapshot.data}'),
                                ),
                              );
                            },
                            future: tokopedia.getTotal(searches: globalSearch),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 40,
                        right: 15,
                        child: FancyFab(
                          onPressedPrice: () {
                            sortDataByPrice(list: tokopediaItems);
                            tokopediaSorted = true;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Scrollbar(
                    child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: EbayGridView(
                            ebay: ebay,
                          ),
                        ),
                        totalWidget(
                          future: ebay.getTotal1(
                              searches: globalSearch, page: ebayCounter),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 40,
                      right: 15,
                      child: FancyFab(
                        onPressedPrice: () {
                          sortDataByPrice(list: ebayItems);
                          ebaySorted = true;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                )),
                Scrollbar(
                    child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: BlibliGridView(
                            blibli: blibli,
                          ),
                        ),
                        FutureBuilder(
                          builder: (context, snapshot) {
                            return Container(
                              color: Colors.grey,
                              height: 28.0,
                              padding: EdgeInsets.only(left: 20.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text('Total results: ${snapshot.data}')),
                            );
                          },
                          future: blibli.getTotal1(
                              searches: globalSearch, page: blibliCounter),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 40,
                      right: 15,
                      child: FancyFab(
                        onPressedPrice: () {
                          sortDataByPrice(list: blibliItems);
                          blibliSorted = true;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                )),
                Scrollbar(
                    child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: BukalapakGridView(
                            bukalapak: bukalapak,
                          ),
                        ),
                        FutureBuilder(
                          builder: (context, snapshot) {
                            return Container(
                              color: Colors.grey,
                              height: 28.0,
                              padding: EdgeInsets.only(left: 20.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text('Total results: ${snapshot.data}')),
                            );
                          },
                          future: bukalapak.getTotal1(
                              searches: globalSearch, page: bukalapakCounter),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 40,
                      right: 15,
                      child: FancyFab(
                        onPressedPrice: () {
                          sortDataByPrice(list: bukalapakItems);
                          bukalapakSorted = true;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                )),
                Scrollbar(
                    child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: ShopeeGridView(
                            shopee: shopee,
                          ),
                        ),
                        FutureBuilder(
                          builder: (context, snapshot) {
                            return Container(
                              color: Colors.grey,
                              height: 28.0,
                              padding: EdgeInsets.only(left: 20.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text('Total results: ${snapshot.data}')),
                            );
                          },
                          future: shopee.getTotal1(
                              searches: globalSearch, page: shopeeCounter),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 40,
                      right: 15,
                      child: FancyFab(
                        onPressedPrice: () {
                          sortDataByPrice(list: shopeeItems);
                          shopeeSorted = true;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                )),
                Scrollbar(
                    child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: CombinedGridView(),
                        ),
                        FutureBuilder(
                          builder: (context, snapshot) {
                            return Container(
                              color: Colors.grey,
                              height: 28.0,
                              padding: EdgeInsets.only(left: 20.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text('Total results: ${snapshot.data}')),
                            );
                          },
                          future:
                              combineHelper.combineTotal(search: globalSearch),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 40,
                      right: 15,
                      child: FancyFab(),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget();
  }
}

void convertPriceToString({List<ImageModel> list}) {
  for (int x = 0; x < list.length; x++) {
    list[x].price = '${list[x].price}'.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

void convertPriceToInt({List<ImageModel> list}) {
  for (int x = 0; x < list.length; x++) {
    list[x].price = list[x].price.replaceAll(',', '');
    list[x].price = int.parse(list[x].price);
  }
}

void sortDataByPrice({List<ImageModel> list}) {
  log('Sorting');
  convertPriceToInt(list: list);
  CombineHelper().mergeSort(list, 0, list.length - 1);
  log('Sorted');
  convertPriceToString(list: list);
}
