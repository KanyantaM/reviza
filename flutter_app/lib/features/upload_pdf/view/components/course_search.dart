import 'package:flutter/material.dart';

Widget buildSearchableDropdown(
    String label, List<String> options, Function(String selected) onChanged) {
  return Autocomplete<String>(
    optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text.isEmpty) {
        return const Iterable<String>.empty();
      }
      return options.where((option) =>
          option
              .toLowerCase()
              .startsWith(textEditingValue.text.toLowerCase()) ||
          option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
    },
    onSelected: onChanged,
    fieldViewBuilder:
        (context, textEditingController, focusNode, onEditingComplete) {
      return TextFormField(
        decoration: InputDecoration(labelText: label),
        controller: textEditingController,
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
      );
    },
  );
}
