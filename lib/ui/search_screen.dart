import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pustackv1/models/search_result/result.dart';
import 'package:pustackv1/models/search_result/search_result.dart';
import 'package:pustackv1/services/api_service.dart';

import 'widgets/suggestion_field.dart';

class SearchScreen extends StatefulWidget {
  // editing controller
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();

  final TextEditingController searchFieldController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            SuggestionField(
              onQuerySubmit: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
            SizedBox(height: 15),
            searchQuery.trim().isNotEmpty
                ? FutureBuilder<Response>(
                    future: _apiService.getSearchResults(searchQuery),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return CircularProgressIndicator();

                      if (snapshot.hasData) {
                        SearchResult searchResult =
                            SearchResult.fromMap(snapshot.data.data);

                        return Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchResult.results.length,
                            itemBuilder: (context, i) {
                              Result result = searchResult.results[i];

                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RowText(
                                      'Chapter Name',
                                      result.chapterName.raw,
                                    ),
                                    RowText('Grade', result.grade.raw),
                                    RowText('Content Id', result.contentId.raw),
                                    RowText('Subject', result.subject.raw),
                                    RowText(
                                      'Score',
                                      result.meta.score.toString(),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Topics : ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Flexible(
                                          child: Wrap(
                                              children: result.topic.raw
                                                  .map(
                                                    (e) => Text(
                                                      e + ', ',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  )
                                                  .toList()),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
    
    
                      }

                      return Text("Error !");
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class RowText extends StatelessWidget {
  final String heading;
  final String value;

  const RowText(
    this.heading,
    this.value,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading + ' : ',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
