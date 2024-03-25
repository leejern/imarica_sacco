import 'package:flutter/material.dart';

class MainServices extends StatelessWidget {
  final IconData serviceIcon;
  final String serviceName;
  final Widget page;
  const MainServices({
    super.key,
    required this.serviceIcon,
    required this.serviceName,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return page;
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              serviceIcon,
              size: 32,
            ),
            Text(serviceName),
          ],
        ),
      ),
    );
  }
}
