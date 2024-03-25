import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PinReset extends StatefulWidget {
  const PinReset({super.key});

  @override
  State<PinReset> createState() => _PinResetState();
}

class _PinResetState extends State<PinReset> {
  final currentpincontroller = TextEditingController();
  final changepincontroller = TextEditingController();
  final confirmpincontroller = TextEditingController();
  final _user = Hive.box('user');
  var userNo;
  String currentpin = '';

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
    });
  }

  Future<void> getuser() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("account_entitty")
        .doc(userNo)
        .get();
    var data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      currentpin = data['pin'];
    });
  }

  void changepin() async {
    if (currentpincontroller.text.toString() == currentpin) {
      if (changepincontroller.text == confirmpincontroller.text) {
        await FirebaseFirestore.instance
            .collection("account_entitty")
            .doc(userNo)
            .update({'pin': confirmpincontroller.text.trim()});
      }
    } else {
      showDialog(
        context: context,
        builder: ((context) {
          return const AlertDialog(
            title: Text('Pin unmatched'),
          );
        }),
      );
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
        appBar: AppBar(
          title: const Text('Change Pin'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: currentpincontroller,
                decoration: const InputDecoration(
                  hintText: 'Enter Your Current Pin',
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  focusedBorder: border,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: changepincontroller,
                decoration: const InputDecoration(
                  hintText: 'Enter Your New Pin',
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  focusedBorder: border,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: confirmpincontroller,
                decoration: const InputDecoration(
                  hintText: 'Confirm Your New Pin',
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  focusedBorder: border,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: changepin,
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.deepPurple),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  fixedSize: MaterialStatePropertyAll(
                    Size(150, 50),
                  ),
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
        ));
  }
}
