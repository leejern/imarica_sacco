// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MoneyIn extends StatefulWidget {
  var userNo;
  MoneyIn({super.key, required this.userNo});

  @override
  State<MoneyIn> createState() => _MoneyInState();
}

class _MoneyInState extends State<MoneyIn> {
  List<Map<String, dynamic>> transactions = [];
  Map<String, dynamic> noData = {
    "date": "No Transactions made",
    
  };
  @override
  void initState() {
    getMoneyIn();
    super.initState();
  }

  Future<void> getMoneyIn() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('transactions_entity')
        .where('userNo', isEqualTo: widget.userNo)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        if (doc['to'] == "Main Account") {
          setState(() {
            transactions.add(doc.data());
          });
        }
        // Access document data
        print(transactions);
      }
    }
    if (transactions.isEmpty) {
      setState(() {
        transactions.add(noData);
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Money in"),
        ),
        body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: const Color.fromARGB(31, 97, 97, 97),
                isThreeLine: true,
                title: Text("${transactions[index]['date']}"),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Amount: ${transactions[index]['amount']} "),
                    Text("From: ${transactions[index]['from']}"),
                    Text("To: ${transactions[index]['to']}"),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
