import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  addPaymentsInfo(paymentMap) {
    Firestore.instance.collection("payments").add(paymentMap).catchError((e) {
      print("ERROR! IS $e");
    });
  }
}
