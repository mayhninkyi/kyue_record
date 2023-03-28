import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kyue_app/database.dart';
import 'package:kyue_app/record.dart';
import 'package:kyue_app/style.dart';

class TimerItem extends StatefulWidget {
  final int index;
  final Record recordData;
  const TimerItem({super.key, required this.index, required this.recordData});

  @override
  State<TimerItem> createState() => _TimerItemState();
}

class _TimerItemState extends State<TimerItem> {
  Timer? countdownTimer;
  DateTime? startTime;
  ValueNotifier<String> timer = ValueNotifier('00 : 00 : 00');
  Record record = Record();
  ValueNotifier<int> total = ValueNotifier(0);
  ValueNotifier<int> timerPrice = ValueNotifier(0);
  ValueNotifier<int> lighterCount = ValueNotifier(0);
  ValueNotifier<int> drink50Count = ValueNotifier(0);
  ValueNotifier<int> beerCount = ValueNotifier(0);
  ValueNotifier<int> waterCount = ValueNotifier(0);
  ValueNotifier<int> cigretteCount = ValueNotifier(0);
  ValueNotifier<int> pockerCount = ValueNotifier(0);
  int tableNo = 0;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initData() {
    tableNo = widget.index + 1;
    record = widget.recordData;
    if (record.startDate != null) {
      drink50Count.value = record.drink50Count ?? 0;
      lighterCount.value = record.lighterCount ?? 0;
      beerCount.value = record.beerCount ?? 0;
      waterCount.value = record.waterCount ?? 0;
      pockerCount.value = record.pockerCount ?? 0;
      cigretteCount.value = record.cigaretteCount ?? 0;
      total.value = (drink50Count.value * 50) +
          (beerCount.value * 70) +
          (cigretteCount.value * 100) +
          (waterCount.value * 10) +
          (pockerCount.value * 30) +
          (lighterCount.value * 20);
      startTimer();
    }
  }

