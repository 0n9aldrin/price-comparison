import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Item.dart';
import '../product.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pricecomparison/main.dart';
import 'dart:developer';

class Ebay {
  String search;
  int searchLength;
  var future;
  var html;

  Future<List<Product>> getEbay({String searches, int page}) async {
    try {
      search = searches;
      search = search.replaceAll(' ', '+');

      html = await getHtml(page: page);
      html = parse(html);
      List<Product> items = getData(html: html);
      return items;
    } on NoSuchMethodError {}
  }

  Future<dynamic> getTotal({String searches}) async {
    try {
      search = searches;
      search = search.replaceAll(' ', '+');

      var html = await getHtml(page: 0);
      html = parse(html);
      var a = html.querySelectorAll(
          '#mainContent > div.s-answer-region.s-answer-region-center-top > div > div.clearfix.srp-controls__row-2 > div > div.srp-controls__control.srp-controls__count > h1 > span');
      var total = a[0].text;
      return total;
    } on NoSuchMethodError {}
  }

  Future<dynamic> getTotal1({String searches, int page}) async {
    try {
      future = await getEbay(searches: searches, page: page);
      var a = html.querySelectorAll(
          '#mainContent > div.s-answer-region.s-answer-region-center-top > div > div.clearfix.srp-controls__row-2 > div > div.srp-controls__control.srp-controls__count > h1 > span');
      var total = a[0].text;
      return total;
    } on NoSuchMethodError {}
  }

  List<Product> getData({var html}) {
    List<Product> items = [];

    var products = html.querySelector('ul.srp-results.srp-list.clearfix');
    List a = [];
    a = products.querySelectorAll('li.s-item    ');

    for (int x = 0; x < a.length; x++) {
      Product imageModel = Product();
      var nameElement =
          a[x].querySelector('div > div.s-item__info.clearfix > a');
      var priceElement = a[x].querySelector(
          'div > div.s-item__info.clearfix > div.s-item__details.clearfix > div > span.s-item__price');
      var imgElement = a[x].querySelector(
          'div > div.s-item__image-section > div > a > div > img');
      var reviewElement = a[x].querySelector(
          'div > div.s-item__info.clearfix > div.s-item__reviews');
      if (reviewElement == null) {
        imageModel.rating = 0;
        imageModel.reviews = 0;
      } else {
        List tempList = reviewElement.text.split(' ');
        imageModel.rating = double.parse(tempList[0]);
        tempList[4] = tempList[4].replaceAll('stars.', '');
        imageModel.reviews = int.parse(tempList[4]);
      }
      dynamic tempPrice = priceElement.text;
      tempPrice = tempPrice.replaceAll(',', '');
      tempPrice = tempPrice.replaceAll('IDR', '');
      if (tempPrice.contains(' ')) {
        var temPriceList = tempPrice.split(' ');
        tempPrice = temPriceList[0];
      }
      tempPrice = double.parse(tempPrice).toStringAsFixed(0);
      tempPrice = '$tempPrice'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      imageModel.title = nameElement.text;
      imageModel.url = nameElement.attributes['href'];
      imageModel.price = tempPrice;
      imageModel.img = imgElement.attributes['src'];
      imageModel.img = imageModel.img.replaceAll('thumbs/', '');
      imageModel.img = imageModel.img.replaceAll('225', '500');
      imageModel.img = imageModel.img.replaceAll('webp', 'png');
      imageModel.website = "Ebay";
      items.add(imageModel);
    }

    return items;
  }

