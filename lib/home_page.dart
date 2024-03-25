import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imarika_sacco_mobile_app/access_permission.dart';
import 'package:imarika_sacco_mobile_app/home_details.dart';
import 'package:imarika_sacco_mobile_app/loans_page.dart';
import 'package:imarika_sacco_mobile_app/log_database.dart';
import 'package:imarika_sacco_mobile_app/savings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late var userNo;
  final _user = Hive.box("user");
  int currentPage = 0;
  LogDatabase dbuser = LogDatabase();
  bool hasSavings = true;

  @override
  void initState() {
    getUser();
    checkSavings();
    super.initState();
  }

  void getUser() {
    var user = _user.get("USER");
    setState(() {
      userNo = user[0];
    });
  }

  Stream<DocumentSnapshot> getAccountEntityStream() {
    return FirebaseFirestore.instance
        .collection("account_entitty")
        .doc(userNo)
        .snapshots();
  }

  Future<void> checkSavings() async {
    DocumentSnapshot savingssnapshot = await FirebaseFirestore.instance
        .collection("savings_entity")
        .doc(userNo)
        .get();
    var savingsdata = savingssnapshot.data() as Map<String, dynamic>;
    if (savingsdata['balance'] == 0) {
      setState(() {
        hasSavings = false;
      });
    }
  }

  List<Widget> pages = [
    HomeDetails(),
    AccessPermission(page: const SavingsPage()),
    AccessPermission(page: const LoansPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.deepPurple,
        backgroundColor: const Color.fromARGB(255, 231, 230, 233),
        onTap: (value) {
          if (value == 2 && !hasSavings) {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  icon: Icon(Icons.error),
                  content: Text(
                      "To access savings, you must have some amount into your savings account"),
                );
              },
            );
          } else {
            setState(() {
              currentPage = value;
            });
          }
        },
        currentIndex: currentPage,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.deepPurple,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.savings,
              color: Colors.deepPurple,
            ),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.payments,
              color: Colors.deepPurple,
            ),
            label: 'Loans',
          ),
        ],
      ),
    );
  }
}
