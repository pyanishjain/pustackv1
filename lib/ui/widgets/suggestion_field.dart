import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pustackv1/models/suggestion/auto_suggest.dart';
import 'package:pustackv1/services/api_service.dart';

class SuggestionField extends StatefulWidget {
  final Function(String) onQuerySubmit;

  const SuggestionField({
    Key key,
    @required this.onQuerySubmit,
  }) : super(key: key);

  @override
  _SuggestionFieldState createState() => _SuggestionFieldState();
}

class _SuggestionFieldState extends State<SuggestionField> {
  final ApiService _apiService = ApiService();

  final TextEditingController searchFieldController = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                      // border: InputBorder.none
                      ),
                  controller: searchFieldController,
                  onChanged: (val) {
                    setState(() {
                      query = val;
                    });
                  },
                ),
              ),
              SizedBox(width: 15),
              FlatButton(
                child: Text("SEARCH"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () =>
                    widget.onQuerySubmit(searchFieldController.text),
              ),
            ],
          ),
          query.trim().isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints(maxHeight: 150),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(.6),
                      ),
                      left: BorderSide(
                        color: Colors.grey.withOpacity(.6),
                      ),
                      right: BorderSide(
                        color: Colors.grey.withOpacity(.6),
                      ),
                    ),
                  ),
                  child: FutureBuilder<Response<dynamic>>(
                    future: _apiService.getSuggestionsFromQuery(query),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Container();

                      if (snapshot.hasData) {
                        AutoSuggest autoSuggest =
                            AutoSuggest.fromMap(snapshot.data.data);

                        var docList = autoSuggest.results.documents;

                        return docList.isNotEmpty
                            ? ListView.builder(
                                itemCount: docList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, i) => Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.withOpacity(.3),
                                      ),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        searchFieldController.text =
                                            docList[i].suggestion;
                                        query = '';
                                      });
                                      widget
                                          .onQuerySubmit(docList[i].suggestion);
                                    },
                                    child: Text(docList[i].suggestion),
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                child: Text("No Suggestions"),
                              );
                      }

                      return Text("ERROR!");
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
