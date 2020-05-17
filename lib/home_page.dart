import 'package:flutter/material.dart';
import 'package:pricecomparison/fancy_fab.dart';
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
import 'main.dart';

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
  FocusNode myFocusNode;

  Widget _searchIcon = Platform.isIOS
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
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
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
      return BlibliGridView(
        blibli: blibli,
      );
    } else if (segmentedControlGroupValue == 2) {
      return EbayGridView(
        ebay: ebay,
      );
    } else if (segmentedControlGroupValue == 3) {
      return BukalapakGridView(
        bukalapak: bukalapak,
      );
    } else if (segmentedControlGroupValue == 4) {
      return ShopeeGridView(
        shopee: shopee,
      );
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
      return shopee.getTotal(searches: globalSearch);
    } else if (segmentedControlGroupValue == 5) {
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
        child: DefaultTabController(
          length: 6,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: _searchIcon,
                      onTap: () {
                        setState(() {
                          _searchIcon = Container();
                          myFocusNode.requestFocus();
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CupertinoTextField(
                        textInputAction: TextInputAction.search,
                        focusNode: myFocusNode,
                        onSubmitted: (value) {
                          setState(() {
                            _searchIcon = Platform.isIOS
                                ? Icon(
                                    CupertinoIcons.search,
                                    color: CupertinoColors.activeBlue,
                                  )
                                : Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  );
                            globalSearch = value;
                            log('submit: $globalSearch');
                          });
                        },
                        placeholder: "Search...",
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.photo_camera_solid,
                        color: CupertinoColors.activeBlue,
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
                bottom: TabBar(
                  indicatorColor: CupertinoColors.activeBlue,
                  labelColor: CupertinoColors.activeBlue,
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
                              future:
                                  tokopedia.getTotal(searches: globalSearch),
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
                                    child: Text(
                                        'Total results: ${snapshot.data}')),
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
                                    child: Text(
                                        'Total results: ${snapshot.data}')),
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
                                    child: Text(
                                        'Total results: ${snapshot.data}')),
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
                                    child: Text(
                                        'Total results: ${snapshot.data}')),
                              );
                            },
                            future: combineHelper.combineTotal(
                                search: globalSearch),
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
        ),
      );
    } else {
      return DefaultTabController(
        length: 6,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: <Widget>[
                  GestureDetector(
                    child: _searchIcon,
                    onTap: () {
                      setState(() {
                        _searchIcon = Container();
                        myFocusNode.requestFocus();
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      focusNode: myFocusNode,
                      onSubmitted: (value) {
                        setState(() {
                          _searchIcon = Platform.isIOS
                              ? Icon(
                                  CupertinoIcons.search,
                                  color: CupertinoColors.activeBlue,
                                )
                              : Icon(
                                  Icons.search,
                                  color: Colors.white,
                                );
                          globalSearch = value;
                          log('submit: $globalSearch');
                        });
                      },
                      decoration: new InputDecoration(hintText: 'Search...'),
                    ),
                  ),
                ],
              ),
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
