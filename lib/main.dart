import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ui/screens/home_screen.dart';
import 'ui/screens/map_screen.dart';
import 'ui/screens/mylist_screen.dart';
import 'ui/screens/search_screen.dart';
import 'ui/screens/voice_search_screen.dart';

void main() async {
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.deepOrange,
        primarySwatch: Colors.deepOrange,
        hintColor: Colors.white,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Gilroy',
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      home: MyAppContainer(),
    );
  }
}

class MyAppContainer extends StatefulWidget {
  MyAppContainer({Key key}) : super(key: key);

  @override
  _MyAppContainerState createState() => _MyAppContainerState();
}

class _MyAppContainerState extends State<MyAppContainer> {
  bool _initialized = false;
  bool _error = false;
  int _selectedIndex = 0;
  List<String> appBarTitles = [
    'Home',
    'Search',
    'My List',
    'Map',
    'Voice Search'
  ];

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
        print('initialization error:' + e.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Text('Something went wrong'),
      );
    }

    if (!_initialized) {
      return CircularProgressIndicator();
    }
    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            SafeArea(child: HomeScreen()),
            SafeArea(child: SearchScreen()),
            SafeArea(child: MyListScreen()),
            SafeArea(child: MapScreen()),
            SafeArea(child: VoiceSearchScreen()),
          ],
        ),
        bottomNavigationBar: bottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xff2c3136),
      unselectedItemColor: Color(0xff535c65),
      selectedItemColor: Color(0xfffb531a),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _selectedIndex,
      onTap: (index) {
        if (index != _selectedIndex) {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.solidHeart),
          label: 'My List',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.mapMarker),
          label: 'Location',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.microphoneAlt),
          label: 'Mic',
        ),
      ],
    );
  }
}
