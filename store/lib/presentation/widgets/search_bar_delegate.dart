import 'package:flutter/material.dart';

class PersistentSearchBarDelegate extends SliverPersistentHeaderDelegate {
  /// Fixed total height of the search bar (content only, no top padding)
  static const double _barHeight = 74.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search boutique, clinics...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.mic_none, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A192F),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => _barHeight;

  @override
  double get minExtent => _barHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
