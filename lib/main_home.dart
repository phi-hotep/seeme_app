import 'package:flutter/material.dart';
import 'package:seeme_app/screens/ads.dart';
import 'package:seeme_app/screens/ambassador.dart';
import 'package:seeme_app/screens/home.dart';
import 'package:seeme_app/screens/shop.dart';
import 'package:provider/provider.dart';
import 'state/state.dart';
import 'components/components.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late double xOffset = 230;
  late double yOffset = 150;
  late double scaleFactor = 0.6;
  late bool isDrawerOpen;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  // Methode permettant d'ouvrir le menu
  void openDrawer() {
    setState(() {
      xOffset = 250;
      yOffset = 150;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

// Methode permettant de fermer le menu
  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  static List<Widget> pages = <Widget>[
    Home(),
    const Shop(),
    const Adverts(),
    const Ambassador(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TabManager>(builder: (context, tabManager, child) {
      return Stack(
        children: [
          buildDrawer(),
          buildPage(tabManager, context),
        ],
      );
    });
  }

  Widget buildPage(TabManager tabManager, BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
              child: Container(
                child: SafeArea(
                  child: Scaffold(
                    body: IndexedStack(
                      index: tabManager.selectedTab,
                      children: [
                        Home(
                          drawerOpen: openDrawer,
                          isDrawerOpen: isDrawerOpen,
                        ),
                        const Shop(),
                        const Adverts(),
                        const Ambassador(),
                      ],
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      currentIndex: tabManager.selectedTab,
                      onTap: (index) {
                        tabManager.goToTab(index);
                      },
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      selectedItemColor:
                          Theme.of(context).textSelectionTheme.selectionColor,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.store), label: 'Shop'),
                        BottomNavigationBarItem(
                            icon: Icon(
                              Icons.campaign,
                              size: 30,
                            ),
                            label: 'Ads'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.group), label: 'Ambassador'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return const SafeArea(child: DrawerWidget());
  }
}
