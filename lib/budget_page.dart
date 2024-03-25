import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final _user = Hive.box('user');
  int accountbalance = 0;
  int totalout = 0;
  double value = 0;
  double percent = 0;
  var userNo;

  @override
  void initState() {
    getUserphone();
    getuser();
    super.initState();
  }

  void getUserphone() {
    var user = _user.get("USER");
    setState(() {
      userNo = user[0];
      print(userNo);
    });
  }

  Future<void> getuser() async {
    DocumentSnapshot accountsnapshot = await FirebaseFirestore.instance
        .collection("account_entitty")
        .doc(userNo)
        .get();
    var accountdata = accountsnapshot.data() as Map<String, dynamic>;

    setState(() {
      accountbalance = accountdata['balance'];
      totalout = accountdata['total_out'];
      value = totalout / accountbalance;
      percent = double.parse(value.toStringAsFixed(2)) * 100;
      //value = double.parse(value.toStringAsFixed(2));

      print(accountbalance);
      print(totalout);
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Budget"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator( 
                animation: true,               
                radius: 90.0,
                lineWidth: 10.0,
                percent: value,
                center: Text("$percent%",style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                progressColor: Colors.purple,
                circularStrokeCap: CircularStrokeCap.round,
                footer: const Text(
                    "Your total expenditure",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
              ),
              Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                        tileColor: const Color.fromARGB(31, 97, 97, 97), 
                  title: Text(
                    "Account Balance: $accountbalance",
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    "Total Spent: $totalout",
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
