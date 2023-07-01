import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sorveteria/src/core/responsive.dart';

import '../app/web/pages/web_page.dart';
import 'controllers/app_controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

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
            // Versão desktop
            Expanded(
              child: Responsive(
                desktop: WebPage(),
                mobile: Expanded(
                  //Versão mobile
                  flex: 5,
                  child: Text("Mobile"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
