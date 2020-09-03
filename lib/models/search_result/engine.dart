
class Engine {
    Engine({
        this.name,
        this.type,
    });

    String name;
    String type;

    factory Engine.fromMap(Map<String, dynamic> json) => Engine(
        name: json["name"],
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "type": type,
    };
}
