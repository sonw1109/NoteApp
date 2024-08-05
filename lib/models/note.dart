import 'package:intl/intl.dart';
import 'dart:math';

class Note {
  Note({
    int? idNote,
    required this.title,
    required this.content,
    this.image,
    this.link,
    String? time,
    this.additionalContents,
  })  : time = time ?? DateFormat('dd/MM/yyyy').format(DateTime.now()),
        idNote = idNote ?? Random().nextInt(10000);

  int idNote;
  final String title;
  final String content;
  String? image;
  String? link;
  final String time;
  List<String>? additionalContents;

  Note updateNote({
    String? title,
    String? content,
    String? image,
    String? link,
  }) {
    return Note(
      idNote: idNote,
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
      link: link ?? this.link,
    );
  }

  factory Note.fromMap(Map<String, dynamic> map) => new Note(
        idNote: map["id"],
        title: map["title"],
        content: map["content"],
        additionalContents: map["additionalContents"]?.split(','),
        link: map["link"],
        image: map["image"],
        time: map["time"],
      );

  Map<String, dynamic> toMap() => {
        "id": idNote,
        "title": title,
        "content": content,
        "additionalContents": additionalContents?.join(','),
        "link": link,
        "image": image,
        "time": time,
      };
}
