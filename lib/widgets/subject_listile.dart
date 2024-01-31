import 'package:flutter/material.dart';
import 'package:reviza/features/view_subjects/view_subjects.dart';
import 'package:reviza/ui/custom_text.dart';

class SubjectListTile extends StatefulWidget {
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
  State<SubjectListTile> createState() => _SubjectListTileState();
}

class _SubjectListTileState extends State<SubjectListTile> {
  @override
  Widget build(BuildContext context) {
    return !widget.isDelete
        ? Card(
            child: InkWell(
              splashColor: Colors.grey.shade200,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewMaterialPage(isDownloadedView: false, uid: widget.uid, courseName: widget.subject,)));
              },
              child: SizedBox(
                height: 70,
                child: Center(
                  child: ListTile(
                    leading: const Icon(Icons.more_vert),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                        title: widget.subject,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                    ),
                  ),
                ),
              ),
            ),
          )
        : Card(
            child: SizedBox(
              height: 70,
              child: Center(
                child: ListTile(
                  leading: !widget.isSelected
                      ? const Icon(Icons.circle_outlined)
                      : const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      title: widget.subject,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
