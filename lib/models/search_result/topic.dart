
class Topic {
    Topic({
        this.raw,
    });

    List<String> raw;

    factory Topic.fromMap(Map<String, dynamic> json) => Topic(
        raw: List<String>.from(json["raw"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "raw": List<dynamic>.from(raw.map((x) => x)),
    };
}