class LostItem {
  final int? id;
  final String title;
  final String? description;
  final String location;
  final String contactInfo;
  final bool isFound;
  final String? imageUrl;
  final DateTime createdAt;

  LostItem({
    this.id,
    required this.title,
    this.description,
    required this.location,
    required this.contactInfo,
    this.isFound = false,
    this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'contactInfo': contactInfo,
      'isFound': isFound ? 1 : 0,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LostItem.fromMap(Map<String, dynamic> map) {
    return LostItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      contactInfo: map['contactInfo'],
      isFound: map['isFound'] == 1,
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  LostItem copyWith({
    int? id,
    String? title,
    String? description,
    String? location,
    String? contactInfo,
    bool? isFound,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return LostItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      contactInfo: contactInfo ?? this.contactInfo,
      isFound: isFound ?? this.isFound,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
