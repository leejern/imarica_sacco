// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FullStatementPage extends StatefulWidget {
  var userNo;
  FullStatementPage({super.key, required this.userNo});

  @override
  State<FullStatementPage> createState() => _FullStatementPageState();
}

class _FullStatementPageState extends State<FullStatementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("All Transactions"),
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('transactions_entity')
              .where('userNo', isEqualTo: widget.userNo)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {              
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var transaction = snapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                      tileColor: const Color.fromARGB(31, 97, 97, 97), 
                      isThreeLine: true,
                      title: Text("${transaction['date']}"),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Amount: ${transaction['amount']} "),
                          Text("From: ${transaction['from']}"),
                          Text("To: ${transaction['to']}"),
                        ],
                      ),
                      
                    ),
                  );
                });
            }
            return const Center(child: Text("Loading..."));
          },
        ),
      ),
    );
  }
}
