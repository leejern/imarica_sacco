import 'package:flutter/material.dart';
import 'package:imarika_sacco_mobile_app/deposit_page.dart';
import 'package:imarika_sacco_mobile_app/enquiries_page.dart';
import 'package:imarika_sacco_mobile_app/send_money_page.dart';
import 'package:imarika_sacco_mobile_app/statements_page.dart';
import 'package:imarika_sacco_mobile_app/transfer_cash_page.dart';
import 'package:imarika_sacco_mobile_app/budget_page.dart';

final mainServices = [
  {
    'id': 0,
    'serviceName': 'Send Money',
    'serviceIcon': Icons.send_to_mobile_outlined,
    'page': const SendMoneyPage()
  },
  {
    'id': 1,
    'serviceName': 'Deposit',
    'serviceIcon': Icons.atm,
    'page': const DepositPage()
  },
  {
    'id': 2,
    'serviceName': 'Transfer Cash',
    'serviceIcon': Icons.payments,
    'page':  TransferCashPage()
  },
];

final otherServices = [
  {
    'id': 0,
    'serviceName': 'Statement',
    'serviceIcon': Icons.money,
    'page': const StatementsPage()
  },
  {
    'id': 2,
    'serviceName': 'Budget',
    'serviceIcon': Icons.money,
    'page': const BudgetPage()
  },
  {
    'id': 1,
    'serviceName': 'Enquiries',
    'serviceIcon': Icons.money,
    'page': const EnquiriesPage()
  },
];

final enquiries = [
  {
    'id': 0,
    'question': 'How do I wthdraw money',
    'answer': 'Answers for Question One',
  },
  {
    'id': 1,
    'question': 'How to borrow a loan',
    'answer': 'Answers for Question One',
  },
  {
    'id': 2,
    'question': 'How do I wthdraw money',
    'answer': 'Answers for Question One',
  },
  {
    'id': 3,
    'question': 'How do I wthdraw money',
    'answer': 'Answers for Question One',
  },
  {
    'id': 4,
    'question': 'How do I wthdraw money',
    'answer': 'Answers for Question One',
  },
  {
    'id': 5,
    'question': 'How do I wthdraw money',
    'answer': 'Answers for Question One',
  },
  {
    'id': 6,
    'question': 'How do I wthdraw money',
    'answer': 'Answers for Question One',
  },
  {
    'id': 7,
    'question': 'How do I wthdraw money',
    'answer': 'Answers for Question One',
  },
  {
    'id': 8,
    'question': 'How do I wthdraw money',
    'answer': 'Answers for Question One',
  },
  {
    'id': 9,
    'question': 'How do I wthdraw money',
    'answer': 'Answers for Question One',
  },
  {
    'id': 10,
    'question': 'How do I wthdraw money',
    'answer': 'Answers for Question One',
  },
];

