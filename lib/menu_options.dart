import 'package:flutter/material.dart';
import 'package:imarika_sacco_mobile_app/pin_reset.dart';
import 'package:imarika_sacco_mobile_app/log_database.dart';
import 'package:imarika_sacco_mobile_app/log_in_page.dart';

class MenuOptions extends StatefulWidget {
  const MenuOptions({super.key});

  @override
  State<MenuOptions> createState() => _MenuOptionsState();
}

class _MenuOptionsState extends State<MenuOptions> {
  LogDatabase dbuser = LogDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
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
              const Text(
                'ASKA KAUCHI KALUME',
                style: TextStyle(
                  color: Color(0xFF673AB7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('254743983273'),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const PinReset();
                        },
                      ),
                    );
                  },
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      foregroundColor: MaterialStatePropertyAll(Colors.black),
                      fixedSize: MaterialStatePropertyAll(
                        Size(710, 50),
                      )),
                  child: const Text('CHANGE PIN'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    dbuser.deleteData();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const LogInPage();
                        },
                      ),
                    );
                  },
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      foregroundColor: MaterialStatePropertyAll(Colors.black),
                      fixedSize: MaterialStatePropertyAll(
                        Size(710, 50),
                      )),
                  child: const Text('LOGOUT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
