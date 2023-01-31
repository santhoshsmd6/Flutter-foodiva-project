import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../Login_module/LoginScreen.dart';
import '../Payment/data_class.dart';
import '../src/screens/Home.dart';
import 'package:mr_food1/Screens/customer/ProfileScreen.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBar createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late var context;
  void initstate() {
    print("bottom nav bar void init state");
  }

  static List<Widget> _widgetOptions = <Widget>[
    Text('two', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    Home(),
    Text('Home Page',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    Consumer<DataClass>(builder: (context, data, child) {
      data.getLoginRes;
      return (data.getLoginRes.length != 0)
          ? UserProfile(Deviceid: "", LoginRespnce: {})
          : LoginScreen();
    })
  ];

  // String name = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    context = context;
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                activeIcon: Image(
                  image: AssetImage('assets/images/Frame 287.png'),
                  height: 30,
                ),
                icon: Image(
                  image: AssetImage('assets/images/Frame 288.png'),
                  height: 30,
                ),
                label: ('Foodiva'),
              ),
              BottomNavigationBarItem(
                activeIcon: Image(
                  image: AssetImage('assets/images/food.png'),
                  height: 30,
                ),
                icon: Image(
                  image: AssetImage('assets/images/food5.png'),
                  height: 30,
                ),
                label: ('Menus'),
              ),
              BottomNavigationBarItem(
                activeIcon: Image(
                  image: AssetImage('assets/images/Frame 287.png'),
                  height: 30,
                ),
                icon: Image(
                  image: AssetImage('assets/images/Frame 288.png'),
                  height: 30,
                ),
                label: ('History'),
                //backgroundColor: Colors.yellow
              ),
              BottomNavigationBarItem(
                activeIcon: Image(
                  image: AssetImage('assets/images/profile.png'),
                  height: 30,
                ),
                icon: Image(
                  image: AssetImage('assets/images/profile4.png'),
                  height: 30,
                ),
                label: ('Profile'),
                //backgroundColor: Colors.blue,
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            //backgroundColor: Colors.red,
            unselectedItemColor: Colors.black,
            iconSize: 30,
            onTap: _onItemTapped,
            elevation: 5));
  }
}
