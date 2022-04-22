import 'package:flutter/material.dart';
import 'package:seeme_app/data/data.dart';
import 'package:provider/provider.dart';
import 'package:seeme_app/screens/drawer_screens/settings.dart';
import 'package:seeme_app/state/theme_manager.dart';

import '../models/seeme_pages.dart';

class DrawerWidget extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: SeeMePages.drawer,
      key: ValueKey(SeeMePages.drawer),
      child: const DrawerWidget(),
    );
  }

  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(context),
            const SizedBox(height: 10),
            const Divider(
              indent: 25.0,
              endIndent: 25.0,
              thickness: 1.5,
              color: Colors.green,
            ),
            buildDrawerItems(context),
          ],
        ),
      ),
    );
  }

  Material buildHeader(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Settings(),
            ),
          );
        },
        child: SizedBox(
          height: 200,
          width: 360,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/femme5.jpg'),
                    radius: 70,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Hotep Industries'),
                      Text('Bomokin Hugues '),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 5,
                child: IconButton(
                  onPressed: () {
                    Provider.of<ThemeManager>(context, listen: false)
                        .changeTheme();
                  },
                  icon: Icon(Provider.of<ThemeManager>(context).getTheme
                      ? Icons.sunny
                      : Icons.brightness_2),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context) {
    return Column(
      children: DrawerItemsData.listItems
          .map((item) => ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                leading: item.icon,
                title: Text(item.title!,
                    style: Theme.of(context).textTheme.headline6),
                subtitle: Text(
                  item.subTitle!,
                  style: const TextStyle(
                      fontSize: 12, fontStyle: FontStyle.italic),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => item.drawerPage));
                },
              ))
          .toList(),
    );
  }
}
