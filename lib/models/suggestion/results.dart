import 'document.dart';

class Results {
  Results({
    this.documents,
  });

  List<Document> documents;

  factory Results.fromMap(Map<String, dynamic> json) => Results(
        documents: List<Document>.from(
            json["documents"].map((x) => Document.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "documents": List<dynamic>.from(documents.map((x) => x.toMap())),
      };
}
