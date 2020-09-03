import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:pustackv1/constants.dart';
import 'package:pustackv1/models/search_result/result.dart';
import 'package:pustackv1/services/api_service.dart';
import 'models/search_result/search_result.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;
  DetailScreen(this.imagePath);

  @override
  _DetailScreenState createState() => new _DetailScreenState(imagePath);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(this.path);
  final _apiService = ApiService();
  List<String> stopWords = Constants.stopWords;
  List<Result> searchResultsList = List();
  Future<Result> futureResult;
  List<String> tempq = [];
  bool _fetching = true;

  Map<String, dynamic> searchQueryList;
  String searchText;

  final String path;

  Size _imageSize;
  List<TextElement> _elements = [];
  String recognizedText = "Loading ...";
  String q = "";
  List<String> searchArray;
  File cropped;

  getChunkSearchResults(List<String> queries) async {
    List id = [];
    for (var i = 0; i < queries.length; i = i + 1) {
      await _apiService.getSearchResults(queries[i]).then((value) {
        SearchResult searchResult = SearchResult.fromMap(value.data);
        try {
          searchResult.results.forEach((element) {
            if (!id.contains(element.id.raw)) {
              searchResultsList.add(element);
            }
            id.add(element.id.raw);
            print(id);
          });
        } on Exception catch (e) {
          print(e);
        }
        setState(() {
          _fetching = false;
        });
      });
    }
    print("********** searchResultsListin function $searchResultsList");
  }

  void _initializeVision() async {
    final File imageFile = File(path);
    cropped = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxWidth: 700,
      maxHeight: 700,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );

    if (cropped != null) {
      await _getImageSize(cropped);
    } else {
      return null;
    }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(cropped);

    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    String extractText = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        extractText += line.text + '\n';
        for (TextElement element in line.elements) {
          _elements.add(element);
        }
      }
    }

    setState(() {
      recognizedText = extractText.toLowerCase().trim();
    });

    fetchFromImage();
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  // split the query into list of items where each striang have length of 120
  List<String> splitByNumber(String input, int n) {
    final list = <String>[];
    var i = 0;
    var j = 1;

    while (j <= input.length) {
      try {
        list.add(input.substring(i, n * j));
        i = n * j;
      } catch (e) {
        if (i != input.length) list.add(input.substring(i, input.length));
        break;
      } finally {
        j += 1;
      }
    }
    return list;
  }

  fetchFromImage() async {
    for (var s in recognizedText.split(" ")) {
      if (!stopWords.contains(s)) {
        q += s + " ";
      }
    }
    if (q.length > 128) {
      tempq = splitByNumber(q, 120);
      getChunkSearchResults(tempq);
    } else {
      List id = [];
      await _apiService.getSearchResults(q).then((value) {
        SearchResult searchResult = SearchResult.fromMap(value.data);

        try {
          searchResult.results.forEach((element) {
            if (!id.contains(element.id.raw)) {
              searchResultsList.add(element);
              print(element.id.raw);
            }
            id.add(element.id.raw);
          });
        } on Exception catch (e) {
          print(e);
        }
      });
    }
    setState(() {
      _fetching = false;
    });
    print("!!!!!!!!!!! searcResults $searchResultsList !!!!!!!");
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Results"),
        ),
        body: !_fetching
            ? Container(
                padding: EdgeInsets.all(10),
                child: Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResultsList.length,
                    itemBuilder: (context, i) {
                      Result result = searchResultsList[i];
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('_apiService', _apiService));
    properties.add(DiagnosticsProperty('_apiService', _apiService));
    properties.add(DiagnosticsProperty('_apiService', _apiService));
  }
}

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextContainer container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
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
          overflow: TextOverflow.ellipsis,
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            // overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
