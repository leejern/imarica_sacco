import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  DateTime date = DateTime.now();
  final _user = Hive.box("user");
  var userNo;
  final amountcontroller = TextEditingController();
  late int balance;
  String transactiondate = "";

  void _confirmpyAlert(String amount) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Send to mpesa',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Text('Are you sure you want to deposit $amount?'),
          actions: [
            TextButton(
              onPressed: () {
                // context.read();
                _transact();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
      // phoneNumbercontroller.text = userNo;
    });
  }

  Future<void> getuser() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("account_entitty")
        .doc(userNo)
        .get();
    var data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      balance = data['balance'];
    });
  }

  Future<void> _transact() async {
    if (balance >= int.parse(amountcontroller.text)) {
      balance = balance + int.parse(amountcontroller.text);
      await FirebaseFirestore.instance
          .collection("account_entitty")
          .doc(userNo)
          .update({
        "balance": balance,
      });
      Map<String, dynamic> transaction = {
        "date": transactiondate,
        "action": "Send",
        'from': userNo,
        // "to": "Mpesa ${phoneNumbercontroller.text}",
        "amount": int.parse(amountcontroller.text)
      };
      await FirebaseFirestore.instance
          .collection("transactions_entity")
          .add(transaction);
    } else {
      //show alert
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        title: const Text('Back'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Deposit from M-PESA',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: amountcontroller,
                decoration: const InputDecoration(
                  hintText: 'Enter Amount',
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter M-PESA pin',
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: false,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (amountcontroller.text.isNotEmpty) {
                      _confirmpyAlert(amountcontroller.text);
                    }
                  },
                  style: const ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(
                        (Colors.white),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepPurple),
                      fixedSize: MaterialStatePropertyAll(Size(150, 50))),
                  child: const Text('OK'))
            ],
          ),
        ),
      ),
    );
  }
}
