import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class RecentTransactions extends StatefulWidget {
  var userNo;
  RecentTransactions({super.key, required this.userNo});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  DateTime now = DateTime.now();
  String currentDate = "";
  List<Map<String, dynamic>> transactions = [];
  Map<String, dynamic> noData = {
    "date": "No Transactions made",
  };
  @override
  void initState() {
    DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));
    String thirtyDaysAgoString = DateFormat.yMMMEd().format(thirtyDaysAgo);
    setState(() {
      currentDate = thirtyDaysAgoString;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    recentTransactions();
    super.didChangeDependencies();
  }

  Future<void> recentTransactions() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('transactions_entity')
        .where('date', isGreaterThanOrEqualTo: currentDate)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        if (doc['userNo'] == widget.userNo) {
          setState(() {
            transactions.add(doc.data());
          });
        }
      }
      print(transactions);
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
          title: const Text("Recent Transactions"),
        ),
        body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: Colors.black12,
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
