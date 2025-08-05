import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event.dart';
import '../models/lost_item.dart';
import '../models/club.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('campus_guide.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {

    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        location TEXT NOT NULL,
        category TEXT NOT NULL,
        isRegistered INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');


    await db.execute('''
      CREATE TABLE lost_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        location TEXT NOT NULL,
        contactInfo TEXT NOT NULL,
        isFound INTEGER DEFAULT 0,
        imageUrl TEXT,
        createdAt TEXT NOT NULL
      )
    ''');


    await db.execute('''
      CREATE TABLE clubs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        contactEmail TEXT,
        meetingTime TEXT,
        location TEXT,
        memberCount INTEGER DEFAULT 0,
        memberLimit INTEGER,
        createdAt TEXT NOT NULL
      )
    ''');


    await db.execute('''
    CREATE TABLE club_members (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      clubId INTEGER NOT NULL,
      studentName TEXT NOT NULL,
      studentId TEXT NOT NULL,
      email TEXT NOT NULL,
      phone TEXT,
      major TEXT,
      year INTEGER,
      joinedAt TEXT NOT NULL,
      FOREIGN KEY (clubId) REFERENCES clubs (id) ON DELETE CASCADE
    )
  ''');


    await _insertSampleData(db);
  }

  Future _insertSampleData(Database db) async {
    final events = [
      {
        'title': 'Tech Talk: AI in Education',
        'description': 'Join us for an insightful discussion about artificial intelligence applications in modern education.',
        'date': '2024-02-15',
        'time': '14:00',
        'location': 'Computer Science Building - Room 101',
        'category': 'Academic',
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Spring Festival',
        'description': 'Annual spring celebration with food, music, and activities for all students.',
        'date': '2024-03-20',
        'time': '12:00',
        'location': 'Main Quad',
        'category': 'Social',
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Career Fair 2024',
        'description': 'Meet with top employers and explore internship and job opportunities.',
        'date': '2024-02-28',
        'time': '10:00',
        'location': 'Student Union Building',
        'category': 'Career',
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];

    for (var event in events) {
      await db.insert('events', event);
    }


    final clubs = [
      {
        'name': 'Computer Science Club',
        'description': 'A community for CS students to collaborate on projects and learn together.',
        'category': 'Academic',
        'contactEmail': 'cs-club@university.edu',
        'meetingTime': 'Wednesdays 6:00 PM',
        'location': 'CS Building Room 205',
        'memberCount': 45,
        'memberLimit': 50,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Photography Club',
        'description': 'Capture campus life and improve your photography skills with fellow enthusiasts.',
        'category': 'Arts',
        'contactEmail': 'photo-club@university.edu',
        'meetingTime': 'Fridays 4:00 PM',
        'location': 'Art Building Studio 3',
        'memberCount': 28,
        'memberLimit': 30,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Environmental Action Group',
        'description': 'Working together to make our campus more sustainable and environmentally friendly.',
        'category': 'Service',
        'contactEmail': 'green-campus@university.edu',
        'meetingTime': 'Tuesdays 5:30 PM',
        'location': 'Student Center Room 150',
        'memberCount': 32,
        'memberLimit': null,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];

    for (var club in clubs) {
      await db.insert('clubs', club);
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
