import 'package:flutter/material.dart';
import 'package:pricecomparison/websites/shopee.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Item.dart';
import 'websites/bukalapak.dart';
import 'websites/ebay.dart';
import 'websites/blibli.dart';
import 'websites/tokopedia.dart' as tok;
import 'product.dart';
import 'dart:developer';
import 'main.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class CombineHelper {
  tok.Tokopedia tokopedia = tok.Tokopedia();
  Ebay ebay = Ebay();
  Bukalapak bukalapak = Bukalapak();
  Blibli blibli = Blibli();
  Shopee shopee = Shopee();

  List<Product> combinedList = [];
  int combinedTotal;

  Future<List<Product>> combineLists({var search, int page}) async {
    combinedList.clear();
    var tokopediaList =
        await tokopedia.getTokopedia(searches: search, page: page);
    log('Combined Tokopedia: ${tokopediaList.length}/60');
    var ebayList = await ebay.getEbay(searches: search, page: page);
    log('Combined Ebay: ${ebayList.length}/62');
    var bukalapakList =
        await bukalapak.getBukalapak(searches: search, page: page);
    log('Combined Bukalapak: ${bukalapakList.length}/50');
    var blibliList = await blibli.getBlibli(searches: search, page: page);
    log('Combined Blibli: ${blibliList.length}/32');
    var shopeeList = await shopee.getShopee(searches: search, page: page);
    log('Combined Shopee: ${shopeeList.length}/50');

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

    for (int x = 0; x < (shopeeList.length); x++) {
      shopeeList[x].price = shopeeList[x].price.replaceAll(',', '');
      shopeeList[x].price = int.parse(shopeeList[x].price);
      combinedList.add(shopeeList[x]);
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
    try {
      dynamic tokopediaTotal = await tokopedia.getTotal(searches: search);
      dynamic ebayTotal = await ebay.getTotal1(searches: search, page: 1);
      dynamic bukalapakTotal =
          await bukalapak.getTotal1(searches: search, page: 1);
      dynamic blibliTotal = await blibli.getTotal1(searches: search, page: 1);
      dynamic shopeeTotal = await shopee.getTotal1(searches: search, page: 1);

      tokopediaTotal = tokopediaTotal.replaceAll(',', '');
      tokopediaTotal = int.parse(tokopediaTotal);
      ebayTotal = ebayTotal.replaceAll(',', '');
      ebayTotal = int.parse(ebayTotal);
      bukalapakTotal = bukalapakTotal.replaceAll(',', '');
      bukalapakTotal = int.parse(bukalapakTotal);
      blibliTotal = blibliTotal.replaceAll(',', '');
      blibliTotal = int.parse(blibliTotal);
      shopeeTotal = shopeeTotal.replaceAll(',', '');
      shopeeTotal = int.parse(shopeeTotal);

      combinedTotal = tokopediaTotal +
          ebayTotal +
          bukalapakTotal +
          blibliTotal +
          shopeeTotal;

      log('Combined total: $combinedTotal');

      return combinedTotal;
    } on NoSuchMethodError {}
  }
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
  List<Product> data;

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
        combined: true,
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
          List<Product> tempList = await combineHelper.combineLists(
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
          Product imageModel = Product();

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
