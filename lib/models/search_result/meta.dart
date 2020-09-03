import 'engine.dart';
import 'page.dart';

class Meta {
  Meta({
    this.alerts,
    this.warnings,
    this.page,
    this.engine,
    this.requestId,
  });

  List<dynamic> alerts;
  List<dynamic> warnings;
  Page page;
  Engine engine;
  String requestId;

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        alerts: List<dynamic>.from(json["alerts"].map((x) => x)),
        warnings: List<dynamic>.from(json["warnings"].map((x) => x)),
        page: Page.fromMap(json["page"]),
        engine: Engine.fromMap(json["engine"]),
        requestId: json["request_id"],
      );

  Map<String, dynamic> toMap() => {
        "alerts": List<dynamic>.from(alerts.map((x) => x)),
        "warnings": List<dynamic>.from(warnings.map((x) => x)),
        "page": page.toMap(),
        "engine": engine.toMap(),
        "request_id": requestId,
      };
}
