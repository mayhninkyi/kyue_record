import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kyue_app/product.dart';
import 'package:kyue_app/record.dart';

import 'style.dart';

class Database {
  final db = FirebaseFirestore.instance;
  List<Product> products = [];

  Database._();

  init() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      var snapshot = await db.collection('product').get();
      if (snapshot.docs.isNotEmpty) {
        for (var val in snapshot.docs) {
          products.add(Product.fromJSON(val.data()));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addRecord(Record record) async {
    String docId = formatDate(record.startDate ?? DateTime.now());
    try {
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
