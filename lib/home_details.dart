import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imarika_sacco_mobile_app/global_variables.dart';
import 'package:imarika_sacco_mobile_app/main_services_card.dart';
import 'package:imarika_sacco_mobile_app/menu_options.dart';
import 'package:imarika_sacco_mobile_app/other_services_card.dart';

class HomeDetails extends StatefulWidget {
  HomeDetails({super.key});

  @override
  State<HomeDetails> createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {
  String initialName = '';
  late var userNo;
  String greetings = "";

  final _user = Hive.box("user");

  @override
  void initState() {
    getUserphone();
    generateGreeting();
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
    String name = data['name'];
    var firstname = name.split(" ");
    setState(() {
      initialName = firstname[1];
    });
  }

  Stream<DocumentSnapshot> getAccountEntityStream() {
    return FirebaseFirestore.instance
        .collection("account_entitty")
        .doc(userNo)
        .snapshots();
  }

  void generateGreeting() {
    int hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      setState(() {
        greetings = "Good Morning";
      });
    } else if (hour >= 12 && hour < 17) {
      setState(() {
        greetings = "Good Afternoon";
      });
    } else {
      setState(() {
        greetings = "Good Evening";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: getAccountEntityStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Scaffold(
              resizeToAvoidBottomInset:true,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const MenuOptions();
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu),
                ),
                title: const Text(
                  'Imarika Sacco',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Colors.purple, Colors.deepPurple],
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 231, 230, 233),
                      boxShadow: const [BoxShadow(blurRadius: 0.05)],
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 30.0),
                      ),
                      gradient: const LinearGradient(
                          colors: [Colors.deepPurple, Colors.purple],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(0.5, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.person_2_rounded,
                            size: 128,
                          ),
                        ),
                        Text(
                          "$greetings, $initialName",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Expanded(
                    child: MainServicesCard(),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: ListView.builder(
                      itemCount: otherServices.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final otherService = otherServices[index];
                        return OtherServicesCard(
                          serviceIcon: otherService['serviceIcon'] as IconData,
                          serviceName: otherService['serviceName'] as String,
                          page: otherService['page'] as Widget,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
