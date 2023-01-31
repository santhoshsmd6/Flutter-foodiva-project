import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data_class.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: [
        Consumer<DataClass>(builder: (context, data, child) {
          return (data.selectedItem != null)
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child:
                      // print(data.selectedItem);
                      // print('<<<<<---------------${data.selectedItem['0']}');

                      ListView.builder(
                          itemCount: data.selectedItem.length,
                          itemBuilder: (_, index) {
                            return Row(
                                children: [Text('${data.selectedItem['0']}')]);
                          })
                  // Text('data.selectedItem[0]');
                  // data.selectedItem != {}
                  //   ? ListView.builder(
                  //       itemCount: data.selectedItem.length,
                  //       itemBuilder: (_, index) {
                  //         return Padding(
                  //           padding: const EdgeInsets.only(top: 20),
                  //           child: Row(
                  //             mainAxisAlignment:
                  //                 MainAxisAlignment.spaceEvenly,
                  //             children: [
                  //               const SizedBox(
                  //                 width: 20,
                  //                 child: Image(
                  //                   image:
                  //                       AssetImage('assets/images/img.png'),
                  //                   // fit: BoxFit.contain,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 '${data.selectedItem['0']}',
                  //                 style: TextStyle(
                  //                   fontSize: 15,
                  //                   fontWeight: FontWeight.w400,
                  //                 ),
                  //               ),
                  //               GestureDetector(
                  //                 onTap: () {
                  //                   setState(() {
                  //                     Provider.of<DataClass>(context,
                  //                             listen: false)
                  //                         .decrementX(widget.productValue,
                  //                             widget.productId);
                  //                   });
                  //                 },
                  //                 child: const Icon(
                  //                   Icons.remove,
                  //                   color: Colors.black,
                  //                 ),
                  //               ),
                  //               // Consumer<DataClass>(
                  //               //     builder: (context, data, child) {
                  //               //   return Text(
                  //               //     '${data.count[widget.productId]}',
                  //               //     style: const TextStyle(
                  //               //       fontSize: 20,
                  //               //       fontWeight: FontWeight.bold,
                  //               //       color: Colors.green,
                  //               //     ),
                  //               //   );
                  //               // }),
                  //               GestureDetector(
                  //                 onTap: () {
                  //                   setState(() {
                  //                     context.read<DataClass>().incrementX(
                  //                         widget.productValue,
                  //                         widget.productId);
                  //                   });
                  //                 },
                  //                 child: const Icon(
                  //                   Icons.add,
                  //                   color: Colors.green,
                  //                 ),
                  //               ),
                  //               Consumer<DataClass>(
                  //                   builder: (context, data, child) {
                  //                 print(data.count[widget.productId]);
                  //                 print(data.price);
                  //                 return Text(
                  //                   '${data.price * data.count[widget.productId]}',
                  //                   style: const TextStyle(
                  //                       fontSize: 15,
                  //                       fontWeight: FontWeight.w500),
                  //                 );
                  //               }),
                  //             ],
                  //           ),
                  //         );
                  //       })
                  //   : Text("test");
                  )
              : Container();
        })
      ],
    ));
  }
}
