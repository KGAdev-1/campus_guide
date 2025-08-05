import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/club_provider.dart';
import '../models/club.dart';
import '../models/club_member.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Clubs'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<ClubProvider>(
        builder: (context, clubProvider, child) {
          if (clubProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = ['All', ...clubProvider.categories];
          final filteredClubs = _getFilteredClubs(clubProvider);

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search clubs...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
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
                    });
                  },
                ),
              ),

              // Category Filter
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == _selectedCategory;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              // Clubs List
              Expanded(
                child: _buildClubsList(filteredClubs),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClubDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Club> _getFilteredClubs(ClubProvider clubProvider) {
    List<Club> clubs = _selectedCategory == 'All'
        ? clubProvider.clubs
        : clubProvider.getClubsByCategory(_selectedCategory);

    if (_searchQuery.isNotEmpty) {
      clubs = clubs.where((club) {
        return club.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            club.description?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
            club.category.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return clubs;
  }

  Widget _buildClubsList(List<Club> clubs) {
    if (clubs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No clubs found', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clubs.length,
      itemBuilder: (context, index) {
        final club = clubs[index];
        return _ClubCard(club: club);
      },
    );
  }

  void _showAddClubDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _AddClubDialog(),
    );
  }
}

class _ClubCard extends StatelessWidget {
  final Club club;

  const _ClubCard({required this.club});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getCategoryColor(club.category),
                  child: Icon(
                    _getCategoryIcon(club.category),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        club.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        club.category,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      label: Text(
                          club.memberLimit != null
                              ? '${club.memberCount}/${club.memberLimit} members'
                              : '${club.memberCount} members'
                      ),
                      backgroundColor: club.isFull
                          ? Colors.red.shade100
                          : Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    if (club.isFull)
                      const Text(
                        'FULL',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (club.description != null) ...[
              const SizedBox(height: 12),
              Text(
                club.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 12),
            if (club.meetingTime != null)
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    club.meetingTime!,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            if (club.location != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      club.location!,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ],
            if (club.contactEmail != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      club.contactEmail!,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => _showClubMembers(context, club),
                  icon: const Icon(Icons.people),
                  label: const Text('View Members'),
                ),
                ElevatedButton.icon(
                  onPressed: club.isFull ? null : () => _showJoinClubDialog(context, club),
                  icon: const Icon(Icons.person_add),
                  label: Text(club.isFull ? 'Full' : 'Join Club'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: club.isFull ? Colors.grey : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinClubDialog(BuildContext context, Club club) {
    showDialog(
      context: context,
      builder: (context) => _JoinClubDialog(club: club),
    );
  }

  void _showClubMembers(BuildContext context, Club club) {
    showDialog(
      context: context,
      builder: (context) => _ClubMembersDialog(club: club),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Academic':
        return Colors.blue;
      case 'Arts':
        return Colors.purple;
      case 'Service':
        return Colors.green;
      case 'Sports':
        return Colors.red;
      case 'Technology':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Icons.school;
      case 'Arts':
        return Icons.palette;
      case 'Service':
        return Icons.volunteer_activism;
      case 'Sports':
        return Icons.sports;
      case 'Technology':
        return Icons.computer;
      default:
        return Icons.group;
    }
  }
}

class _AddClubDialog extends StatefulWidget {
  const _AddClubDialog();

  @override
  State<_AddClubDialog> createState() => _AddClubDialogState();
}

class _AddClubDialogState extends State<_AddClubDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();
  final _meetingTimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _memberLimitController = TextEditingController();

  String _selectedCategory = 'Academic';
  bool _hasLimit = false;
  final List<String> _categories = ['Academic', 'Arts', 'Service', 'Sports', 'Technology', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _meetingTimeController.dispose();
    _locationController.dispose();
    _memberLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Club'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Club Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a club name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _meetingTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Meeting Time',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Wednesdays 6:00 PM',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Meeting Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Set Member Limit'),
                  subtitle: const Text('Optional: Limit the number of members'),
                  value: _hasLimit,
                  onChanged: (value) {
                    setState(() {
                      _hasLimit = value ?? false;
                      if (!_hasLimit) {
                        _memberLimitController.clear();
                      }
                    });
                  },
                ),
                if (_hasLimit) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _memberLimitController,
                    decoration: const InputDecoration(
                      labelText: 'Maximum Members',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., 50',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_hasLimit && (value == null || value.isEmpty)) {
                        return 'Please enter a member limit';
                      }
                      if (_hasLimit && int.tryParse(value!) == null) {
                        return 'Please enter a valid number';
                      }
                      if (_hasLimit && int.parse(value!) <= 0) {
                        return 'Member limit must be greater than 0';
                      }
                      return null;
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveClub,
          child: const Text('Add Club'),
        ),
      ],
    );
  }

  void _saveClub() {
    if (_formKey.currentState!.validate()) {
      final club = Club(
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        category: _selectedCategory,
        contactEmail: _contactController.text.isEmpty ? null : _contactController.text,
        meetingTime: _meetingTimeController.text.isEmpty ? null : _meetingTimeController.text,
        location: _locationController.text.isEmpty ? null : _locationController.text,
        memberLimit: _hasLimit ? int.parse(_memberLimitController.text) : null,
        createdAt: DateTime.now(),
      );

      context.read<ClubProvider>().addClub(club);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Club added successfully!')),
      );
    }
  }
}
class _JoinClubDialog extends StatefulWidget {
  final Club club;

