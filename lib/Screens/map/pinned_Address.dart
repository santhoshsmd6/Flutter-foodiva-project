import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appData.dart';

class PinnedAddress extends StatefulWidget {
  const PinnedAddress({Key? key}) : super(key: key);

  @override
  State<PinnedAddress> createState() => _PinnedAddressState();
}

class _PinnedAddressState extends State<PinnedAddress>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    String originAddress;
    if (appData.pinnedLocationOnMap != null) {
      originAddress = appData.pinnedLocationOnMap!.placeName.toString();
    } else {
      originAddress = 'Select Address';
    }

    return Text(
      originAddress,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class PinnedAddressContainer extends StatelessWidget {
  final Widget child;
  PinnedAddressContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
              color: Colors.black, width: 1, style: BorderStyle.solid)),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          // const Icon(
          //   Icons.my_location,
          //   color: Colors.blue,
          // ),
          // const SizedBox(
          //   width: 10,
          // ),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}

class PinIcon extends StatelessWidget {
  const PinIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // child:
      // Visibility(
      // visible: isPinMarkerVisible,
      child: Image(
        image: AssetImage('assets/images/PinLogo.png'),
        height: 50,
        // width: 40,
        alignment: Alignment.center,
        frameBuilder: (context, child, fame, wasSynchronouslyLoaded) {
          return Transform.translate(
            offset: Offset(0, -15),
            child: child,
          );
        },
        // )
      ),
    );
  }
}
