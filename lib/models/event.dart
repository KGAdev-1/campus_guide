class Event {
  final int? id;
  final String title;
  final String? description;
  final String date;
  final String time;
  final String location;
  final String category;
  final bool isRegistered;
  final DateTime createdAt;

  Event({
    this.id,
    required this.title,
    this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    this.isRegistered = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
      'category': category,
      'isRegistered': isRegistered ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      time: map['time'],
      location: map['location'],
      category: map['category'],
      isRegistered: map['isRegistered'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Event copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    String? time,
    String? location,
    String? category,
    bool? isRegistered,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      category: category ?? this.category,
      isRegistered: isRegistered ?? this.isRegistered,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
