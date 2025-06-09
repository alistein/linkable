import 'package:linkable/view/shared/empty_boxes.dart';
import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi,
              size: 50,
            ),
            boxHeigth12,
            Text(
              "No internet connection.",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
