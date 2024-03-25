import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class AccessPermission extends StatefulWidget {
  var page;
  AccessPermission({super.key, required this.page});

  @override
  State<AccessPermission> createState() => _AccessPermissionState();
}

class _AccessPermissionState extends State<AccessPermission> {
  TextEditingController controller = TextEditingController();
  String pin = "";
  final _user = Hive.box("user");
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
    });
  }

  Future<void> getuser() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("account_entitty")
        .doc(userNo)
        .get();
    var data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      pin = data['pin'];
    });
  }

  void _login() {
    if (pin == controller.text) {
      //p
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return widget.page;
          },
        ),
      );
    } else {
      ///
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person_2,
                size: 96,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButton('1'),
                buildButton('2'),
                buildButton('3'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButton('4'),
                buildButton('5'),
                buildButton('6'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButton('7'),
                buildButton('8'),
                buildButton('9'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                buildButton('OK', onPressed: _login),
                buildButton('0'),
                buildButton('Del', onPressed: _backspace),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text, {VoidCallback? onPressed}) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed ?? () => _input(text),
        child: Text(text),
      ),
    );
  }

  void _input(String text) {
    final value = controller.text + text;
    controller.text = value;
  }

  void _backspace() {
    final value = controller.text;
    if (value.isNotEmpty) {
      controller.text = value.substring(0, value.length - 1);
    }
  }
}
