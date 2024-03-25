import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imarika_sacco_mobile_app/full_statement_page.dart';
import 'package:imarika_sacco_mobile_app/money_in.dart';
import 'package:imarika_sacco_mobile_app/money_out_page.dart';
import 'package:imarika_sacco_mobile_app/recent_transactions.dart';

class StatementsPage extends StatefulWidget {
  const StatementsPage({super.key});

  @override
  State<StatementsPage> createState() => _StatementsPageState();
}

class _StatementsPageState extends State<StatementsPage> {

  final _user = Hive.box('user');
  // ignore: prefer_typing_uninitialized_variables
  var userNo;

  @override
  void initState() {
    // transactiondate = DateFormat.yMMMEd().format(date);
    getUserphone();
    super.initState();
  }

  void getUserphone() {
    var user = _user.get("USER");
    setState(() {
      userNo = user[0];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Statements',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Column(
                // mainAxisSize: MainAxisSize.min, 
                children: [ 
                  Card(
                    child: ListTile( 
                      leading: const Icon(Icons.money, size: 30,),
                      title: const Text("Recent Transactions", style:TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return RecentTransactions(userNo: userNo,);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile( 
                      leading: const Icon(Icons.money, size: 30,),
                      title: const Text("Money in", style:TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: (){ 
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return MoneyIn(userNo: userNo);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile( 
                      leading: const Icon(Icons.money, size: 30,),
                      title: const Text("Money out", style:TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: (){ 
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return MoneyOut(userNo: userNo,);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile( 
                      leading: const Icon(Icons.money, size: 30,),
                      title: const Text("Full Statement", style:TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: (){ 
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return FullStatementPage(userNo: userNo,);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}


// class RecentTransactions extends StatefulWidget {
//   const RecentTransactions({super.key});

//   @override
//   State<RecentTransactions> createState() => _RecentTransactionsState();
// }

// class _RecentTransactionsState extends State<RecentTransactions> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }