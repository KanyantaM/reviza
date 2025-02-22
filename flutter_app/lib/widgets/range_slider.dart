import 'package:flutter/material.dart';

class RangeSliderWidget extends StatefulWidget {
  final RangeValues initialRangeValues;
  final ValueChanged<RangeValues> onRangeChanged;

  const RangeSliderWidget({
    super.key,
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
        if (values.start >= 0 && values.end >= 0) {
          setState(() {
            _currentRangeValues = values;
            widget.onRangeChanged(values);
          });
        }
      },
      min: 0,
      max: 15,
      divisions: 15,
      labels: RangeLabels(
        _currentRangeValues.start.toString(),
        _currentRangeValues.end.toString(),
      ),
    );
  }
}
