import 'package:flutter/material.dart' as flutter;
import 'package:dropdown_search/dropdown_search.dart';

class AppDropdown<T> extends flutter.StatelessWidget {
  final String label;
  final String hint;

  final T? value;
  final List<T> items;

  final String Function(T) itemAsString;
  final flutter.ValueChanged<T?> onChanged;

  final String? Function(T?)? validator;

  final String searchHint;
  final String emptyText;

  final bool enabled;
  final bool showSearchBox;

  final double maxPopupHeight;

  const AppDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    this.validator,
    this.searchHint = 'Cari data...',
    this.emptyText = 'Data tidak ditemukan',
    this.enabled = true,
    this.showSearchBox = true,
    this.maxPopupHeight = 400,
  });

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return flutter.Column(
      crossAxisAlignment: flutter.CrossAxisAlignment.start,
      children: [
        flutter.Text(
          label,
          style: const flutter.TextStyle(
            fontSize: 12,
            fontWeight: flutter.FontWeight.w600,
          ),
        ),

        const flutter.SizedBox(height: 8),

        DropdownSearch<T>(
          enabled: enabled,

          items: (filter, loadProps) async {
            final query = filter.trim().toLowerCase();

            if (query.isEmpty) {
              return items;
            }

            return items.where((item) {
              return itemAsString(item).toLowerCase().contains(query);
            }).toList();
          },

          selectedItem: value,

          itemAsString: itemAsString,

          compareFn: (a, b) => a == b,

          onChanged: onChanged,

          validator: validator,

          decoratorProps: DropDownDecoratorProps(
            decoration: flutter.InputDecoration(
              hintText: hint,
              contentPadding: const flutter.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: const flutter.OutlineInputBorder(),
            ),
          ),

          popupProps: PopupProps.dialog(
            showSearchBox: showSearchBox,

            constraints: flutter.BoxConstraints(maxHeight: maxPopupHeight),

            searchFieldProps: TextFieldProps(
              decoration: const flutter.InputDecoration(
                hintText: 'Cari data...',
                prefixIcon: flutter.Icon(flutter.Icons.search),
              ),
            ),

            emptyBuilder: (context, searchEntry) {
              return flutter.Padding(
                padding: const flutter.EdgeInsets.all(20),
                child: flutter.Center(child: flutter.Text(emptyText)),
              );
            },
          ),
        ),
      ],
    );
  }
}
