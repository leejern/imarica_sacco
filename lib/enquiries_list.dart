import 'package:flutter/material.dart';

class EnquiriesList extends StatelessWidget {
  final String question;
  final String answer;
  const EnquiriesList({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ExpansionTile(
        title: Text(question), //header title
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 7,
                  color: Color.fromARGB(255, 180, 182, 183),
                ),
              ],
            ),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
