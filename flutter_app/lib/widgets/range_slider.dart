import 'package:flutter/material.dart';

class RangeSliderWidget extends StatefulWidget {
  final RangeValues initialRangeValues;
  final ValueChanged<RangeValues> onRangeChanged;

  const RangeSliderWidget({super.key, 
    this.initialRangeValues = const RangeValues(0, 0),
    required this.onRangeChanged,
  });

  @override
  State<RangeSliderWidget> createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = widget.initialRangeValues;
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      onChanged: (values) {
        // Enforce non-negative ranges
        if (values.start >= 0 && values.end >= 0) {
          setState(() {
            _currentRangeValues = values;
            widget.onRangeChanged(values);
          });
        }
      },
      min: 0,
      max: 15, // Adjust this based on your desired range
      divisions: 15, // Optional for discrete steps
      labels: RangeLabels(
        _currentRangeValues.start.toString(),
        _currentRangeValues.end.toString(),
      ),
      // activeColor: Colors.blue,
      // inactiveColor: Colors.grey[300],
    );
  }
}
