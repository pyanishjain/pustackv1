import 'dart:convert';
// import 'dart:html';
// import 'package:crypto/crypto.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pustackv1/services/database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

import 'package:http/http.dart' as http;

class SubcriptionPage extends StatefulWidget {
  @override
  _SubcriptionPageState createState() => _SubcriptionPageState();
}

class _SubcriptionPageState extends State<SubcriptionPage> {
  Razorpay razorpay;
  TextEditingController textEditingController = new TextEditingController();
  DatabaseMethods _databaseMethods = DatabaseMethods();

  String subscriptionId = "asddfd";

  @override
  void initState() {
    super.initState();

    print("razorpay init");
    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout(int amount, String subscriptionId) {
    var options = {
      "key": "rzp_test_F7CpiOwZhVekGi",
      "subscription_id": subscriptionId,
      "amount": num.parse(amount.toString()) * 100,
      "name": "The Payment",
      "description": "Payment for the Pustack",
      "prefill": {"contact": "7999709798", "email": "helloanishjain@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void subscription99() async {
    await http.post("https://api.razorpay.com/v1/subscriptions/", headers: {
      "Authorization":
          "Basic cnpwX3Rlc3RfRjdDcGlPd1poVmVrR2k6SjJ3TTRHRHZRejlJNW5KeGY3TmRueXFT"
    }, body: {
      "plan_id": "plan_FYtq3NtzoM0fMm",
      "total_count": "1"
    }).then((value) {
      print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);

      print(jsonData['id']);
      subscriptionId = jsonData['id'];

      // print(jsonData);
      // jsonData["photos"].forEach((element) {
      //   //print(element);
      //   // PhotosModel photosModel = new PhotosModel();
      //   // photosModel = PhotosModel.fromMap(element);
      //   // photos.add(photosModel);
      // });

      setState(() {});
    });

    openCheckout(99, subscriptionId);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Pament success ${response.paymentId} ");
    print("Pament success ${response.orderId} ");
    print("Pament success  signature ${response.signature} ");

    Map<String, dynamic> paymentMap = {
      "subscriptionId": subscriptionId,
      "paymentId": response.paymentId,
      "signature": response.signature,
      "status": "success",
    };

    print(paymentMap);

    _databaseMethods.addPaymentsInfo(paymentMap);

    // var authPayment = sha256( + "|" + response.paymentId, secret)

    Toast.show("Pament success", context);

    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => SuccessPage()));
  }

  void _handlerErrorFailure(PaymentFailureResponse response) {
    print("Pament error $response");
    Toast.show("Pament error", context);

    Map<String, dynamic> paymentMap = {
      "subscriptionId": subscriptionId,
      "status": "fail",
    };

    print(paymentMap);

    _databaseMethods.addPaymentsInfo(paymentMap);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FailedPage()));
  }

  void _handlerExternalWallet(ExternalWalletResponse response) {
    print("External Wallet");
    Toast.show("External Wallet", context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "The",
                style: TextStyle(color: Colors.black87, fontFamily: 'Overpass'),
              ),
              Text(
                "Pay",
                style: TextStyle(color: Colors.blue, fontFamily: 'Overpass'),
              )
            ],
          )),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black12, Colors.black87])),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(hintText: "amount to pay"),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: RaisedButton(
                  color: Colors.white,
                  child: Text(
                    "One Time Rs.99",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    // openCheckout(99);
                    subscription99();
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: RaisedButton(
                  color: Colors.white,
                  child: Text(
                    "Subscription Rs. 49 per month.",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    // openCheckout(49);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FailedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Failed"),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Succes"),
      ),
    );
  }
}
