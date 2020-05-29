import 'package:flutter/material.dart';
import 'search1.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:provider/provider.dart';

//class SeachAppBarRecipe extends StatefulWidget {
//  SeachAppBarRecipe({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _SearchAppBarRecipeState createState() => _SearchAppBarRecipeState();
//}
//
//class _SearchAppBarRecipeState extends State<SeachAppBarRecipe> {
//  final List<String> kWords;
//  _SearchAppBarDelegate _searchDelegate;
//
//  //Initializing with sorted list of english words
//  _SearchAppBarRecipeState()
//      : kWords = List.from(Set.from(words.all))
//          ..sort(
//            (w1, w2) => w1.toLowerCase().compareTo(w2.toLowerCase()),
//          ),
//        super();
//
//  @override
//  void initState() {
//    super.initState();
//    //Initializing search delegate with sorted list of English words
//    _searchDelegate = _SearchAppBarDelegate(kWords);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        automaticallyImplyLeading: false,
//        title: Text('Word List'),
//        actions: <Widget>[
//          //Adding the search widget in AppBar
//          IconButton(
//            tooltip: 'Search',
//            icon: const Icon(Icons.search),
//            //Don't block the main thread
//            onPressed: () {
//              showSearchPage(context, _searchDelegate);
//            },
//          ),
//        ],
//      ),
//      body: Container()
//    );
//  }
//
//  //Shows Search result
//  void showSearchPage(
//      BuildContext context, _SearchAppBarDelegate searchDelegate) async {
//    final String selected = await showSearch<String>(
//      context: context,
//      delegate: searchDelegate,
//    );
//
//
//    if (selected != null) {
//      Scaffold.of(context).showSnackBar(
//        SnackBar(
//          content: Text('Your Word Choice: $selected'),
//        ),
//      );
//    }
//  }
//}
//
////Search delegate
//class _SearchAppBarDelegate extends SearchDelegate<String> {
//  final List<String> _words;
//  final List<String> _history;
//
//  _SearchAppBarDelegate(List<String> words)
//      : _words = words,
//        //pre-populated history of words
//        _history = <String>['apple', 'orange', 'banana', 'watermelon'],
//        super();
//
//  // Setting leading icon for the search bar.
//  //Clicking on back arrow will take control to main page
//  @override
//  Widget buildLeading(BuildContext context) {
//    return IconButton(
//      tooltip: 'Back',
//      icon: AnimatedIcon(
//        icon: AnimatedIcons.menu_arrow,
//        progress: transitionAnimation,
//      ),
//      onPressed: () {
//        //Take control back to previous page
//        this.close(context, null);
//      },
//    );
//  }
//
//  // Builds page to populate search results.
//  @override
//  Widget buildResults(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Center(
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            Text('===Your Word Choice==='),
//            GestureDetector(
//              onTap: () {
//                //Define your action when clicking on result item.
//                //In this example, it simply closes the page
//                this.close(context, this.query);
//              },
//              child: Text(
//                this.query,
//                style: Theme.of(context)
//                    .textTheme
//                    .display2
//                    .copyWith(fontWeight: FontWeight.normal),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  // Suggestions list while typing search query - this.query.
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    final Iterable<String> suggestions = this.query.isEmpty
//        ? _history
//        : _words.where((word) => word.startsWith(query));
//
//    return _WordSuggestionList(
//      query: this.query,
//      suggestions: suggestions.toList(),
//      onSelected: (String suggestion) {
//        this.query = suggestion;
//        this._history.insert(0, suggestion);
//        showResults(context);
//      },
//    );
//  }
//
//  // Action buttons at the right of search bar.
//  @override
//  List<Widget> buildActions(BuildContext context) {
//    return <Widget>[
//      query.isNotEmpty
//          ? IconButton(
//              tooltip: 'Clear',
//              icon: const Icon(Icons.clear),
//              onPressed: () {
//                query = '';
//                showSuggestions(context);
//              },
//            )
//          : IconButton(
//              icon: const Icon(Icons.mic),
//              tooltip: 'Voice input',
//              onPressed: () {
//                this.query = 'TBW: Get input from voice';
//              },
//            ),
//    ];
//  }
//}
//
// Suggestions list widget displayed in the search page.
class _WordSuggestionList extends StatefulWidget {
  const _WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  __WordSuggestionListState createState() => __WordSuggestionListState();
}

class __WordSuggestionListState extends State<_WordSuggestionList> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: widget.suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = widget.suggestions[i];
        return ListTile(
          leading: Icon(Icons.history),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              history.removeAt(0);
              setState(() {});
            },
          ),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, widget.query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(widget.query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            widget.onSelected(suggestion);
          },
        );
      },
    );
  }
}

//class SearchApp extends StatefulWidget {
//  @override
//  _SearchAppState createState() => _SearchAppState();
//}

//class _SearchAppState extends State<SearchApp> {
//  var testSearch;
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        actions: <Widget>[
//          IconButton(
//            tooltip: 'Search',
//            icon: const Icon(Icons.search),
//            //Don't block the main thread
//            onPressed: () async {
//              testSearch = await showSearch1(
//                  context: context, delegate: CustomSearchDelegate());
//              print(testSearch);
//              setState(() {});
//            },
//          ),
//        ],
//      ),
//      body: (testSearch != null)
//          ? Text(testSearch)
//          : Text('Please search'), // The query data should be displayed here
//    );
//  }
//}
List<String> history = <String>[''];

class CustomSearchDelegate extends SearchDelegate1 {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty
          ? IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : IconButton(
              icon: const Icon(Icons.camera_alt),
              tooltip: 'Voice input',
              onPressed: () {
                this.query = 'TBW: Get input from voice';
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text(this.query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions =
        history.where((element) => element.startsWith(query));

    return (history[0] != '')
        ? _WordSuggestionList(
            query: this.query,
            suggestions: suggestions.toList(),
            onSelected: (String suggestion) {
              this.query = suggestion;
              showResults(context);
            },
          )
        : Container(
            child: Center(child: Text('No history')),
          );
  }
}
