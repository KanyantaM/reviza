import 'package:flutter/material.dart';

class SimilarSubjectsWidget extends StatelessWidget {
  final List<String> similarSubjects;
  final String title = "SIMILAR SUBJECTS";

  const SimilarSubjectsWidget({super.key, required this.similarSubjects});

  @override
  Widget build(BuildContext context) {
    // final primary = Theme.of(context).colorScheme.onPrimary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        // color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
        // collapsedBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // expandedBackgroundColor: Colors.white.withOpacity(0.91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  // color: primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        children: <Widget>[
          const Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Note:",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge,
                        // ?.copyWith(color: primary),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    "These subjects are recommended based on similarity with the subject name.",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GenericSubjectTileView(
                    similarSubjects: similarSubjects,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenericSubjectTileView extends StatelessWidget {
  final List<String> similarSubjects;

  const GenericSubjectTileView({super.key, required this.similarSubjects});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: similarSubjects.map((subject) {
        return ListTile(
          title: Text(subject),
        );
      }).toList(),
    );
  }


}