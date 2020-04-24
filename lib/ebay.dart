import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'image_model.dart';

class Ebay {
  String search;
  int searchLength;
  bool combined;

  Future<List<ImageModel>> getEbay(
      {String searches, int page, bool combine}) async {
    search = searches;
    search = search.replaceAll(' ', '+');

    combined = combine;

    var html = await getHtml(page: page);
    html = parse(html);
    List<ImageModel> items = getData(html: html);
//    for (int x = 0; x < items.length; x++) {
//      print(items[x].img);
//    }
    return items;
  }

  Future<dynamic> getTotal({String searches}) async {
    search = searches;
    search = search.replaceAll(' ', '+');

    var html = await getHtml(page: 0);
    html = parse(html);
    var a = html.querySelectorAll(
        '#mainContent > div.s-answer-region.s-answer-region-center-top > div > div.clearfix.srp-controls__row-2 > div > div.srp-controls__control.srp-controls__count > h1 > span');
    var total = a[0].text;
    return total;
  }

  List<ImageModel> getData({var html}) {
    List<ImageModel> items = [];

    var products = html.querySelector('ul.srp-results.srp-list.clearfix');
    List a = [];
    a = products.querySelectorAll('li.s-item    ');

    for (int x = 0; x < a.length; x++) {
      ImageModel imageModel = ImageModel();
      var nameElement =
          a[x].querySelector('div > div.s-item__info.clearfix > a');
      var priceElement = a[x].querySelector(
          'div > div.s-item__info.clearfix > div.s-item__details.clearfix > div > span.s-item__price');
      var imgElement = a[x].querySelector(
          'div > div.s-item__image-section > div > a > div > img');
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
    if (res.statusCode != 200)
      throw Exception('Ebay error: statusCode= ${res.statusCode}');
    var data = res.body;
    return data;
  }
}
//
//class EbayGridView extends StatefulWidget {
//  final search;
//  static const int PAGE_SIZE = 63;
//
//  EbayGridView({Key key, @required this.search}) : super(key: key);
//
//  @override
//  _EbayGridViewState createState() => _EbayGridViewState();
//}
//
//class _EbayGridViewState extends State<EbayGridView>
//    with AutomaticKeepAliveClientMixin<EbayGridView> {
//  Ebay ebay = Ebay();
//
//  @override
//  Widget build(BuildContext context) {
//    return PagewiseGridView.count(
//      pageSize: EbayGridView.PAGE_SIZE,
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
//        log('Loading next Ebay page');
//        return ebay.getEbay(
//            page: pageIndex, searches: widget.search, combine: false);
//      },
//    );
//  }
//
//  Widget _itemBuilder(BuildContext context, ImageModel entry, int _) {
//    Color getColor() {
//      if (entry.title == 'null') {
//        return Color(0xFF323131);
//      } else {
//        return Colors.grey[600];
//      }
//    }
//
//    String getTitle() {
//      if (entry.title == 'null') {
//        return '';
//      } else {
//        return entry.title;
//      }
//    }
//
//    String getPrice() {
//      if (entry.title == 'null') {
//        return '';
//      } else {
//        return 'RP ${entry.price}';
//      }
//    }
//
//    Widget getImage() {
//      if (entry.title == 'null') {
//        return Container(
//          decoration: BoxDecoration(),
//        );
//      } else {
//        return Container(
//          decoration: BoxDecoration(
//            color: Colors.grey[200],
//            image: DecorationImage(
//                image: NetworkImage(entry.img), fit: BoxFit.fill),
//          ),
//        );
//      }
//    }
//
//    return Container(
//        decoration: BoxDecoration(
//          border: Border.all(color: getColor()),
//        ),
//        child: Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Expanded(
//                child: GestureDetector(
//                    onTap: () async {
//                      if (await canLaunch(entry.url)) {
//                        await launch(entry.url);
//                      }
//                    },
//                    child: getImage()),
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
//              SizedBox(height: 8.0)
//            ]));
//  }
//
//  @override
//  bool get wantKeepAlive => true;
//}
