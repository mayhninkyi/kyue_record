import 'package:flutter/material.dart';
import 'package:kyue_app/record_screen.dart';
import 'package:kyue_app/style.dart';
import 'package:kyue_app/timer_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: kTextStyleTitle(22),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    (MaterialPageRoute(
                        builder: (context) => const RecordScreen())));
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          itemCount: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return TimerItem(
              index: index,
            );
          },
        ),
      ),
    );
  }
}
