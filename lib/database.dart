import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kyue_app/record.dart';

import 'style.dart';

class Database {
  final db = FirebaseFirestore.instance;
  List<Record> caches = [];

  Database._();

  Future<List<Record>> fetchCache() async {
    caches = [];
    try {
      final snapshot = await db.collection('cache').get();
      if (snapshot.docs.isNotEmpty) {
        for (var val in snapshot.docs) {
          caches.add(Record.fromJSON(val.data()));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return caches;
  }

  Future<void> addRecord(Record record) async {
    String docId = formatDate(record.startDate ?? DateTime.now());
    try {
      final snapshot = await db.collection('record').doc(docId).get();
      int total = 0;
      if (snapshot.exists) {
        total = snapshot.data()!['total'];
      }
      await db
          .collection('record')
          .doc(docId)
          .set({'total': total + (record.total ?? 0)});
      await db
          .collection('record')
          .doc(docId)
          .collection('records')
          .add(record.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateCache(Record record) async {
    String docId = record.tableName ?? '';
    try {
      await db.collection('cache').doc(docId).set(record.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteCache(String docId) async {
    try {
      await db.collection('cache').doc(docId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

Database database = Database._();
