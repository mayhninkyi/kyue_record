import 'package:flutter/material.dart';
import 'package:kyue_app/record.dart';
import 'package:kyue_app/record_screen.dart';
import 'package:kyue_app/style.dart';
import 'package:kyue_app/timer_item.dart';
import 'database.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<Record> data = [];
  ValueNotifier<bool> loading = ValueNotifier(false);

  Future<void> refresh() async {
    loading.value = true;
    List<Record> cache = await database.fetchCache();
    if (cache.isNotEmpty) {
      for (var val in cache) {
        int index = int.parse(val.tableName ?? '1') - 1;
        data[index] = val;
      }
    }
    loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 8; i++) {
      data.add(Record());
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              refresh();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            )),
        title: Text(
          'Home',
          style: kTextStyleTitle(22),
        ),
        centerTitle: true,
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
        child: ValueListenableBuilder(
            valueListenable: loading,
            builder: (context, value, child) {
              return loading.value
                  ? Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                        ),
                      ))
                  : ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TimerItem(
                          index: index,
                          recordData: data[index],
                        );
                      },
                    );
            }),
      ),
    );
  }
}
