class Club {
  final int? id;
  final String name;
  final String? description;
  final String category;
  final String? contactEmail;
  final String? meetingTime;
  final String? location;
  final int memberCount;
  final int? memberLimit;
  final DateTime createdAt;

  Club({
    this.id,
    required this.name,
    this.description,
    required this.category,
    this.contactEmail,
    this.meetingTime,
    this.location,
    this.memberCount = 0,
    this.memberLimit,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'contactEmail': contactEmail,
      'meetingTime': meetingTime,
      'location': location,
      'memberCount': memberCount,
      'memberLimit': memberLimit,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Club.fromMap(Map<String, dynamic> map) {
    return Club(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      contactEmail: map['contactEmail'],
      meetingTime: map['meetingTime'],
      location: map['location'],
      memberCount: map['memberCount'] ?? 0,
      memberLimit: map['memberLimit'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Club copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    String? contactEmail,
    String? meetingTime,
    String? location,
    int? memberCount,
    int? memberLimit,
    DateTime? createdAt,
  }) {
    return Club(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      contactEmail: contactEmail ?? this.contactEmail,
      meetingTime: meetingTime ?? this.meetingTime,
      location: location ?? this.location,
      memberCount: memberCount ?? this.memberCount,
      memberLimit: memberLimit ?? this.memberLimit,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isFull => memberLimit != null && memberCount >= memberLimit!;
}
