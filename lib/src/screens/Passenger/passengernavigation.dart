
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vacpass_app/src/screens/Services/firebaseservice.dart';
import '../Verifier/verifierSettings.dart';
import 'dashboardpassenger.dart';
import 'profilepassenger.dart';
import 'historypassenger.dart';

class Passenger extends StatefulWidget {
  @override
  _PassScreen createState() => _PassScreen();
}

class _PassScreen extends State<Passenger> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    HistoryPassenger(),
    Profile(),
    Settings(),
  ];

  @override 
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: DatabaseService().onWillPop,
      child: Scaffold(
          body: Scaffold(
              body: Container(
                  child:_widgetOptions.elementAt(_selectedIndex),)
          ),
          bottomNavigationBar: 
                    BottomNavigationBar(
                      unselectedItemColor: Colors.grey,
                      selectedItemColor: Colors.pinkAccent,
                      backgroundColor: Colors.white,
                      
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.dashboard),
                          label: 'Dashboard',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.history),
                          label: 'Scan History',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: 'Profile',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.settings),
                          label: 'Setting',
                        ),
                      ],
                      currentIndex:  _selectedIndex,
                      onTap: (index){
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
        ),
    );
  }
}