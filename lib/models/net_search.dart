class ResultSuggest {
  final String chapter;
  final String content_type;
  final String grade;
  final String subject;
  // final List topic;
  final String chapter_name;

  ResultSuggest(
      {this.chapter,
      this.content_type,
      this.grade,
      this.subject,
      // this.topic,
      this.chapter_name});

  factory ResultSuggest.fromJson(Map<String, dynamic> json) {
    return ResultSuggest(
      chapter: json['chapter']['raw'],
      content_type: json['content_type']['raw'],
      grade: json['grade']['raw'],
      subject: json['subject']['raw'],
      // topic: json['topic']['raw'],
      chapter_name: json['chapter_name']['raw'],
    );
  }
}