  const _JoinClubDialog({required this.club});

  @override
  State<_JoinClubDialog> createState() => _JoinClubDialogState();
}

class _JoinClubDialogState extends State<_JoinClubDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _majorController = TextEditingController();

  int? _selectedYear;
  bool _isLoading = false;

  final List<int> _years = [1, 2, 3, 4, 5]; // Academic years

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Join ${widget.club.name}'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Club info summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.club.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.club.memberLimit != null)
                        Text(
                          'Available spots: ${widget.club.memberLimit! - widget.club.memberCount}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Student information form
                Text(
                  'Student Information',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(
                    labelText: 'Student ID *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                    hintText: 'e.g., 2024001234',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your student ID';
                    }
                    if (value.length < 6) {
                      return 'Student ID must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    hintText: 'your.email@university.edu',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    hintText: '+1 (555) 123-4567',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _majorController,
                  decoration: const InputDecoration(
                    labelText: 'Major/Field of Study (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                    hintText: 'e.g., Computer Science',
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<int>(
                  value: _selectedYear,
                  decoration: const InputDecoration(
                    labelText: 'Academic Year (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  items: _years.map((year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text('Year $year'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Terms and conditions
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By joining this club, you agree to:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '• Attend regular meetings and activities\n'
                            '• Follow club rules and guidelines\n'
                            '• Respect other members and club property\n'
                            '• Provide accurate contact information',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _joinClub,
          child: _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Join Club'),
        ),
      ],
    );
  }

  Future<void> _joinClub() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final member = ClubMember(
        clubId: widget.club.id!,
        studentName: _nameController.text.trim(),
        studentId: _studentIdController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        major: _majorController.text.trim().isEmpty ? null : _majorController.text.trim(),
        year: _selectedYear,
        joinedAt: DateTime.now(),
      );

      final success = await context.read<ClubProvider>().joinClub(widget.club, member);

      if (success) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully joined ${widget.club.name}!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to join club. It may be full.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _ClubMembersDialog extends StatefulWidget {
  final Club club;

  const _ClubMembersDialog({required this.club});

  @override
  State<_ClubMembersDialog> createState() => _ClubMembersDialogState();
}

class _ClubMembersDialogState extends State<_ClubMembersDialog> {
  List<ClubMember> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final members = await context.read<ClubProvider>().getClubMembers(widget.club.id!);
      if (mounted) {
        setState(() {
          _members = members;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading members: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.club.name} Members'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            // Club stats
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '${widget.club.memberCount}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Total Members'),
                    ],
                  ),
                  if (widget.club.memberLimit != null)
                    Column(
                      children: [
                        Text(
                          '${widget.club.memberLimit! - widget.club.memberCount}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: widget.club.isFull ? Colors.red : Colors.green,
                          ),
                        ),
                        const Text('Available Spots'),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Members list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _members.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No members yet'),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  final member = _members[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          member.studentName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        member.studentName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${member.studentId}'),
                          if (member.major != null)
                            Text('Major: ${member.major}'),
                          if (member.year != null)
                            Text('Year: ${member.year}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Joined',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '${member.joinedAt.day}/${member.joinedAt.month}/${member.joinedAt.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _showMemberDetails(member),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  void _showMemberDetails(ClubMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member.studentName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(label: 'Student ID', value: member.studentId),
            _DetailRow(label: 'Email', value: member.email),
            if (member.phone != null)
              _DetailRow(label: 'Phone', value: member.phone!),
            if (member.major != null)
              _DetailRow(label: 'Major', value: member.major!),
            if (member.year != null)
              _DetailRow(label: 'Academic Year', value: 'Year ${member.year}'),
            _DetailRow(
              label: 'Joined Date',
              value: '${member.joinedAt.day}/${member.joinedAt.month}/${member.joinedAt.year}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
