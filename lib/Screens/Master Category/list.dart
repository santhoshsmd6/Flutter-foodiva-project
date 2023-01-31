import 'package:flutter/material.dart';
import 'button.dart';

class foodMenulist {
  final String name;
  final String image;

  foodMenulist({required this.name, required this.image});
}

List<foodMenulist> menulist = [
  foodMenulist(image: "NV1.png", name: "Chicken Butter Masala"),
  foodMenulist(image: "NV2.png", name: "Bread Omlet"),
  foodMenulist(image: "NV3.png", name: "Mutton Chukka"),
  foodMenulist(image: "NV4.png", name: "Chicken Kabab"),
  foodMenulist(image: "NV5.png", name: "Brocoli Rice")
];

class list extends StatefulWidget {
  // bool isAdded = false;

  @override
  State<list> createState() => _listState();
}

class _listState extends State<list> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: menulist.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.220,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            )),
                        width: 100,
                        child: Image.asset(
                          'assets/images/${menulist[index].image}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 36,
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.red)),
                            child: Text(
                              "${menulist[index].name}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Container(
                            height: 36,
                            width: 150,
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.red)),
                            child: Row(
                              children: [
                                Container(
                                  height: 36,
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.red)),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    height: 36,
                                    alignment: Alignment.center,
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(color: Colors.red)),
                                    child: Text(
                                      '4.5',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 5),
                                  child: Container(
                                    height: 36,
                                    alignment: Alignment.topRight,
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(color: Colors.red)),
                                    child: Text(
                                      '45Min',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 36,
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.red)),
                            child: Text(
                              '\u{20B9} 300',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            //height: 36,
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.red)),
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              // width: 220,
                              // width: MediaQuery.of(context).size.width * 0.001,
                              child: CounterScreen(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