  void startTimer() {
    if (record.startDate != null) {
      startTime = record.startDate;
    } else {
      startTime = DateTime.now();
    }
    record.startDate = startTime;
    record.tableName = tableNo.toString();
    database.updateCache(record);
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (value) {
      var now = DateTime.now();
      var difference = now.difference(startTime ?? DateTime.now());
      timerPrice.value = ((difference.inSeconds / 3600) * 200).round();
      timer.value =
          '${(difference.inHours % 24).toString().padLeft(2, '0')} : ${(difference.inMinutes % 60).toString().padLeft(2, '0')} : ${(difference.inSeconds % 60).toString().padLeft(2, '0')}';
    });
  }

  void stopTimer() {
    countdownTimer!.cancel();
    record.endDate = DateTime.now();
    record.total = total.value + timerPrice.value;
    database.addRecord(record);
    database.deleteCache(record.tableName ?? '');
    clearData();
    Navigator.pop(context);
  }

  clearData() {
    timer.value = '00 : 00 : 00';
    total.value = 0;
    timerPrice.value = 0;
    lighterCount.value = 0;
    drink50Count.value = 0;
    beerCount.value = 0;
    waterCount.value = 0;
    pockerCount.value = 0;
    cigretteCount.value = 0;
    record = Record();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(15),
      width: size.width,
      height: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.blueGrey),
      child: ValueListenableBuilder(
          valueListenable: timer,
          builder: (context, value, widget) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      'Table $tableNo',
                      style: kTextStyleTitle(32),
                    ),
                    const Spacer(),
                    value == '00 : 00 : 00'
                        ? Container()
                        : CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.black,
                            child: IconButton(
                                onPressed: () {
                                  _displayDialog(context);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 12,
                                )))
                  ],
                ),
                (record.note == '' || record.note == null)
                    ? const Icon(
                        Icons.timer,
                        color: Colors.black,
                        size: 50,
                      )
                    : Text(
                        record.note ?? '',
                        maxLines: 2,
                        style: kTextStyleTitle(16),
                      ),
                Text(
                  value,
                  style: kTextStyleTitle(32),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54),
                    onPressed: () {
                      if (value == '00 : 00 : 00') {
                        startTimer();
                      } else {
                        showDetail();
                      }
                    },
                    child: Text(
                      value == '00 : 00 : 00' ? 'START' : 'DETAIL',
                      style: kTextStyleTitle(22),
                    ))
              ],
            );
          }),
    );
  }

  Future<void> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add note....'),
            content: TextField(
              onChanged: (value) {
                record.note = value;
              },
              controller: controller,
              decoration: const InputDecoration(hintText: ""),
            ),
            actions: [
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                    update();
                  },
                  child: Text(
                    'SAVE',
                    style: kTextStyleTitle(22),
                  ))
            ],
          );
        });
  }

  update() {
    record.drink50Count = drink50Count.value;
    record.lighterCount = lighterCount.value;
    record.beerCount = beerCount.value;
    record.waterCount = waterCount.value;
    record.cigaretteCount = cigretteCount.value;
    record.pockerCount = pockerCount.value;
    database.updateCache(record);
  }

  Widget _productItem(ValueNotifier notifierValue, String title, int price) {
    return ValueListenableBuilder(
        valueListenable: notifierValue,
        builder: (context, value, widget) {
          return Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    '$title ($price)',
                    style: kTextStyleTitle(22),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 15,
                      ),
                      onPressed: () {
                        if (value != 0) {
                          notifierValue.value = notifierValue.value - 1;
                          total.value = total.value - price;
                          update();
                        }
                      },
                    ),
                  ),
                  kHorizontalSpace(8),
                  Text(
                    '$value',
                    style: kTextStyleTitle(22),
                  ),
                  kHorizontalSpace(8),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15,
                      ),
                      onPressed: () {
                        notifierValue.value = notifierValue.value + 1;
                        total.value = total.value + price;
                        update();
                      },
                    ),
                  ),
                  kHorizontalSpace(12),
                  Text(
                    (value * price).toString(),
                    style: kTextStyleTitle(25),
                  ),
                  kHorizontalSpace(12),
                ],
              ));
        });
  }

  showDetail() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.blueGrey,
        builder: (context) {
          return ValueListenableBuilder(
              valueListenable: total,
              builder: (context, totalValue, child) {
                return SafeArea(
                  child: Wrap(
                    children: [
                      _productItem(drink50Count, 'အအေး', 50),
                      _productItem(beerCount, 'ဘီယာ', 70),
                      _productItem(cigretteCount, 'ဆေးလိပ် ', 100),
                      _productItem(waterCount, 'ရေသန့်', 10),
                      _productItem(pockerCount, 'ဖဲ ', 30),
                      _productItem(lighterCount, 'မီးခြစ်', 20),
                      const Divider(
                        color: Colors.white,
                      ),
                      ValueListenableBuilder(
                          valueListenable: timerPrice,
                          builder: (context, value, child) {
                            return Row(
                              children: [
                                const Spacer(),
                                Text(
                                  '$value',
                                  style: kTextStyleTitle(30),
                                ),
                                kHorizontalSpace(12),
                              ],
                            );
                          }),
                      ValueListenableBuilder(
                          valueListenable: timerPrice,
                          builder: (context, value, child) {
                            return Row(
                              children: [
                                kHorizontalSpace(12),
                                Text(
                                  'Total',
                                  style: kTextStyleTitle(30),
                                ),
                                const Spacer(),
                                Text(
                                  '${totalValue + value}',
                                  style: kTextStyleTitle(30),
                                ),
                                kHorizontalSpace(12),
                              ],
                            );
                          }),
                      kVerticalSpace(30),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black54),
                            onPressed: () {
                              stopTimer();
                            },
                            child: Text(
                              'CHECKOUT',
                              style: kTextStyleTitle(22),
                            )),
                      ),
                      kVerticalSpace(30),
                    ],
                  ),
                );
              });
        });
  }
}
