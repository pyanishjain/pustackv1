
class Page {
    Page({
        this.current,
        this.totalPages,
        this.totalResults,
        this.size,
    });

    int current;
    int totalPages;
    int totalResults;
    int size;

    factory Page.fromMap(Map<String, dynamic> json) => Page(
        current: json["current"],
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
        size: json["size"],
    );

    Map<String, dynamic> toMap() => {
        "current": current,
        "total_pages": totalPages,
        "total_results": totalResults,
        "size": size,
    };
}
