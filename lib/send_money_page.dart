import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  DateTime date = DateTime.now();
  final _user = Hive.box("user");
  var userNo;
  final phoneNumbercontroller = TextEditingController();
  final amountcontroller = TextEditingController();
  late int balance;
  late int totalout;
  String transactiondate = "";
  int? test = 1;

  void _confirmpyAlert(String number, String amount) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Send to mpesa',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Text('Are you sure you want to send $amount to $number?'),
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
      phoneNumbercontroller.text = userNo;
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
      totalout = data['total_out'];
    });
  }

  Future<void> _transact() async {
    if (balance >= int.parse(amountcontroller.text)) {
      balance = balance - int.parse(amountcontroller.text);
      int out = totalout + int.parse(amountcontroller.text);
      await FirebaseFirestore.instance
          .collection("account_entitty")
          .doc(userNo)
          .update({"balance": balance, "total_out":out});
      Map<String, dynamic> transaction = {
        "date": transactiondate,
        "action": "Send",
        'from': userNo,
        "to": "Mpesa ${phoneNumbercontroller.text}",
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
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.0,
        style: BorderStyle.none,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset:true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.person,
                  size: 96,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text('SELF'),
                leading: Radio(
                    value: 1,
                    groupValue: test,
                    onChanged: (value) {
                      setState(() {
                        test = value;
                        phoneNumbercontroller.text = userNo;
                      });
                      debugPrint('$test');
                    }),
              ),
              ListTile(
                title: const Text('OTHER'),
                leading: Radio(
                    value: 2,
                    groupValue: test,
                    onChanged: (value) {
                      setState(() {
                        test = value;
                        phoneNumbercontroller.clear();
                      });
                      debugPrint('$test');
                    }),
              ),
              TextField(
                controller: phoneNumbercontroller,
                decoration: const InputDecoration(
                  hintText: 'ENTER NUMBER',
                  hintStyle: TextStyle(color: Colors.black26),
                  focusedBorder: border,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: amountcontroller,
                decoration: const InputDecoration(
                  hintText: 'ENTER AMOUNT',
                  hintStyle: TextStyle(color: Colors.black26),
                  focusedBorder: border,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  if (phoneNumbercontroller.text.isNotEmpty &&
                      amountcontroller.text.isNotEmpty) {
                    _confirmpyAlert(
                        phoneNumbercontroller.text, amountcontroller.text);
                  }
                },
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(Colors.deepPurple),
                  fixedSize: MaterialStatePropertyAll(
                    Size(150, 40),
                  ),
                ),
                child: const Text('Send'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
