import 'package:flutter/material.dart';
import 'package:imarika_sacco_mobile_app/global_variables.dart';
import 'package:imarika_sacco_mobile_app/main_services.dart';

class MainServicesCard extends StatelessWidget {
  const MainServicesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ListView.builder(
          itemCount: mainServices.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index) {
            final mainService = mainServices[index];
            return MainServices(
              serviceIcon: mainService['serviceIcon'] as IconData,
              serviceName: mainService['serviceName'] as String,
              page: mainService['page'] as Widget,
            );
          }),
        ),
      ),
    );
  }
}
