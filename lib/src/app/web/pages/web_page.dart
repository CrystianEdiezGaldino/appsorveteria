import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorveteria/src/app/web/pages/formIn_page.dart';

import '../../../core/controllers/app_controller.dart';

class WebPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FormInPage(),
    );
  }
}
