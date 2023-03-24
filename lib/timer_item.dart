import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kyue_app/database.dart';
import 'package:kyue_app/product.dart';
import 'package:kyue_app/record.dart';
import 'package:kyue_app/style.dart';

class TimerItem extends StatefulWidget {
  final int index;
  const TimerItem({super.key, required this.index});

  @override
  State<TimerItem> createState() => _TimerItemState();
}

class _TimerItemState extends State<TimerItem> {
  Timer? countdownTimer;
  DateTime? startTime;
  String timer = '00 : 00 : 00';
  List<Product> products = [];
  int total = 0;
  Record record = Record();

  @override
  void initState() {
    products = database.products;
    super.initState();
  }

  void startTimer() {
    startTime = DateTime.now();
    record.startDate = startTime;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (value) {
      var now = DateTime.now();
      var difference = now.difference(startTime ?? DateTime.now());
      setState(() {
        timer =
            '${(difference.inHours % 24).toString().padLeft(2, '0')} : ${(difference.inMinutes % 60).toString().padLeft(2, '0')} : ${(difference.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
  }

  void stopTimer() {
    countdownTimer!.cancel();
    record.endDate = DateTime.now();
    record.tableName = (widget.index + 1).toString();
    database.addRecord(record);
    setState(() {
      timer = '00 : 00 : 00';
      total = 0;
    });
    record = Record();
    Navigator.pop(context);
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Table ${widget.index + 1}',
            style: kTextStyleTitle(32),
          ),
          const Icon(
            Icons.timer,
            color: Colors.black,
            size: 50,
          ),
          Text(
            timer,
            style: kTextStyleTitle(32),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
              onPressed: () {
                if (timer == '00 : 00 : 00') {
                  startTimer();
                } else {
                  showDetail();
                }
              },
              child: Text(
                timer == '00 : 00 : 00' ? 'START' : 'DETAIL',
                style: kTextStyleTitle(22),
              ))
        ],
      ),
    );
  }

  update() {
    total = 0;
    for (var val in products) {
      switch (val.name) {
        case 'Drink100':
          record.drink100Count = val.count;
          break;
        case 'Pocker':
          record.pockerCount = val.count;
          break;
        case 'Beer':
          record.beerCount = val.count;
          break;
        case 'Water':
          record.waterCount = val.count;
          break;
        case 'Cigerette':
          record.cigaretteCount = val.count;
          break;
        case 'Drink50':
          record.drink50Count = val.count;
          break;
      }
      total += val.price * val.count;
    }
    record.total = total;
  }

  showDetail() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.blueGrey,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
              child: Wrap(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Text(
                                  '${product.name} (${product.price})',
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
                                      if (product.count != 0) {
                                        setState(() {
                                          products[index].count--;
                                          update();
                                        });
                                      }
                                    },
                                  ),
                                ),
                                kHorizontalSpace(8),
                                Text(
                                  '${products[index].count}',
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
                                      setState(() {
                                        products[index].count++;
                                        update();
                                      });
                                    },
                                  ),
                                ),
                                kHorizontalSpace(12),
                                Text(
                                  ((products[index].count) *
                                          (products[index].price))
                                      .toString(),
                                  style: kTextStyleTitle(25),
                                ),
                                kHorizontalSpace(12),
                              ],
                            ));
                      }),
                  const Divider(
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      kHorizontalSpace(12),
                      Text(
                        'Total',
                        style: kTextStyleTitle(30),
                      ),
                      const Spacer(),
                      Text(
                        '$total',
                        style: kTextStyleTitle(30),
                      ),
                      kHorizontalSpace(12),
                    ],
                  ),
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
