import 'meta.dart';
import 'result.dart';

class SearchResult {
    SearchResult({
        this.meta,
        this.results,
    });

    Meta meta;
    List<Result> results;

    factory SearchResult.fromMap(Map<String, dynamic> json) => SearchResult(
        meta: Meta.fromMap(json["meta"]),
        results: List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "meta": meta.toMap(),
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
    };
}

