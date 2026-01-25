import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/helpers.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    super.key,
    required this.filterList,
    required this.onFilter,
    required this.onClear,
  });

  final List<String> filterList;
  final VoidCallback? onFilter;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          HapticFeedback.selectionClick();

          Future.delayed(const Duration(milliseconds: 120), () {
            onFilter?.call();
          });
        },
        splashColor: Colors.black.withOpacity(0.08),
        highlightColor: Colors.black.withOpacity(0.04),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title row
              Row(
                children: [
                  Svvg.asset('sort', size: 20),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context)!.filterAndSort,
                    style: const TextStyle(color: Color(0xFF474747)),
                  ),
                ],
              ),

              /// Selected filters
              if (filterList.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        filterList.join(", "),
                        style: const TextStyle(
                          color: Color(0xFF969696),
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: onClear,
                      icon: const Icon(Icons.highlight_remove),
                      splashRadius: 18,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