  Future<dynamic> getHtml({int page}) async {
    var headers = {
      'authority': 'www.ebay.com',
      'upgrade-insecure-requests': '1',
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36 OPR/67.0.3575.115',
      'sec-fetch-dest': 'document',
      'accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-mode': 'navigate',
      'sec-fetch-user': '?1',
      'referer':
          'https://www.ebay.com/sch/i.html?_from=R40&_nkw=$search&_sacat=0&_pgn=$page&_dmd=1&rt=nc',
      'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
      'cookie':
          'QuantumMetricEnabled=false; ak_bmsc=FEC7930E3D3DBC69B4D046EF66058767173DCD26E9320000697D915E2E905C5C~pleAkZyZACqB0CvkSvXAJNg5RLcc1rrOyEr/35A10Z03oB8dp8gtl6fRdIBS9Qe+nBiswZRXP9mtPXxZ10SU6XPmFMA1NZZZR2MDHnOLK+vpO6E2TRZd3QyJQ6S4dKgEMnQ+Wn5fkJ8KiJgQbelnaGMkeCRmAE+TbM+xEEwz37BUbLcn5k+YGIlUO2ySdf5qAZXxozX2iVb5LWRJa6oYoDqjYvA7bAjx/v4a+jDaZkWrI=; JSESSIONID=64DC934601B9802C2E34110544F9E2CE; npii=btguid/fb4abf541700a9cbaf676f81fdf894866253ecc9^cguid/fb4acd341700aadc1f370564fb50da1d6253ecc9^; bm_sv=56F4222EDA190B9AAC87D523D9D17FAF~UaUupfONx+JdEmDRqoHNmCLo5BmS0dR/9o+Ctalgv2KeP/JNgD9qWm/XRdA/4vCAiM4pYw1amYJ9Mejb/TVrRzifFmJ8X/jf/+KmNmbmeCPrvs7G6Ln3/ed1JMnDSdlJZHcNHstHqhJoaoO6tmWSC2Ns9gY7ji0qMmxT48oNkTs=; ns1=BAQAAAXFXFhjUAAaAANgASmByuUljNjl8NjAxXjE1ODY0MzI1NTE3MjNeXjFeM3wyfDV8NHw3fDExXl5eNF4zXjEyXjEyXjJeMV4xXjBeMV4wXjFeNjQ0MjQ1OTA3NTY2ceo3eeBt3Q00gaZzLm2KmZFn; dp1=bu1p/QEBfX0BAX19AQA**6253ecc9^bl/ID6253ecc9^pbf/%236000a000000000000000006072b949^; s=CgAD4ACBektdJZmI0YWJmNTQxNzAwYTljYmFmNjc2ZjgxZmRmODk0ODYrpf8v; nonsession=BAQAAAXFXFhjUAAaAAAgAHF65EskxNTg2NTk1MTUyeDIzMzQxMzg1NzE3M3gweDJOADMABWByuUkxMTQzMADLAAFekYzRNgDKACBiU+zJZmI0YWJmNTQxNzAwYTljYmFmNjc2ZjgxZmRmODk0ODaH1DHq3rLBn6xEWUrH/sBKKT4Y0g**; ebay=%5Esbf%3D%23%5Ejs%3D1%5Epsi%3DAcoobRvo*%5E; ds2=sotr/b8_5az10JNfz^',
      'Accept-Encoding': 'gzip',
    };

    var params = {
      '_from': 'R40',
      '_nkw': '$search',
      '_sacat': '0',
      '_pgn': '$page',
      '_dmd': '1',
      'rt': 'nc',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var res = await http.get('https://www.ebay.com/sch/i.html?$query',
        headers: headers);
    log('Ebay http called');
    if (res.statusCode != 200)
      throw Exception('Ebay error: statusCode= ${res.statusCode}');
    var data = res.body;
    return data;
  }
}

class EbayGridView extends StatefulWidget {
  EbayGridView({this.ebay});
  Ebay ebay;
  @override
  State<StatefulWidget> createState() {
    return _EbayGridViewState();
  }
}

class _EbayGridViewState extends State<EbayGridView>
    with AutomaticKeepAliveClientMixin<EbayGridView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget buildCtn() {
    if (globalSearch == null) {
      return Center(
        child: Text('Please search item'),
      );
    }
    if (ebayItems == null) {
      widget.ebay
          .getEbay(searches: globalSearch, page: ebayCounter)
          .then((result) {
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
        reviews: ebayItems[i].reviews,
        rating: ebayItems[i].rating,
        website: ebayItems[i].website,
        combined: false,
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
            ebayItems = await widget.ebay
                .getEbay(searches: globalSearch, page: ebayCounter);
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
          List<Product> tempList = await widget.ebay
              .getEbay(searches: globalSearch, page: ebayCounter);
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
