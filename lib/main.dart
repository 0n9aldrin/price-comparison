import 'package:flutter/material.dart';
import 'package:pricecomparison/fancy_fab.dart';
import 'package:pricecomparison/image_model.dart';
import 'blibli.dart';
import 'tokopedia.dart' as tok;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Item.dart';
import 'dart:developer';
import 'ebay.dart';
import 'bukalapak.dart';
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
int combinedCounter = 0;
List<ImageModel> blibliItems;
bool blibliSorted = false;
List<ImageModel> tokopediaItems;
bool tokopediaSorted = false;
List<ImageModel> bukalapakItems;
bool bukalapakSorted = false;
List<ImageModel> ebayItems;
bool ebaySorted = false;
List<ImageModel> combinedItems;
bool combinedSorted = false;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  tok.Tokopedia tokopedia = tok.Tokopedia();
  Ebay ebay = Ebay();
  Bukalapak bukalapak = Bukalapak();
  Blibli blibli = Blibli();
  CombineHelper combineHelper = CombineHelper();
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
    4: Text("Combined"),
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
        length: 5,
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
                          child: EbayGridView(),
                        ),
                        FutureBuilder(
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
                          future: ebay.getTotal(searches: globalSearch),
                        ),
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
                          child: BlibliGridView(),
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
                          future: blibli.getTotal(
                            searches: globalSearch,
                          ),
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
                          child: BukalapakGridView(),
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
                          future: bukalapak.getTotal(searches: globalSearch),
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

class BlibliGridView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BlibliGridViewState();
  }
}

class BlibliGridViewState extends State<BlibliGridView>
    with AutomaticKeepAliveClientMixin<BlibliGridView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Blibli blibli = Blibli();

  Widget buildCtn() {
    if (globalSearch == null) {
      return Center(
        child: Text('Please search item'),
      );
    }
    if (blibliItems == null) {
      blibli
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
        reviews: 12,
        rating: 4,
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
            blibliItems = await blibli.getBlibli(
                page: blibliCounter, searches: globalSearch);
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
          List<ImageModel> tempList = await blibli.getBlibli(
              page: blibliCounter, searches: globalSearch);
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

class TokopediaGridView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TokopediaGridViewState();
  }
}

