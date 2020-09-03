
class Chapter {
    Chapter({
        this.raw,
    });

    String raw;

    factory Chapter.fromMap(Map<String, dynamic> json) => Chapter(
        raw: json["raw"],
    );

    Map<String, dynamic> toMap() => {
        "raw": raw,
    };
}
