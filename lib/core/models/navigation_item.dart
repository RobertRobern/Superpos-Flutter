import 'package:flutter/material.dart';

/// Represents a navigation item in the side menu
class NavigationItem {
  final String title;
  final IconData icon;
  final String? route;
  final List<NavigationItem> children;
  final bool isSection;

  const NavigationItem({
    required this.title,
    required this.icon,
    this.route,
    this.children = const [],
    this.isSection = false,
  });
}

/// Section titles for grouping navigation items
class NavigationSection {
  static const String pointOfSale = 'POINT OF SALE';
  static const String procurement = 'PROCUREMENT';
  static const String communication = 'COMMUNICATION';
  static const String administration = 'ADMINISTRATION';
}
