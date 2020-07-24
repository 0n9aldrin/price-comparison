import 'package:flutter/material.dart';
import 'package:pricecomparison/fancy_fab.dart';
import 'package:pricecomparison/search1.dart';
import 'package:pricecomparison/simple_tab.dart';
import 'package:pricecomparison/websites/lazada.dart';
import 'package:pricecomparison/websites/shopee.dart';
import 'package:provider/provider.dart';
import 'const.dart';
import 'main.dart';
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

class ColorChange extends ChangeNotifier {
  Color getColor(int index) {
    return colors[index];
  }

  void changeColor(int index) {
    Color color = colors[index];
    notifyListeners();
  }
}

List<Color> colors = const [
  tokopediaColor,
  ebayColor,
  blibliColor,
  bukalapakColor,
  shopeeColor,
  Colors.deepPurple,
];

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
  TabController controller;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

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
    controller = TabController(length: colors.length, vsync: this);
  }

//  void _select() {
//    setState(() {
//      selectedTab = tabs[controller.index];
//    });
//  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
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
    return DefaultTabController(
      length: 6,
      child: AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, 0)
          ..scale(scaleFactor)
          ..rotateY(isDrawerOpen ? -0.5 : 0),
        duration: Duration(milliseconds: 250),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor:
                  Provider.of<ColorChange>(context).getColor(controller.index),
              leading: isDrawerOpen
                  ? IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        setState(() {
                          xOffset = 0;
                          yOffset = 0;
                          scaleFactor = 1;
                          isDrawerOpen = false;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        setState(() {
                          xOffset = 230;
                          yOffset = 150;
                          scaleFactor = 0.6;
                          isDrawerOpen = true;
                        });
                      }),
              actions: <Widget>[
                IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    var tempSearch = await showSearch1(
                        context: context, delegate: CustomSearchDelegate());
                    print(tempSearch);
                    setState(
                      () {
                        globalSearch = tempSearch;
                      },
                    );
                  },
                ),
              ],
              bottom: TabBar(
                onTap: (index) {
                  Provider.of<ColorChange>(context, listen: false)
                      .changeColor(index);
                },
                controller: controller,
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
              controller: controller,
              children: <Widget>[
                Scrollbar(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: TokopediaGridView(),
                          ),
//                        FutureBuilder(
//                          builder: (context, snapshot) {
//                            return Container(
//                              color: Colors.grey,
//                              height: 28.0,
//                              padding: EdgeInsets.only(left: 20.0),
//                              child: Align(
//                                alignment: Alignment.centerLeft,
//                                child: Text('Total results: ${snapshot.data}'),
//                              ),
//                            );
//                          },
//                          future: tokopedia.getTotal(searches: globalSearch),
//                        ),
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
//                      totalWidget(
//                        future: ebay.getTotal1(
//                            searches: globalSearch, page: ebayCounter),
//                      )
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
//                      FutureBuilder(
//                        builder: (context, snapshot) {
//                          return Container(
//                            color: Colors.grey,
//                            height: 28.0,
//                            padding: EdgeInsets.only(left: 20.0),
//                            child: Align(
//                                alignment: Alignment.centerLeft,
//                                child: Text('Total results: ${snapshot.data}')),
//                          );
//                        },
//                        future: blibli.getTotal1(
//                            searches: globalSearch, page: blibliCounter),
//                      )
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
//                      FutureBuilder(
//                        builder: (context, snapshot) {
//                          return Container(
//                            color: Colors.grey,
//                            height: 28.0,
//                            padding: EdgeInsets.only(left: 20.0),
//                            child: Align(
//                                alignment: Alignment.centerLeft,
//                                child: Text('Total results: ${snapshot.data}')),
//                          );
//                        },
//                        future: bukalapak.getTotal1(
//                            searches: globalSearch, page: bukalapakCounter),
//                      )
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
//                      FutureBuilder(
//                        builder: (context, snapshot) {
//                          return Container(
//                            color: Colors.grey,
//                            height: 28.0,
//                            padding: EdgeInsets.only(left: 20.0),
//                            child: Align(
//                                alignment: Alignment.centerLeft,
//                                child: Text('Total results: ${snapshot.data}')),
//                          );
//                        },
//                        future: shopee.getTotal1(
//                            searches: globalSearch, page: shopeeCounter),
//                      )
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
                        Container(
                          color: Colors.grey,
                          height: 28.0,
                          padding: EdgeInsets.only(left: 20.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Total results: ')),
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
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget();
  }
}
