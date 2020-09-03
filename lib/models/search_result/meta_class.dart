
class MetaClass {
    MetaClass({
        this.engine,
        this.id,
        this.score,
    });

    String engine;
    String id;
    double score;

    factory MetaClass.fromMap(Map<String, dynamic> json) => MetaClass(
        engine: json["engine"],
        id: json["id"],
        score: json["score"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "engine": engine,
        "id": id,
        "score": score,
    };
}
