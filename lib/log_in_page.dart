import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imarika_sacco_mobile_app/home_page.dart';
import 'package:imarika_sacco_mobile_app/log_database.dart';
import 'package:imarika_sacco_mobile_app/splash_screen_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  List<String> userPhones = [];
  LogDatabase dbuser = LogDatabase();
  SplashScreenPage sp = SplashScreenPage();
  late String pin;

  //controllers
  final phonecontroller = TextEditingController();
  final pincontroller = TextEditingController();

  @override
  void initState() {
    userPhoness().then((ids) {
      setState(() {
        userPhones = ids;
      });
    });
    super.initState();
  }

  Future<List<String>> userPhoness() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('account_entitty').get();

    for (var doc in snapshot.docs) {
      userPhones.add(doc.id);
    }
    return userPhones;
  }

  void _login() async {
    for (var id in userPhones) {
      if (phonecontroller.text.trim() == id) {
        await getUser();
        if (pincontroller.text.trim() == pin) {
          print("User exists! ");

          dbuser.user.add(phonecontroller.text.trim());
          dbuser.updateData();

          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const HomePage();
              },
            ),
          );

          // SplashScreenPage
        }else{
          //alert wrong pin
        }
      }else{
        //alert phoe number wrong
      }
    }
  }

  Future<void> getUser() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("account_entitty")
        .doc(phonecontroller.text.trim())
        .get();
    var data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      pin = data['pin'];
    });
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.0,
        style: BorderStyle.solid,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
                child: Column(
                  children: [
                    // const Spacer(flex: 1),
                    Image.asset(
                      'assets/images/app-logo.png',
                      height: 50,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/images/log-in.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: phonecontroller,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
                        hintText: '1234',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(66, 68, 67, 67)),
                        focusedBorder: border,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: pincontroller,
                      decoration: const InputDecoration(
                        labelText: 'Enter pin',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
                        hintText: '1234',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(66, 68, 67, 67)),
                        focusedBorder: border,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(103, 58, 183, 1)),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        fixedSize: MaterialStatePropertyAll(
                          Size(750, 50),
                        ),
                      ),
                      child: const Text('Login'),
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
}
