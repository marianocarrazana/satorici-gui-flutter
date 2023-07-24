// app_menu.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'frosted_container.dart';
import 'states.dart';

class AppMenu extends ConsumerWidget {
  final List _pageList = [
    {'title': 'Home', 'route': '/home', 'icon': Icons.home},
    {'title': 'Reports', 'route': '/reports', 'icon': Icons.featured_play_list},
    {'title': 'Commits', 'route': '/commits', 'icon': Icons.commit},
    {'title': 'Repos', 'route': '/repos', 'icon': Icons.dashboard},
    {'title': 'Monitor', 'route': '/monitor', 'icon': Icons.av_timer},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrostedContainer(
      margin: 12.0,
      child: ListView(
        children: <Widget>[
          // iterate through the keys to get the page names
          for (var page in _pageList)
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ref.watch(currentPage) == page['route']
                      ? Colors.white.withOpacity(.6)
                      : Colors.transparent,
                ),
                child: PageListTile(
                    pageData: page,
                    onPressed: () =>
                        Navigator.pushNamed(context, page['route']))),
        ],
      ),
    );
  }
}

class PageListTile extends StatelessWidget {
  const PageListTile({
    Key? key,
    required this.pageData,
    this.onPressed,
  }) : super(key: key);
  final Map pageData;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(pageData['icon']),
      title: Text(
        pageData['title'],
        textAlign: TextAlign.left,
        textScaleFactor: 1.5,
      ),
      onTap: onPressed,
    );
  }
}
