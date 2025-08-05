import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/database_service.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  List<Event> get upcomingEvents {
    final now = DateTime.now();
    return _events.where((event) {
      final eventDate = DateTime.parse('${event.date} ${event.time}:00');
      return eventDate.isAfter(now);
    }).toList()
      ..sort((a, b) {
        final dateA = DateTime.parse('${a.date} ${a.time}:00');
        final dateB = DateTime.parse('${b.date} ${b.time}:00');
        return dateA.compareTo(dateB);
      });
  }

  List<Event> get registeredEvents {
    return _events.where((event) => event.isRegistered).toList();
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseService.instance.database;
      final maps = await db.query('events', orderBy: 'date ASC');
      _events = maps.map((map) => Event.fromMap(map)).toList();
    } catch (e) {
      print('Error loading events: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    try {
      final db = await DatabaseService.instance.database;
      final id = await db.insert('events', event.toMap());
      final newEvent = event.copyWith(id: id);
      _events.add(newEvent);
      notifyListeners();
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  Future<void> toggleEventRegistration(Event event) async {
    try {
      final db = await DatabaseService.instance.database;
      final updatedEvent = event.copyWith(isRegistered: !event.isRegistered);

      await db.update(
        'events',
        updatedEvent.toMap(),
        where: 'id = ?',
        whereArgs: [event.id],
      );

      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = updatedEvent;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating event registration: $e');
    }
  }

  List<Event> getEventsByCategory(String category) {
    return _events.where((event) => event.category == category).toList();
  }

  List<String> get categories {
    return _events.map((event) => event.category).toSet().toList();
  }
}
