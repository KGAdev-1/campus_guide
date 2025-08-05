import 'package:flutter/material.dart';
import '../models/club.dart';
import '../models/club_member.dart';
import '../services/database_service.dart';

class ClubProvider with ChangeNotifier {
  List<Club> _clubs = [];
  bool _isLoading = false;

  List<Club> get clubs => _clubs;
  bool get isLoading => _isLoading;

  Future<void> loadClubs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseService.instance.database;
      final maps = await db.query('clubs', orderBy: 'name ASC');
      _clubs = maps.map((map) => Club.fromMap(map)).toList();
    } catch (e) {
      print('Error loading clubs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addClub(Club club) async {
    try {
      final db = await DatabaseService.instance.database;
      final id = await db.insert('clubs', club.toMap());
      final newClub = club.copyWith(id: id);
      _clubs.add(newClub);
      _clubs.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
    } catch (e) {
      print('Error adding club: $e');
    }
  }

  Future<bool> joinClub(Club club, ClubMember member) async {
    try {
      final db = await DatabaseService.instance.database;

      // Check if club is full
      if (club.isFull) {
        return false;
      }

      // Check if student is already a member
      final existingMember = await db.query(
        'club_members',
        where: 'clubId = ? AND studentId = ?',
        whereArgs: [club.id, member.studentId],
      );

      if (existingMember.isNotEmpty) {
        throw Exception('Student is already a member of this club');
      }

      // Add member to club
      await db.insert('club_members', member.toMap());

      // Update club member count
      final updatedClub = club.copyWith(memberCount: club.memberCount + 1);
      await db.update(
        'clubs',
        updatedClub.toMap(),
        where: 'id = ?',
        whereArgs: [club.id],
      );

      // Update local state
      final index = _clubs.indexWhere((c) => c.id == club.id);
      if (index != -1) {
        _clubs[index] = updatedClub;
        notifyListeners();
      }

      return true;
    } catch (e) {
      print('Error joining club: $e');
      rethrow;
    }
  }

  Future<List<ClubMember>> getClubMembers(int clubId) async {
    try {
      final db = await DatabaseService.instance.database;
      final maps = await db.query(
        'club_members',
        where: 'clubId = ?',
        whereArgs: [clubId],
        orderBy: 'joinedAt DESC',
      );
      return maps.map((map) => ClubMember.fromMap(map)).toList();
    } catch (e) {
      print('Error loading club members: $e');
      return [];
    }
  }

  Future<bool> isStudentMember(int clubId, String studentId) async {
    try {
      final db = await DatabaseService.instance.database;
      final result = await db.query(
        'club_members',
        where: 'clubId = ? AND studentId = ?',
        whereArgs: [clubId, studentId],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking membership: $e');
      return false;
    }
  }

  List<Club> getClubsByCategory(String category) {
    return _clubs.where((club) => club.category == category).toList();
  }

  List<String> get categories {
    return _clubs.map((club) => club.category).toSet().toList();
  }
}
