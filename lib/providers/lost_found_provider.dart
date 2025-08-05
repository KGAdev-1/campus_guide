import 'package:flutter/material.dart';
import '../models/lost_item.dart';
import '../services/database_service.dart';

class LostFoundProvider with ChangeNotifier {
  List<LostItem> _lostItems = [];
  bool _isLoading = false;

  List<LostItem> get lostItems => _lostItems;
  bool get isLoading => _isLoading;

  List<LostItem> get activeLostItems {
    return _lostItems.where((item) => !item.isFound).toList();
  }

  List<LostItem> get foundItems {
    return _lostItems.where((item) => item.isFound).toList();
  }

  Future<void> loadLostItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseService.instance.database;
      final maps = await db.query('lost_items', orderBy: 'createdAt DESC');
      _lostItems = maps.map((map) => LostItem.fromMap(map)).toList();
    } catch (e) {
      print('Error loading lost items: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addLostItem(LostItem item) async {
    try {
      final db = await DatabaseService.instance.database;
      final id = await db.insert('lost_items', item.toMap());
      final newItem = item.copyWith(id: id);
      _lostItems.insert(0, newItem);
      notifyListeners();
    } catch (e) {
      print('Error adding lost item: $e');
    }
  }

  Future<void> markAsFound(LostItem item) async {
    try {
      final db = await DatabaseService.instance.database;
      final updatedItem = item.copyWith(isFound: true);

      await db.update(
        'lost_items',
        updatedItem.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      );

      final index = _lostItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _lostItems[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      print('Error marking item as found: $e');
    }
  }
}
