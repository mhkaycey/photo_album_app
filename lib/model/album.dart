class Album {
  final int id;
  final int userId;
  final String title;

  Album({required this.id, required this.userId, required this.title});

  //Trying how this works

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'userId': int userId, 'title': String title} => Album(
        id: id,
        userId: userId,
        title: title,
      ),
      _ => throw const FormatException('Invalid JSON format'),
    };
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'title': title};
  }
}
