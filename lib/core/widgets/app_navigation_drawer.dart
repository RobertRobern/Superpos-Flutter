import 'package:flutter/material.dart';
import 'package:superpos/core/models/navigation_item.dart';

class AppNavigationDrawer extends StatelessWidget {
  final List<NavigationItem> items;
  final String currentRoute;
  final bool isPinned;

  const AppNavigationDrawer({
    super.key,
    required this.items,
    required this.currentRoute,
    this.isPinned = false,
  });

  @override
  Widget build(BuildContext context) {
    final drawerWidth = 230.0;
    final drawerContent = _buildDrawerContent(context);

    // For pinned mode (used in desktop layout)
    if (isPinned) {
      return Container(
        width: drawerWidth,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFC),
          border: Border(
            right: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: drawerContent,
      );
    }

    // For mobile/tablet mode (regular drawer)
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        backgroundColor: const Color(0xFFF9FAFC),
        child: drawerContent,
      ),
    );
  }

  Widget _buildDrawerContent(BuildContext context) {
    return Column(
      children: [
        // Drawer header with user info
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: Colors.blue),
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.blue),
          ),
          accountName: const Text('Admin User'),
          accountEmail: const Text('admin@superpos.com'),
        ),

        // Navigation items in a scrollable list
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              if (item.isSection) {
                return _buildSection(context, item);
              }
              return _buildNavigationItem(context, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, NavigationItem section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            section.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...section.children.map((item) => _buildNavigationItem(context, item)),
      ],
    );
  }

  Widget _buildNavigationItem(BuildContext context, NavigationItem item) {
    final isSelected = item.route == currentRoute;

    return ListTile(
      leading: Icon(
        item.icon,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[900],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: Theme.of(context).primaryColor,
      onTap: item.route == null
          ? null
          : () {
              // Only pop the drawer if we're not in pinned mode
              if (!isPinned) {
                Navigator.pop(context);
              }
              if (item.route != currentRoute) {
                // TODO: Implement navigation in Phase 2
                // Navigator.pushNamed(context, item.route!);
              }
            },
    );
  }
}
