import 'package:flutter/material.dart';
import 'package:study_material_repository/study_material_repository.dart';

class UploadTypeSelector extends StatelessWidget {
  final Types? selectedType;
  final Function(Types type) onTypeSelected;

  UploadTypeSelector(
      {super.key, required this.selectedType, required this.onTypeSelected});
  final List<Map<String, dynamic>> types = [
    {'title': 'Notes', 'icon': Icons.note, 'type': Types.notes},
    {'title': 'Papers', 'icon': Icons.description, 'type': Types.papers},
    {'title': 'Books', 'icon': Icons.book, 'type': Types.books},
    // {'title': 'Links', 'icon': Icons.link, 'type': Types.links},
    {
      'title': 'Assignments',
      'icon': Icons.assignment,
      'type': Types.assignment
    },
    {'title': 'Labs', 'icon': Icons.science, 'type': Types.lab},
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: types.map((item) {
            final bool isSelected = selectedType == item['type'];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: InkWell(
                onTap: () {
                  onTypeSelected(item['type']);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green.withAlpha(100)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        item['icon'] as IconData?,
                        size: 36,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).disabledColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
