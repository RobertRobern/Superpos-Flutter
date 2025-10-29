import 'package:flutter/material.dart';
import 'package:superpos/core/models/navigation_item.dart';

/// Defines the navigation structure for the application
class NavigationConfig {
  static List<NavigationItem> items = [
    // Point of Sale Section
    NavigationItem(
      title: NavigationSection.pointOfSale,
      icon: Icons.point_of_sale,
      isSection: true,
      children: [
        NavigationItem(title: 'POS', icon: Icons.shopping_cart, route: '/pos'),
        NavigationItem(
          title: 'Products',
          icon: Icons.inventory_2,
          route: '/products',
        ),
        NavigationItem(
          title: 'Customers',
          icon: Icons.people,
          route: '/customers',
        ),
        NavigationItem(
          title: 'Reports',
          icon: Icons.bar_chart,
          route: '/reports',
        ),
      ],
    ),

    // Procurement Section
    NavigationItem(
      title: NavigationSection.procurement,
      icon: Icons.shopping_bag,
      isSection: true,
      children: [
        NavigationItem(
          title: 'Requisitions',
          icon: Icons.request_page,
          route: '/requisitions',
        ),
        NavigationItem(
          title: 'Purchase Orders',
          icon: Icons.receipt_long,
          route: '/purchase-orders',
        ),
        NavigationItem(
          title: 'Receiving',
          icon: Icons.inventory,
          route: '/receiving',
        ),
        NavigationItem(
          title: 'Invoices',
          icon: Icons.description,
          route: '/invoices',
        ),
        NavigationItem(
          title: 'Suppliers',
          icon: Icons.local_shipping,
          route: '/suppliers',
        ),
      ],
    ),

    // Communication Section
    NavigationItem(
      title: NavigationSection.communication,
      icon: Icons.message,
      isSection: true,
      children: [
        NavigationItem(title: 'SMS', icon: Icons.sms, route: '/sms'),
        NavigationItem(title: 'Emails', icon: Icons.email, route: '/emails'),
      ],
    ),

    // Administration Section
    NavigationItem(
      title: NavigationSection.administration,
      icon: Icons.admin_panel_settings,
      isSection: true,
      children: [
        NavigationItem(title: 'Users', icon: Icons.people, route: '/users'),
        NavigationItem(
          title: 'Roles & Permissions',
          icon: Icons.security,
          route: '/roles',
        ),
        NavigationItem(
          title: 'Audit Log',
          icon: Icons.history,
          route: '/audit-log',
        ),
        NavigationItem(
          title: 'Settings',
          icon: Icons.settings,
          route: '/settings',
        ),
      ],
    ),
  ];
}
