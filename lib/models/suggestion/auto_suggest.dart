import 'meta.dart';
import 'results.dart';

class AutoSuggest {
  AutoSuggest({
    this.results,
    this.meta,
  });

  Results results;
  Meta meta;

  factory AutoSuggest.fromMap(Map<String, dynamic> json) => AutoSuggest(
        results: Results.fromMap(json["results"]),
        meta: Meta.fromMap(json["meta"]),
      );

  Map<String, dynamic> toMap() => {
        "results": results.toMap(),
        "meta": meta.toMap(),
      };
}
