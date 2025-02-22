import 'package:flutter/material.dart';
import 'package:reviza/features/upload_pdf/view/components/annotatio_button.dart';
import 'package:reviza/widgets/range_slider.dart';
import 'package:study_material_repository/study_material_repository.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.title,
    required this.textEditingController,
  });

  final String title;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}

class PaperUploadForm extends StatefulWidget {
  const PaperUploadForm(
      {super.key, required this.courseName, required this.materialId});
  final String courseName;
  final String materialId;

  @override
  State<PaperUploadForm> createState() => _PaperUploadFormState();
}

class _PaperUploadFormState extends State<PaperUploadForm> {
  bool _isRangeSelected = false;
  int _startingYear = DateTime.now().year - 1;
  int _endingYear = DateTime.now().year - 1;
  String _category = 'TEST';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRadioButtons(),
        _isRangeSelected
            ? _buildYearRangeDropdowns()
            : _buildSingleYearDropdown(),
        const SizedBox(height: 16),
        _buildCategoryChips(),
        AnnotatioButton(
          selectedCourse: widget.courseName,
          type: Types.papers,
          materialId: widget.materialId,
          isRangeSelected: _isRangeSelected,
          startingYear: _startingYear,
          endingYear: _endingYear,
          category: _category,
        )
      ],
    );
  }

  Widget _buildRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Year Range:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRadioOption('Single Year', false),
            const SizedBox(width: 16),
            _buildRadioOption('Range', true),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, bool value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: _isRangeSelected,
          onChanged: (val) => setState(() => _isRangeSelected = value),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildYearRangeDropdowns() {
    return Row(
      children: [
        _buildYearDropdown('Starting Year', _startingYear,
            (value) => setState(() => _startingYear = value!)),
        const SizedBox(width: 16),
        _buildYearDropdown('Ending Year', _endingYear,
            (value) => setState(() => _endingYear = value!)),
      ],
    );
  }

  Widget _buildSingleYearDropdown() {
    return _buildYearDropdown('Year', _startingYear,
        (value) => setState(() => _startingYear = value!));
  }

  Widget _buildYearDropdown(
      String label, int value, ValueChanged<int?> onChanged) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<int>(
            value: value,
            onChanged: onChanged,
            items: List.generate(10, (index) {
              int year = DateTime.now().year - index;
              return DropdownMenuItem(
                  value: year, child: Text(year.toString()));
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    const categories = ['TEST', 'EXAM', 'SUP', 'MAKE-UP', 'OTHER'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Category:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: categories.map((category) {
            return FilterChip(
              label: Text(category),
              selected: _category == category,
              onSelected: (selected) => setState(() => _category = category),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class DocumentUploadForm extends StatelessWidget {
  const DocumentUploadForm({
    super.key,
    required this.courseName,
    required this.materialId,
    required this.type,
  });

  final String courseName;
  final String materialId;
  final Types type;

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final authorController = TextEditingController();

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomFormField(
              title: 'Title', textEditingController: titleController),
          const SizedBox(height: 16),
          CustomFormField(
              title: 'Author Name', textEditingController: authorController),
          const SizedBox(height: 16),
          const Text('Enter Lecture Range',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          RangeSliderWidget(onRangeChanged: (values) {}),
          AnnotatioButton(
            selectedCourse: courseName,
            type: type,
            materialId: materialId,
            title: titleController.text,
            authorName: authorController.text,
          )
        ],
      ),
    );
  }
}

class LinkUploadForm extends StatelessWidget {
  const LinkUploadForm({super.key, required this.courseName});
  final String courseName;

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    return Column(
      children: [
        CustomFormField(
            title: 'Description', textEditingController: titleController),
        const SizedBox(height: 16),
        CustomFormField(title: 'URL', textEditingController: urlController),
      ],
    );
  }
}
