import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_ui/widgets/hotel_carousel.dart';

import '../widgets/destination_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  int _currentTab = 0;

  final List<IconData> _icons = [
    FontAwesomeIcons.plane,
    FontAwesomeIcons.bed,
    FontAwesomeIcons.parachuteBox,
    FontAwesomeIcons.personBiking,
  ];

  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        print("Tab Clicked :: $selectedIndex");
        setIndexToPref(selectedIndex);
        getIndexFromPref();
      },
      child: AnimatedContainer(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          color: selectedIndex == index
              ? Theme.of(context).colorScheme.secondary
              : const Color(0xFFE7EBEE),
          borderRadius: BorderRadius.circular(30),
        ),
        duration: const Duration(milliseconds: 250),
        child: Icon(
          _icons[index],
          color: selectedIndex == index
              ? Theme.of(context).primaryColor
              : const Color(0xFFB4C1C4),
          size: 25.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 120.0),
            child: Text(
              "What would you like to find?",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _icons
                  .asMap()
                  .entries
                  .map((map) => _buildIcon(map.key))
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const DestinationCarousel(),
          const SizedBox(
            height: 30,
          ),
          const HotelCarousel()
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.search,
                size: 30,
              ),
              label: ""),
          const BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.pizzaSlice,
                size: 30,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                  backgroundColor: _currentTab == 2
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  radius: 17.0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: _currentTab == 2
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    backgroundImage: const NetworkImage(
                        "https://www.catholicsingles.com/wp-content/uploads/2020/06/blog-header-3.png"),
                  )),
              label: ""),
        ],
      ),
    );
  }

  Future<void> setIndexToPref(int selectedIndex) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt("tab_index", selectedIndex);
    print("index saved $selectedIndex");
  }

  Future<void> getIndexFromPref() async {
    var prefs = await SharedPreferences.getInstance();
    selectedIndex = prefs.getInt("tab_index")!;
    print("index get from pref $selectedIndex");


  }
}


