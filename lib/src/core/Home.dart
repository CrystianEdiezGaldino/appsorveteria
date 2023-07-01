import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sorveteria/src/core/responsive.dart';

import 'controllers/app_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<AppController>().scaffoldKey,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vers�o desktop
            if (Responsive.isDesktop(context))
              Expanded(
                child: Container(),
              ),
            Expanded(
              //Vers�o mobile
              flex: 5,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
