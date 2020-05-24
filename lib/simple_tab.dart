import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class ColorsChange extends ChangeNotifier {
  Color getColor(int index) {
    return colors[index];
  }

  void changeColor(int index) {
    Color color = colors[index];
    print(color);
    notifyListeners();
  }
}

List<Color> colors = const [
  Colors.green,
  Colors.yellow,
  Colors.red,
  Colors.blue,
  Colors.deepOrange,
  Colors.deepPurple,
];

class SimpleTab extends StatefulWidget {
  @override
  _SimpleTabState createState() => _SimpleTabState();
}

class _SimpleTabState extends State<SimpleTab>
    with SingleTickerProviderStateMixin {
  Tester tester = Tester();
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: colors.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.search),
          ),
        ],
        backgroundColor:
            Provider.of<ColorsChange>(context).getColor(controller.index),
        bottom: TabBar(
          onTap: (index) {
            Provider.of<ColorsChange>(context, listen: false)
                .changeColor(index);
          },
          controller: controller,
          tabs: [
            Tab(
              text: 'Green',
            ),
            Tab(
              text: 'Yellow',
            ),
            Tab(
              text: 'Red',
            ),
            Tab(
              text: 'Blue',
            ),
            Tab(
              text: 'Orange',
            ),
            Tab(
              text: 'Purple',
            ),
          ],
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          Container(
            child: WidgetThing(tester: tester),
          ),
          Container(
            child: WidgetThing(tester: tester),
          ),
          Container(
            child: WidgetThing(tester: tester),
          ),
          Container(
            child: WidgetThing(tester: tester),
          ),
          Container(
            child: WidgetThing(tester: tester),
          ),
          Container(
            child: WidgetThing(tester: tester),
          ),
        ],
      ),
    );
  }
}

class WidgetThing extends StatefulWidget {
  const WidgetThing({
    Key key,
    @required this.tester,
  }) : super(key: key);

  final Tester tester;

  @override
  _WidgetThingState createState() => _WidgetThingState();
}

class _WidgetThingState extends State<WidgetThing>
    with AutomaticKeepAliveClientMixin<WidgetThing> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            color: Colors.grey,
            height: 28.0,
            padding: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total results1: ${snapshot.data}',
              ),
            ),
          );
        } else {
          return SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(),
          );
        }
      },
      future: widget.tester.getTotal(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Tester {
  var html;

  Future<dynamic> getTotal() async {
    await getName();
    var a = html.querySelectorAll(
        '#display_product_search > div.product-pagination-wrapper > div.pagination > span.last-page');
    dynamic total = int.parse(a[0].text) * 50;
    total = '$total'.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return total;
  }

  Future<dynamic> getName() async {
    http.Response response = await http.get(
        'https://www.bukalapak.com/products/s?from=omnisearch&from_keyword_history=false&page=0&search%5Bkeywords%5D=paper&search_source=omnisearch_organic&source=navbar&utf8=✓');

    if (response.statusCode == 200) {
      String data = response.body;
      html = parse(data);

      var nameElement = html.querySelector(
          'li.col-12--2 > div.product-card > article > div.product-media > a');
      String title = nameElement.attributes['title'];
      return title;
    } else {
      throw Exception('Bukalapak error: statusCode= ${response.statusCode}');
    }
  }
}
