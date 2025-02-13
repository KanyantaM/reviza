import 'package:flutter/material.dart';
import 'package:reviza/widgets/range_slider.dart';

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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}

class PaperUploadForm extends StatefulWidget {
  const PaperUploadForm({super.key, required this.coursName});
  final String coursName;

  @override
  State<PaperUploadForm> createState() => _PaperUploadFormState();
}

class _PaperUploadFormState extends State<PaperUploadForm> {
  String _category = 'TEST';
  // bool _agreeToTerms = false;
  bool _isRangeSelected = false;
  int _startingYear = DateTime.now().year - 1;
  int _endingYear = DateTime.now().year - 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRadioButtons(),
        if (_isRangeSelected) _buildYearRangeDropdowns(),
        if (!_isRangeSelected) _buildSingleYearDropdown(),
        const SizedBox(height: 16),
        _buildCategoryChips(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Year Range:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Radio(
              value: false,
              groupValue: _isRangeSelected,
              onChanged: (value) {
                setState(() {
                  _isRangeSelected = false;
                });
              },
            ),
            const Text('Single Year'),
            const SizedBox(width: 16),
            Radio(
              value: true,
              groupValue: _isRangeSelected,
              onChanged: (value) {
                setState(() {
                  _isRangeSelected = true;
                });
              },
            ),
            const Text('Year Range'),
          ],
        ),
      ],
    );
  }

  Widget _buildYearRangeDropdowns() {
    return Row(
      children: [
        _buildYearDropdown(
          label: 'Starting Year',
          value: _startingYear,
          onChanged: (value) {
            setState(() {
              _startingYear = value ?? 2023;
            });
          },
        ),
        const SizedBox(width: 16),
        _buildYearDropdown(
          label: 'Ending Year',
          value: _endingYear,
          onChanged: (value) {
            setState(() {
              _endingYear = value ?? 2023;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSingleYearDropdown() {
    return _buildYearDropdown(
      label: 'Year',
      value: _startingYear,
      onChanged: (value) {
        setState(() {
          _startingYear = value ?? 2023;
        });
      },
    );
  }

  Widget _buildYearDropdown(
      {required String label,
      required int value,
      required ValueChanged<int?> onChanged}) {
    return SizedBox(
      width: 150, // Set a fixed width for the dropdown container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButton<int>(
            value: value,
            onChanged: onChanged,
            items: List.generate(
              10,
              (index) => DropdownMenuItem<int>(
                value: DateTime.now().year - index,
                child: Text((DateTime.now().year - index).toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Category:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Expanded(
            child: Wrap(
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              children: [
                for (String categoryOption in [
                  'TEST',
                  'EXAM',
                  'SUP',
                  'MAKE-UP',
                  'OTHER'
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(categoryOption),
                      selected: _category == categoryOption,
                      onSelected: (bool selected) {
                        setState(() {
                          _category = selected ? categoryOption : '';
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DocumentUploadForm extends StatefulWidget {
  const DocumentUploadForm({super.key, required this.courseName});
  final String courseName;

  @override
  State<DocumentUploadForm> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUploadForm> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _authorNameEditingController =
      TextEditingController();
  double _startingUnit = 0;
  double _endingUnit = 0;
  double _singleUnitValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(height: 16),
      CustomFormField(
        title: 'Title',
        textEditingController: _titleEditingController,
      ),
      const SizedBox(height: 16),
      CustomFormField(
        title: 'Author Name',
        textEditingController: _authorNameEditingController,
      ),
      const SizedBox(height: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Lecture Range',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          RangeSliderWidget(
            onRangeChanged: (values) {
              if (values.start != values.end) {
                _startingUnit = values.start;
                _endingUnit = values.end;
              } else {
                _singleUnitValue = values.start;
              }
            },
          ),
        ],
      ),
      const SizedBox(height: 16),
    ]);
  }
}

class LinkUploadForm extends StatefulWidget {
  const LinkUploadForm({super.key, required this.courseName});
  final String courseName;

  @override
  State<LinkUploadForm> createState() => _LinkUploadFormState();
}

class _LinkUploadFormState extends State<LinkUploadForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 16),
      CustomFormField(
        title: 'Description',
        textEditingController: _titleController,
      ),
      const SizedBox(height: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'URL',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'enter url';
              } else if (value?.startsWith('https://') ?? false) {
                return null;
              } else {
                return 'enter a valid url';
              }
            },
            controller: _urlController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 8),
        ],
      ),
    ]);
  }
}
