// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sorveteria/src/app/web/pages/productForm_Page.dart';
import 'package:sorveteria/src/app/web/pages/products_page.dart';
import 'package:sorveteria/src/core/Home.dart';
import 'package:sorveteria/src/core/constants.dart';
import 'package:sorveteria/src/core/controllers/app_controller.dart';
import 'package:sorveteria/src/core/services/firebase_messaging_service.dart';
import 'package:sorveteria/src/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBC5AE5TIzxlWQK6tO7ZS5MY7UO1rUEiN0",
        authDomain: "sorveteria-7d8f2.firebaseapp.com",
        projectId: "sorveteria-7d8f2",
        storageBucket: "sorveteria-7d8f2.appspot.com",
        messagingSenderId: "461451798079",
        appId: "1:461451798079:web:4a9b0be28714db4054fa8a",
        measurementId: "G-GCMV35Q22V",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirebaseMessagingService messagingService =
        FirebaseMessagingService(NotificationService());
    messagingService.initialize();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppController(),
        ),
        Provider<FirebaseMessagingService>.value(value: messagingService),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SORVETERIA',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        home:    ProductFormPage(),
      ),
    );
  }
}
