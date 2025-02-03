import 'package:flutter/material.dart';

class AddSubjectListTile extends StatelessWidget {
  final Function(String) onTap;
  final String value;
  final bool isSelected;

  const AddSubjectListTile({
    super.key,
    required this.onTap,
    required this.value,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => onTap(value),
          leading: Icon(
            isSelected ? Icons.check_box : Icons.check_box_outline_blank,
            color: isSelected ? Theme.of(context).primaryColor : null,
          ),
          title: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
