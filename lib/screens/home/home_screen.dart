import 'package:flutter/material.dart';
import 'package:selfradio/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  static const List<Widget> pages = <Widget>[
    Text('Home'),
    Text('Music'),
    Text('List'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  AppBar buildAppBar() {
    return AppBar(
        title: const Text('Selfradio'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => {},
        ));
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      // Shifting
      currentIndex: selectedIndex,
      selectedIconTheme: const IconThemeData(color: kPrimaryColor, size: 33),
      unselectedItemColor: kTextColor,
      onTap: onItemTapped,
      enableFeedback: false,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.audiotrack_rounded),
          label: 'Song',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Playlist',
          backgroundColor: Colors.black,
        ),
      ],
    );
  }
}
