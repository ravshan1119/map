import 'package:flutter/material.dart';
import 'package:map/providers/tab_box_provider.dart';
import 'package:map/ui/map/map_screen.dart';
import 'package:map/ui/user_locations/user_locations.dart';
import 'package:provider/provider.dart';

class TabBox extends StatefulWidget {
  const TabBox({super.key});

  @override
  State<TabBox> createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  List<Widget> screens = [];

  @override
  void initState() {
    screens.add(const MapScreen());
    screens.add(const UserLocationsScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<TabBoxProvider>().activeIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          context.read<TabBoxProvider>().changeIndex(index);
        },
        currentIndex: context.read<TabBoxProvider>().activeIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_pin), label: "User Addresses"),
        ],
      ),
    );
  }
}
