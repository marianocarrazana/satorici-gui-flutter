// app_menu.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMenu extends StatelessWidget {
  final _pageList = {
    'Home': '/home',
    'CI': '/reports',
    'Monitor': '/monitor',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      body: ListView(
        // Note: use ListView.builder if there are many items
        children: <Widget>[
          // iterate through the keys to get the page names
          for (String pageName in _pageList.keys)
            PageListTile(
              pageName: pageName,
              onPressed: () => Get.toNamed(_pageList[pageName]!),
            ),
        ],
      ),
    );
  }
}

class PageListTile extends StatelessWidget {
  const PageListTile({
    Key? key,
    this.selectedPageName,
    required this.pageName,
    this.onPressed,
  }) : super(key: key);
  final String? selectedPageName;
  final String pageName;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // show a check icon if the page is currently selected
      // note: we use Opacity to ensure that all tiles have a leading widget
      // and all the titles are left-aligned
      leading: Opacity(
        opacity: selectedPageName == pageName ? 1.0 : 0.0,
        child: Icon(Icons.check),
      ),
      title: Text(pageName),
      onTap: onPressed,
    );
  }
}
