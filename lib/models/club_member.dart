class ClubMember {
  final int? id;
  final int clubId;
  final String studentName;
  final String studentId;
  final String email;
  final String? phone;
  final String? major;
  final int? year;
  final DateTime joinedAt;

  ClubMember({
    this.id,
    required this.clubId,
    required this.studentName,
    required this.studentId,
    required this.email,
    this.phone,
    this.major,
    this.year,
    required this.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clubId': clubId,
      'studentName': studentName,
      'studentId': studentId,
      'email': email,
      'phone': phone,
      'major': major,
      'year': year,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  factory ClubMember.fromMap(Map<String, dynamic> map) {
    return ClubMember(
      id: map['id'],
      clubId: map['clubId'],
      studentName: map['studentName'],
      studentId: map['studentId'],
      email: map['email'],
      phone: map['phone'],
      major: map['major'],
      year: map['year'],
      joinedAt: DateTime.parse(map['joinedAt']),
    );
  }
}
