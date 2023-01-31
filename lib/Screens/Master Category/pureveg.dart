import 'package:flutter/material.dart';
import 'package:mr_food1/Screens/Master Category/FirstScreen.dart';
import 'package:mr_food1/Screens/Master Category/list.dart';


class pureveg extends StatefulWidget {
  const pureveg({Key? key}) : super(key: key);

  @override
  State<pureveg> createState() => _purevegState();
}

class _purevegState extends State<pureveg> with TickerProviderStateMixin {

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                    onPressed: () => {Navigator.pop(context)},
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Back',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.bold),
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: (BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            child: const Image(
                              image: AssetImage('assets/images/search.png'),
                              fit: BoxFit.contain,
                              width: 21,
                            ),
                            onTap: () => _controller.clear(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, bottom: 3),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: TextField(
                              controller: _controller,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Outfit-Regular",
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search for foods here',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                indicatorColor: Color(0xFF557B2F),
                tabs: [
                  Tab(
                    child: Text(
                      "Restaurants",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        //color: Colors.green[900],
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Dishes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        //color: Colors.green[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.8,
              child: TabBarView(
                controller: _tabController,
                children: [
                  //FirstScreen(),
                  list(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
