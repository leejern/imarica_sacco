import 'package:flutter/material.dart';

class StatementsList extends StatelessWidget {
  final IconData serviceIcon;
  final String serviceName;
  final IconData icon;
  final Widget page;
  const StatementsList({
    super.key,
    required this.serviceIcon,
    required this.serviceName,
    required this.icon,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return page;
          },
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        height: 70,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(
                serviceIcon,
                size: 32,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                serviceName,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                width: 200,
              ),
              Icon(
                icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
