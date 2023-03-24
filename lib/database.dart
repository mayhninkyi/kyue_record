import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kyue_app/product.dart';
import 'package:kyue_app/record.dart';

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
    String docId =
        '${record.startDate!.year}-${record.startDate!.month}-${record.startDate!.day}';
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
}

Database database = Database._();
