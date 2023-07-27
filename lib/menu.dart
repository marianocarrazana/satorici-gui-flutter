import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/satori_container.dart';
import 'states.dart';

class AppMenu extends ConsumerWidget {
  AppMenu({super.key, this.hue});
  final double? hue;
  final List _pageList = [
    {'title': 'Home', 'route': '/', 'icon': Icons.home, "hue": 138.0},
    {
      'title': 'Reports',
      'route': '/reports',
      'icon': Icons.featured_play_list,
      "hue": 238.0
    },
    {'title': 'Teams', 'route': '/teams', 'icon': Icons.people, "hue": 0.0},
    {'title': 'Repos', 'route': '/repos', 'icon': Icons.dashboard, "hue": 38.0},
    {
      'title': 'Monitor',
      'route': '/monitors',
      'icon': Icons.av_timer,
      "hue": 98.0
    },
    {
      'title': 'Playbooks',
      'route': '/playbooks',
      'icon': Icons.av_timer,
      "hue": 298.0
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SatoriContainer(
      margin: 12,
      child: ListView(
        children: <Widget>[
          // iterate through the keys to get the page names
          for (var page in _pageList)
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ref.watch(currentPage) == page['route']
                      ? Colors.white.withOpacity(.16)
                      : Colors.transparent,
                ),
                child: PageListTile(
                    pageData: page,
                    onPressed: () {
                      ref.read(currentPage.notifier).state = page['route'];
                      ref.read(pageHue.notifier).state = page['hue'];
                      Navigator.pushNamed(context, page['route']);
                    })),
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
