import 'dart:convert';

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(String str) => Quote.fromMap(json.decode(str)[0]);

  factory Quote.fromMap(Map<String, dynamic> json) => Quote(
        text: json["q"],
        author: json["a"],
      );
}