class _TokopediaGridViewState extends State<TokopediaGridView>
    with AutomaticKeepAliveClientMixin<TokopediaGridView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  tok.Tokopedia tokopedia = tok.Tokopedia();

  Widget buildCtn() {
    if (globalSearch == null) {
      return Center(
        child: Text('Please search item'),
      );
    }
    if (tokopediaItems == null) {
      tokopedia.getAds(searches: globalSearch).then((result) {
        setState(() {
          if (result.length == 0) {
            tokopedia
                .getTokopedia(searches: globalSearch, page: tokopediaCounter)
                .then((result1) {
              setState(() {
                tokopediaItems = result1;
              });
            });
          } else {
            tokopediaItems = result;
          }
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
        title: tokopediaItems[i].title,
        url: tokopediaItems[i].url,
        image: tokopediaItems[i].img,
        price: tokopediaItems[i].price,
        reviews: 12,
        rating: 4,
      ),
      itemCount: tokopediaItems.length,
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
        if (tokopediaItems != null) {
          if (tokopediaSorted == false) {
            tokopediaItems.clear();
            await Future.delayed(Duration(milliseconds: 1000));
            log('$globalSearch');
            tokopediaCounter = 0;
            tokopediaItems = await tokopedia.getAds(searches: globalSearch);
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
        if (tokopediaItems != null) {
          await Future.delayed(Duration(milliseconds: 1000));
          tokopediaCounter++;
          List<ImageModel> tempList = await tokopedia.getTokopedia(
              searches: globalSearch, page: (tokopediaCounter - 1));
          for (int x = 0; x < tempList.length; x++) {
            tokopediaItems.add(tempList[x]);
          }
          if (tokopediaSorted == true) {
            sortDataByPrice(list: tokopediaItems);
          }
        }

//    pageIndex++;
        if (mounted) setState(() {});
        _refreshController.loadComplete();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BukalapakGridView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BukalapakGridViewState();
  }
}

class _BukalapakGridViewState extends State<BukalapakGridView>
    with AutomaticKeepAliveClientMixin<BukalapakGridView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Bukalapak bukalapak = Bukalapak();

  Widget buildCtn() {
    if (globalSearch == null) {
      return Center(
        child: Text('Please search item'),
      );
    }
    if (bukalapakItems == null) {
      bukalapak
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
        reviews: 12,
        rating: 4,
      ),
      itemCount: bukalapakItems.length,
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
        if (bukalapakItems != null) {
          if (bukalapakSorted == false) {
            bukalapakItems.clear();
            await Future.delayed(Duration(milliseconds: 1000));
            log('$globalSearch');
            bukalapakCounter = 1;
            bukalapakItems = await bukalapak.getBukalapak(
                searches: globalSearch, page: bukalapakCounter);
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
          List<ImageModel> tempList = await bukalapak.getBukalapak(
              searches: globalSearch, page: bukalapakCounter);
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

class EbayGridView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EbayGridViewState();
  }
}

class _EbayGridViewState extends State<EbayGridView>
    with AutomaticKeepAliveClientMixin<EbayGridView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Ebay ebay = Ebay();

  Widget buildCtn() {
    if (globalSearch == null) {
      return Center(
        child: Text('Please search item'),
      );
    }
    if (ebayItems == null) {
      ebay.getEbay(searches: globalSearch, page: ebayCounter).then((result) {
        setState(() {
          ebayItems = result;
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
        title: ebayItems[i].title,
        url: ebayItems[i].url,
        image: ebayItems[i].img,
        price: ebayItems[i].price,
        reviews: 12,
        rating: 4,
      ),
      itemCount: ebayItems.length,
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
        if (ebayItems != null) {
          if (ebaySorted == false) {
            ebayItems.clear();
            await Future.delayed(Duration(milliseconds: 1000));
            ebayCounter = 1;
            ebayItems =
                await ebay.getEbay(searches: globalSearch, page: ebayCounter);
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
        if (ebayItems != null) {
          await Future.delayed(Duration(milliseconds: 1000));
          ebayCounter++;
          List<ImageModel> tempList =
              await ebay.getEbay(searches: globalSearch, page: ebayCounter);
          for (int x = 0; x < tempList.length; x++) {
            ebayItems.add(tempList[x]);
          }
          if (ebaySorted == true) {
            sortDataByPrice(list: ebayItems);
          }
        }
//    pageIndex++;
        if (mounted) setState(() {});
        _refreshController.loadComplete();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CombinedGridView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CombinedGridViewState();
  }
}

class _CombinedGridViewState extends State<CombinedGridView>
    with AutomaticKeepAliveClientMixin<CombinedGridView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  CombineHelper combineHelper = CombineHelper();
  List<ImageModel> data;

  Widget buildCtn() {
    if (globalSearch == null) {
      return Center(
        child: Text('Please search item'),
      );
    }
    if (data == null) {
      combineHelper
          .combineLists(search: globalSearch, page: combinedCounter)
          .then((result) {
        setState(() {
          data = result;
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
        title: data[i].title,
        url: data[i].url,
        image: data[i].img,
        price: data[i].price,
        website: data[i].website,
        rating: 5,
        reviews: 23,
      ),
      itemCount: data.length,
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
        if (data != null) {
          data.clear();
          await Future.delayed(Duration(milliseconds: 1000));
          log('${globalSearch}');
          combinedCounter = 0;
          data = await combineHelper.combineLists(
              search: globalSearch, page: combinedCounter);
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
        if (data != null) {
          await Future.delayed(Duration(milliseconds: 1000));
          combinedCounter++;
          log('Loading Page $combinedCounter');
          List<ImageModel> tempList = await combineHelper.combineLists(
              search: globalSearch, page: combinedCounter);
          log('Length of b4 added data: ${data.length}');

          int temp = tempList.length;
          log('Length of templist: $temp');
          for (int x = 0; x < temp; x++) {
            log('index $x');
            log('data length ${data.length}');
            data.add(tempList[x]);
          }
          log('Done adding');
          data.sort((a, b) => a.price.compareTo(b.price));
          log('Done merging');

          log('Length before kill: ${data.length}');
          ImageModel imageModel = ImageModel();

          data = imageModel.removeDuplicates(data: data);
          log('Length after kill: ${data.length}');
        }
        if (mounted) setState(() {});
        _refreshController.loadComplete();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
