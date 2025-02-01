import 'package:flutter/material.dart';
import 'package:reviza/features/view_subjects/view_subjects.dart';

class SubjectListTile extends StatelessWidget {
  const SubjectListTile({
    super.key,
    required this.isDelete,
    required this.subject,
    required this.isSelected,
    required this.uid,
  });

  final bool isDelete;
  final String subject;
  final bool isSelected;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        onTap: !isDelete
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewMaterialPage(
                      isDownloadedView: false,
                      uid: uid,
                      courseName: subject,
                    ),
                  ),
                );
              }
            : null, // No tap action in delete mode
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: isDelete
                ? Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? Colors.green : null,
                  )
                : const Icon(Icons.more_vert),
            title: Text(
              subject,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            trailing: !isDelete
                ? const Icon(Icons.arrow_forward_ios_rounded, size: 18)
                : null,
            contentPadding: EdgeInsets.zero, // Prevents extra padding
          ),
        ),
      ),
    );
  }
}
