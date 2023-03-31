import 'package:flutter/material.dart';
import 'package:kyue_app/database.dart';
import 'package:kyue_app/record_list_screen.dart';
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
        stream: database.db
            .collection('record')
            .orderBy('date', descending: true)
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
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordListScreen(
                                    docId: dataList.docs[index].id)));
                      },
                      child: ListTile(
                        title: Text(
                          dataList!.docs[index].id,
                          style: kTextStyleTitle(22),
                        ),
                        subtitle: Text(
                          '${dataList.docs[index].data()['total']} ',
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
