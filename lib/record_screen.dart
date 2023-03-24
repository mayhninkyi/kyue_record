import 'package:flutter/material.dart';
import 'package:kyue_app/database.dart';
import 'package:kyue_app/style.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Records', style: kTextStyleTitle(22)),
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder(
        stream: database.db.collection('record').snapshots(),
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
                  return Container(
                    padding: const EdgeInsets.all(15),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(
                        dataList!.docs[index].id,
                        style: kTextStyleTitle(22),
                      ),
                      
                    ]),
                  );
                });
          }
        }),
      ),
    );
  }
}
