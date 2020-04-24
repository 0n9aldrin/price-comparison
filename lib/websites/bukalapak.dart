import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import '../image_model.dart';
import 'dart:developer';

class Bukalapak {
  String search;
  int searchLength;

  Future<dynamic> getTotal({String searches}) async {
    search = searches;
    search = search.replaceAll(' ', '%20');

    var html = await getHtml(page: 0);
    html = parse(html);
    var a = html.querySelectorAll(
        '#display_product_search > div.product-pagination-wrapper > div.pagination > span.last-page');
    dynamic total = int.parse(a[0].text) * 50;
    total = '$total'.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return total;
  }

  Future<List<ImageModel>> getBukalapak({String searches, int page}) async {
    search = searches;
    search = search.replaceAll(' ', '%20');

    var html = await getHtml(page: page);
    html = parse(html);
    List<ImageModel> items = getData(html: html);
//    for (int x = 0; x < items.length; x++) {
//      print(items[x].img);
//    }
    return items;
  }

  List<ImageModel> getData({var html}) {
    List<ImageModel> items = [];
    List element = html.querySelectorAll('li.col-12--2');
    log('Bukalapak received ${element.length} elements from html');
    for (int x = 0; x < element.length; x++) {
      ImageModel imageModel = ImageModel();
      var nameElement = element[x]
          .querySelector('div.product-card > article > div.product-media > a');
      var priceElement = element[x].querySelector(
          'div.product-card > article > div.product-description > div.product-price');
      var imgElement = element[x].querySelector(
          'div.product-card > article > div.product-media > a > picture > img');
      imageModel.title = nameElement.attributes['title'];
      imageModel.url =
          ('https://www.bukalapak.com' + nameElement.attributes['href']);
      dynamic tempPrice = priceElement.attributes['data-reduced-price'];
      tempPrice = '$tempPrice'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      imageModel.price = tempPrice;
      imageModel.img = imgElement.attributes['data-src'];
      imageModel.website = 'Bukalapak';

      if (imageModel.img.contains('jpg') ||
          imageModel.img.contains('jpeg') ||
          imageModel.img.contains('png')) {
        items.add(imageModel);
      } else {
        imageModel.img =
            'https://miro.medium.com/max/1400/1*pUEZd8z__1p-7ICIO1NZFA.png';
        items.add(imageModel);
      }
    }
    log('Bukalapak returning list of length ${items.length}');
    return (items);
  }

  Future<dynamic> getHtml({int page}) async {
    http.Response response = await http.get(
        'https://www.bukalapak.com/products/s?from=omnisearch&from_keyword_history=false&page=$page&search%5Bkeywords%5D=$search&search_source=omnisearch_organic&source=navbar&utf8=✓');

    if (response.statusCode == 200) {
      String data = response.body;
      return data;
    } else {
      throw Exception('Bukalapak error: statusCode= ${response.statusCode}');
    }
  }
}
//
//class BukalapakGridView extends StatefulWidget {
//  final search;
//  static const int PAGE_SIZE = 50;
//
//  BukalapakGridView({Key key, @required this.search}) : super(key: key);
//
//  @override
//  _BukalapakGridViewState createState() => _BukalapakGridViewState();
//}
//
//class _BukalapakGridViewState extends State<BukalapakGridView>
//    with AutomaticKeepAliveClientMixin<BukalapakGridView> {
//  Bukalapak bukalapak = Bukalapak();
//
//  @override
//  Widget build(BuildContext context) {
//    return PagewiseGridView.count(
//      pageSize: BukalapakGridView.PAGE_SIZE,
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
//        log('Loading next Bukalapak page');
//        return bukalapak.getBukalapak(page: pageIndex, searches: widget.search);
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
