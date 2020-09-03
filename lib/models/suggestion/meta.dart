
class Meta {
    Meta({
        this.requestId,
    });

    String requestId;

    factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        requestId: json["request_id"],
    );

    Map<String, dynamic> toMap() => {
        "request_id": requestId,
    };
}
