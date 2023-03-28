import 'package:flutter/material.dart';
import 'package:kyue_app/database.dart';
import 'package:kyue_app/record.dart';
import 'package:kyue_app/record_detail.dart';

import 'style.dart';

class RecordListScreen extends StatelessWidget {
  final String docId;
  const RecordListScreen({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Records', style: kTextStyleTitle(22)),
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder(
        stream: database.db
            .collection('record')
            .doc(docId)
            .collection('records')
            .orderBy('endDate', descending: true)
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
            ));
          } else {
            final dataList = snapshot.data;
            return ListView.builder(
                itemCount: dataList?.docs.length,
                itemBuilder: (context, index) {
                  Record record = Record.fromJSON(dataList!.docs[index].data());
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(15)),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RecordDetail(record: record)));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 16,
                          child: Center(
                            child: Text(
                              record.tableName ?? '',
                              style: kTextStyleTitle(14),
                            ),
                          ),
                        ),
                        title: Text(
                          'Table ${(record.tableName ?? '')}',
                          style: kTextStyleTitle(22),
                        ),
                        subtitle: Text(
                          record.total.toString(),
                          style: kTextStyleTitle(18),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                });
          }
        }),
      ),
    );
  }
}
