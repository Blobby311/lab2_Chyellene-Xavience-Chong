import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/image_section.dart';
import 'widgets/student_details_section.dart';
import 'widgets/text_section.dart';
import 'widgets/title_section.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const AdaptivePage(),
    );
  }
}

class AdaptivePage extends StatefulWidget {
  const AdaptivePage({super.key});

  @override
  State<AdaptivePage> createState() => _AdaptivePageState();
}

class _AdaptivePageState extends State<AdaptivePage> {
  DateTime? _selectedDate;
  String _selectedRole = 'Student';
  final List<String> _roles = ['Student', 'Developer', 'Designer'];

  // Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Cupertino Date Picker (modal sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          Container(
            height: 240,
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDate) {
                setState(() => _selectedDate = newDate);
              },
            ),
          ),
    );
  }

  // Cupertino wheel picker (modal sheet)
  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          Container(
            height: 200,
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: CupertinoPicker(
              itemExtent: 32,
              onSelectedItemChanged: (int index) {
                setState(() => _selectedRole = _roles[index]);
              },
              children: _roles
                  .map((role) => Center(child: Text(role)))
                  .toList(),
            ),
          ),
    );
  }

  // All four pickers in one section
  Widget _buildPickers(BuildContext context) {
    final d = _selectedDate;
    final dateText =
    d == null ? 'No date selected' : '${d.day}/${d.month}/${d.year}';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: $dateText'),
          Text('Role: $_selectedRole'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _selectMaterialDate(context),
            child: const Text('Material Date Picker'),
          ),
          ElevatedButton(
            onPressed: () => _showCupertinoDatePicker(context),
            child: const Text('Cupertino Date Picker'),
          ),
          const SizedBox(height: 12),
          DropdownButton<String>(
            value: _selectedRole,
            items: _roles.map((String role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() => _selectedRole = newValue);
              }
            },
          ),
          ElevatedButton(
            onPressed: () => _showCupertinoRolePicker(context),
            child: const Text('Cupertino Role Picker'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView(context)
              : _buildLandscapeView(context);
        },
      ),
    );
  }

  Widget _buildPortraitView(BuildContext context) {
    return ListView(
      children: [
        const StudentDetailsSection(),
        const TitleSection(
          name: 'Oeschinen Lake',
          location: 'Kandersteg, Switzerland',
          starCount: 41,
        ),
        const ImageSection(imagePath: 'assets/images/lake.jpg'),
        const TextSection(),
        _buildPickers(context),
      ],
    );
  }

  Widget _buildLandscapeView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side: student card
        const Expanded(
          child: SingleChildScrollView(
            child: StudentDetailsSection(),
          ),
        ),
        // Right side: title, image, text, pickers
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const TitleSection(
                name: 'Oeschinen Lake',
                location: 'Kandersteg, Switzerland',
                starCount: 41,
              ),
              const ImageSection(imagePath: 'assets/images/lake.jpg'),
              const TextSection(),
              _buildPickers(context),
            ],
          ),
        ),
      ],
    );
  }
}

