import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransferCashPage extends StatefulWidget {
  TransferCashPage({super.key});

  @override
  State<TransferCashPage> createState() => _TransferCashPageState();
}

class _TransferCashPageState extends State<TransferCashPage> {
  final _user = Hive.box('user');
  // ignore: prefer_typing_uninitialized_variables
  var userNo;
  late int accountbalance;
  late int recieverbalance;
  final recievernumber = TextEditingController();
  final amountcontroller = TextEditingController();
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    getUserphone();
    getuser();
    getUsers();
    super.initState();
  }

  void getUserphone() {
    var user = _user.get("USER");
    setState(() {
      userNo = user[0];
    });
  }

  // alerts
  void alert(IconData icon, Color color, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            icon,
            color: color,
            size: 40,
          ),
          content: Text(
            text,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  //to get the sender account balance
  Future<void> getuser() async {
    DocumentSnapshot accountsnapshot = await FirebaseFirestore.instance
        .collection("account_entitty")
        .doc(userNo)
        .get();
    var accountdata = accountsnapshot.data() as Map<String, dynamic>;
    setState(() {
      accountbalance = accountdata['balance'];
      print(accountbalance);
    });
  }

  //to get the reciever balance
  Future<void> getReciever(var reciever) async {
    DocumentSnapshot accountsnapshot = await FirebaseFirestore.instance
        .collection("account_entitty")
        .doc(reciever)
        .get();
    var accountdata = accountsnapshot.data() as Map<String, dynamic>;
    setState(() {
      recieverbalance = accountdata['balance'];
      print(recieverbalance);
    });
  }

  //to get all system users and update them into a list for searching
  Future<List> getUsers() async {
    CollectionReference allUsers =
        FirebaseFirestore.instance.collection("account_entitty");
    QuerySnapshot snapshots = await allUsers.get();
    for (var doc in snapshots.docs) {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      userData['id'] = doc.id;
      users.add(userData);
    }
    return users;
  }

  Future<void> sendMoney() async {
    int amount = int.parse(amountcontroller.text);
    if (amount < accountbalance) {
      int senderBalance = accountbalance - amount;
      int reciever = recieverbalance + amount;
      print(senderBalance);
      print(reciever);

      await FirebaseFirestore.instance.collection("account_entitty").doc(userNo).update({"balance":senderBalance});
      await FirebaseFirestore.instance.collection("account_entitty").doc(recievernumber.text).update({"balance":reciever});
      alert(Icons.check, Colors.green, "Transfer succesfull");
    } else {
      alert(Icons.close, Colors.red, "No enough money in your account");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("account_entitty")
          .doc(userNo)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Transfar Cash"),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text("Balance: ${snapshot.data?.get('balance')}"),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownSearch<Map<String, dynamic>>(
                            items: users,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        hintText: "Recipient name",
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w300))),
                            popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                        hintText: "Type here to search"))),
                            itemAsString: (user) => user['name'],
                            onChanged: (value) {
                              setState(() {
                                recievernumber.text = value?['id'];
                                getReciever(value?['id']);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            controller: recievernumber,
                            decoration: const InputDecoration(
                              hintText: 'Recipient Mobile Number',
                              hintStyle: TextStyle(
                                color: Colors.black26,
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                              controller: amountcontroller,
                              decoration: const InputDecoration(
                                hintText: 'Amount',
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                              ),
                              keyboardType: TextInputType.number),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: sendMoney,
                            style: const ButtonStyle(
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.deepPurple),
                              fixedSize: MaterialStatePropertyAll(
                                Size(150, 50),
                              ),
                            ),
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
