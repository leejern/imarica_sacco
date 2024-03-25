import 'package:flutter/material.dart';

class OtherServicesCard extends StatelessWidget {
  final IconData serviceIcon;
  final String serviceName;
  final Widget page;
  const OtherServicesCard({
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
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(
                  serviceIcon,
                  size: 32,
                ),
                const SizedBox(height: 10),
                Text(serviceName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
