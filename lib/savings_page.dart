import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  DateTime date = DateTime.now();
  final amountcontroller = TextEditingController();
  final _user = Hive.box('user');
  // ignore: prefer_typing_uninitialized_variables
  var userNo;
  late int accountbalance;
  late int savingsbalance;
  late int totalout;
  String transactiondate = "";
  bool hasSavings = false;
  double loanlimit = 0;

  @override
  void initState() {
    transactiondate = DateFormat.yMMMEd().format(date);
    getUserphone();
    getuser();
    super.initState();
  }

  void getUserphone() {
    var user = _user.get("USER");
    setState(() {
      userNo = user[0];
    });
  }

  Future<void> getuser() async {
    DocumentSnapshot accountsnapshot = await FirebaseFirestore.instance
        .collection("account_entitty")
        .doc(userNo)
        .get();
    var accountdata = accountsnapshot.data() as Map<String, dynamic>;
    DocumentSnapshot savingssnapshot = await FirebaseFirestore.instance
        .collection("savings_entity")
        .doc(userNo)
        .get();
    var savingsdata = savingssnapshot.data() as Map<String, dynamic>;
    setState(() {
      accountbalance = accountdata['balance'];
      savingsbalance = savingsdata['balance'];
      totalout = accountdata['total_out'];
      if (savingsbalance > 0) {
        hasSavings = true;
      }
      print(accountbalance);
      print(savingsbalance);
      print(totalout);
    });
  }

  Future<void> _transact() async {
    if (accountbalance >= int.parse(amountcontroller.text)) {
      accountbalance = accountbalance - int.parse(amountcontroller.text);
      savingsbalance = savingsbalance + int.parse(amountcontroller.text);
      int total_out = totalout + int.parse(amountcontroller.text);
      loanlimit = savingsbalance * 1.5;
      await FirebaseFirestore.instance
          .collection("account_entitty")
          .doc(userNo)
          .update({
        "balance": accountbalance,
        "total_out":total_out
      });
      await FirebaseFirestore.instance
          .collection("savings_entity")
          .doc(userNo)
          .update({
        "balance": savingsbalance,
      });
      Map<String, dynamic> savingstransaction = {
        "userNo": userNo,
        "date": transactiondate,
        "action": "Deposit",
        'from': 'Main Account',
        "to": 'Savings Account',
        "amount": int.parse(amountcontroller.text)
      };
      Map<String, dynamic> maintransaction = {
        "userNo": userNo,
        "date": transactiondate,
        "action": "Send",
        'from': 'Main Account',
        "to": 'Savings Account',
        "amount": int.parse(amountcontroller.text), 
        
      };
      await FirebaseFirestore.instance
          .collection("transactions_entity")
          .add(savingstransaction);
      await FirebaseFirestore.instance
          .collection("transactions_entity")
          .add(maintransaction);
      await updateloans();
    } else {
      //show alert
    }
  }

  Future<void> updateloans() async {
    if (hasSavings) {
      await FirebaseFirestore.instance
          .collection("loans_entity")
          .doc(userNo)
          .update({
        "balance": loanlimit,
      });
    } else {
      await FirebaseFirestore.instance
          .collection("loans_entity")
          .doc(userNo)
          .set({"balance": loanlimit, "amount to be paid": 0});
    }
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.0,
        style: BorderStyle.solid,
      ),
    );
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('savings_entity')
          .doc(userNo)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Scaffold(
            resizeToAvoidBottomInset:true,
            appBar: AppBar(
              title: const Text('Savings'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text('Savings Balance is : ${snapshot.data?.get('balance')}'),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text(
                              'Target Savings',
                              style: TextStyle(),
                            ),
                            const Text(
                              '0.0',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: amountcontroller,
                              decoration: const InputDecoration(
                                labelText: 'Deposit amount',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 8, 8, 8)),
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(66, 68, 67, 67)),
                                focusedBorder: border,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: _transact,
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromRGBO(103, 58, 183, 1)),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                fixedSize: MaterialStatePropertyAll(
                                  Size(750, 50),
                                ),
                              ),
                              child: const Text('Continue'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}




