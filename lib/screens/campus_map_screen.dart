import 'package:flutter/material.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedBuilding;

  final List<Building> _buildings = [
    Building(
      name: 'Computer Science Building',
      code: 'CS',
      description: 'Home to the Computer Science department',
      coordinates: const Offset(150, 200),
      category: 'Academic',
    ),
    Building(
      name: 'Student Union Building',
      code: 'SUB',
      description: 'Student services, dining, and meeting spaces',
      coordinates: const Offset(250, 150),
      category: 'Student Services',
    ),
    Building(
      name: 'Library',
      code: 'LIB',
      description: 'Main campus library and study spaces',
      coordinates: const Offset(200, 250),
      category: 'Academic',
    ),
    Building(
      name: 'Engineering Building',
      code: 'ENG',
      description: 'Engineering departments and labs',
      coordinates: const Offset(100, 300),
      category: 'Academic',
    ),
    Building(
      name: 'Art Building',
      code: 'ART',
      description: 'Fine arts studios and galleries',
      coordinates: const Offset(300, 100),
      category: 'Academic',
    ),
    Building(
      name: 'Gymnasium',
      code: 'GYM',
      description: 'Sports facilities and fitness center',
      coordinates: const Offset(350, 250),
      category: 'Recreation',
    ),
    Building(
      name: 'Dormitory A',
      code: 'DORM-A',
      description: 'Student housing complex A',
      coordinates: const Offset(50, 150),
      category: 'Housing',
    ),
    Building(
      name: 'Cafeteria',
      code: 'CAF',
      description: 'Main dining hall',
      coordinates: const Offset(200, 100),
      category: 'Dining',
    ),
  ];

  List<Building> get _filteredBuildings {
    if (_searchQuery.isEmpty) return _buildings;
    return _buildings.where((building) {
      return building.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          building.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          building.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Map'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search buildings...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _selectedBuilding = null;
                    });
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _selectedBuilding = null;
                });
              },
            ),
          ),

          // Map and Building List
          Expanded(
            child: Row(
              children: [
                // Interactive Map
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: InteractiveViewer(
                        boundaryMargin: const EdgeInsets.all(20),
                        minScale: 0.5,
                        maxScale: 3.0,
                        child: Container(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomPaint(
                            painter: CampusMapPainter(
                              buildings: _filteredBuildings,
                              selectedBuilding: _selectedBuilding,
                            ),
                            child: GestureDetector(
                              onTapDown: (details) {
                                _handleMapTap(details.localPosition);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Building List
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Buildings',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _filteredBuildings.length,
                            itemBuilder: (context, index) {
                              final building = _filteredBuildings[index];
                              final isSelected = _selectedBuilding == building.code;

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : null,
                                child: ListTile(
                                  dense: true,
                                  title: Text(
                                    building.code,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    building.name,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Icon(
                                    _getCategoryIcon(building.category),
                                    size: 16,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedBuilding = isSelected ? null : building.code;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Building Details
          if (_selectedBuilding != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getCategoryIcon(_getSelectedBuilding()!.category),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getSelectedBuilding()!.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Chip(
                            label: Text(_getSelectedBuilding()!.code),
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_getSelectedBuilding()!.description),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getSelectedBuilding()!.category,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleMapTap(Offset position) {
    for (final building in _filteredBuildings) {
      final distance = (position - building.coordinates).distance;
      if (distance < 30) {
        setState(() {
          _selectedBuilding = _selectedBuilding == building.code ? null : building.code;
        });
        break;
      }
    }
  }

  Building? _getSelectedBuilding() {
    return _buildings.firstWhere(
          (building) => building.code == _selectedBuilding,
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Icons.school;
      case 'Student Services':
        return Icons.support_agent;
      case 'Recreation':
        return Icons.sports_gymnastics;
      case 'Housing':
        return Icons.home;
      case 'Dining':
        return Icons.restaurant;
      default:
        return Icons.location_on;
    }
  }
}

class Building {
  final String name;
  final String code;
  final String description;
  final Offset coordinates;
  final String category;

  Building({
    required this.name,
    required this.code,
    required this.description,
    required this.coordinates,
    required this.category,
  });
}

class CampusMapPainter extends CustomPainter {
  final List<Building> buildings;
  final String? selectedBuilding;

  CampusMapPainter({
    required this.buildings,
    this.selectedBuilding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw campus background
    final backgroundPaint = Paint()
      ..color = Colors.green.shade100
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw paths
    final pathPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Main path
    canvas.drawLine(
      const Offset(50, 200),
      const Offset(350, 200),
      pathPaint,
    );

    // Vertical paths
    canvas.drawLine(
      const Offset(200, 50),
      const Offset(200, 350),
      pathPaint,
    );

    // Draw buildings
    for (final building in buildings) {
      final isSelected = selectedBuilding == building.code;

      final buildingPaint = Paint()
        ..color = isSelected ? Colors.blue.shade300 : _getBuildingColor(building.category)
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = isSelected ? Colors.blue.shade700 : Colors.grey.shade700
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      // Draw building rectangle
      final rect = Rect.fromCenter(
        center: building.coordinates,
        width: 40,
        height: 30,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        buildingPaint,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        borderPaint,
      );

      // Draw building code
      final textPainter = TextPainter(
        text: TextSpan(
          text: building.code,
          style: TextStyle(
            color: Colors.black,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          building.coordinates.dx - textPainter.width / 2,
          building.coordinates.dy - textPainter.height / 2,
        ),
      );
    }
  }

  Color _getBuildingColor(String category) {
    switch (category) {
      case 'Academic':
        return Colors.blue.shade200;
      case 'Student Services':
        return Colors.orange.shade200;
      case 'Recreation':
        return Colors.green.shade200;
      case 'Housing':
        return Colors.purple.shade200;
      case 'Dining':
        return Colors.red.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
