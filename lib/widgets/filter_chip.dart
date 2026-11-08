import 'package:flutter/material.dart';

class FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const FilterChip({
    super.key,
    required this.label,
    this.selected = false,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : Colors.grey.shade700,
        ),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF111827),
        side: BorderSide(
          color: selected ? Colors.transparent : Colors.grey.shade200,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
