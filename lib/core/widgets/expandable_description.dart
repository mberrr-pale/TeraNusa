import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ExpandableDescription extends StatefulWidget {
  final String description;
  final int maxParagraphs;
  final TextStyle? textStyle;

  const ExpandableDescription({
    super.key,
    required this.description,
    this.maxParagraphs = 2,
    this.textStyle,
  });

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _isExpanded = false;

  List<String> get _paragraphs {
    return widget.description
        .split(RegExp(r'\n\s*\n'))
        .map((paragraph) => paragraph.trim())
        .where((paragraph) => paragraph.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final paragraphs = _paragraphs;
    final hasMore = paragraphs.length > widget.maxParagraphs;

    final visibleParagraphs = _isExpanded || !hasMore
        ? paragraphs
        : paragraphs.take(widget.maxParagraphs).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visibleParagraphs.map(
          (paragraph) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              paragraph,
              style:
                  widget.textStyle ?? AppTextStyles.body.copyWith(height: 1.6),
            ),
          ),
        ),

        if (hasMore)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded
                        ? 'Tampilkan lebih sedikit'
                        : 'Baca selengkapnya',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
