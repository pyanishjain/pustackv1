
class Document {
    Document({
        this.suggestion,
    });

    String suggestion;

    factory Document.fromMap(Map<String, dynamic> json) => Document(
        suggestion: json["suggestion"],
    );

    Map<String, dynamic> toMap() => {
        "suggestion": suggestion,
    };
}