import 'package:flutter/material.dart';
import 'package:kyue_app/record.dart';

import 'style.dart';

class RecordDetail extends StatelessWidget {
  final Record record;
  const RecordDetail({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table ${record.tableName}', style: kTextStyleTitle(22)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 8.0, left: 15, right: 15),
          child: Row(
            children: [
              Text('Start Time', style: kTextStyleBlackColor(22)),
              const Spacer(),
              Text(formatTime(record.startDate ?? DateTime.now()),
                  style: kTextStyleBlackColor(22)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 15, right: 15),
          child: Row(
            children: [
              Text('End Time', style: kTextStyleBlackColor(22)),
              const Spacer(),
              Text(formatTime(record.endDate ?? DateTime.now()),
                  style: kTextStyleBlackColor(22)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15)),
          child: Column(children: [
            _itemWidget('အအေး', 50, record.drink50Count ?? 0),
            _itemWidget('မီးခြစ်', 20, record.lighterCount ?? 0),
            _itemWidget('ဘီယာ', 70, record.beerCount ?? 0),
            _itemWidget('ရေသန့်', 10, record.waterCount ?? 0),
            _itemWidget('ဆေးလိပ်', 100, record.cigaretteCount ?? 0),
            _itemWidget('ဖဲ', 30, record.pockerCount ?? 0),
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.blueGrey, borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Text('Total', style: kTextStyleTitle(22)),
              const Spacer(),
              Text('${record.total}', style: kTextStyleTitle(22)),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _itemWidget(String title, int price, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          count != 0
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(
                      '$count',
                      style: kTextStyleBlackColor(12),
                    ),
                  ),
                )
              : const SizedBox(
                  width: 30,
                  height: 30,
                ),
          kHorizontalSpace(15),
          Text(title, style: kTextStyleBlackColor(22)),
          const Spacer(),
          Text('${price * count}', style: kTextStyleBlackColor(22)),
        ],
      ),
    );
  }
}
