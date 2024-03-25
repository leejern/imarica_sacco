import 'package:flutter/material.dart';
import 'package:imarika_sacco_mobile_app/enquiries_form.dart';
import 'package:imarika_sacco_mobile_app/enquiries_list.dart';
import 'package:imarika_sacco_mobile_app/global_variables.dart';

class EnquiriesPage extends StatelessWidget {
  const EnquiriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        title: const Text('Back'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Frequently Asked questions',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: enquiries.length,
                scrollDirection: Axis.vertical,
                itemBuilder: ((context, index) {
                  final enquiry = enquiries[index];
                  return EnquiriesList(
                    question: enquiry['question'] as String,
                    answer: enquiry['answer'] as String,
                  );
                }),
              ),
            ),
            InkWell(
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Have any Question? Ask here.',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const EnquiriesForm();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
