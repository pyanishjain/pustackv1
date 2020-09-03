
import 'chapter.dart';
import 'meta_class.dart';
import 'topic.dart';

class Result {
    Result({
        this.grade,
        this.topic,
        this.meta,
        this.contentId,
        this.chapter,
        this.chapterName,
        this.id,
        this.subject,
        this.contentType,
    });

    Chapter grade;
    Topic topic;
    MetaClass meta;
    Chapter contentId;
    Chapter chapter;
    Chapter chapterName;
    Chapter id;
    Chapter subject;
    Chapter contentType;

    factory Result.fromMap(Map<String, dynamic> json) => Result(
        grade: Chapter.fromMap(json["grade"]),
        topic: Topic.fromMap(json["topic"]),
        meta: MetaClass.fromMap(json["_meta"]),
        contentId: Chapter.fromMap(json["content_id"]),
        chapter: Chapter.fromMap(json["chapter"]),
        chapterName: Chapter.fromMap(json["chapter_name"]),
        id: Chapter.fromMap(json["id"]),
        subject: Chapter.fromMap(json["subject"]),
        contentType: Chapter.fromMap(json["content_type"]),
    );

    Map<String, dynamic> toMap() => {
        "grade": grade.toMap(),
        "topic": topic.toMap(),
        "_meta": meta.toMap(),
        "content_id": contentId.toMap(),
        "chapter": chapter.toMap(),
        "chapter_name": chapterName.toMap(),
        "id": id.toMap(),
        "subject": subject.toMap(),
        "content_type": contentType.toMap(),
    };
}
