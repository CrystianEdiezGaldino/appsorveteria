import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sorveteria/src/core/Home.dart';
import 'package:sorveteria/src/core/constants.dart';
import 'package:sorveteria/src/core/controllers/app_controller.dart';
import 'package:sorveteria/src/core/services/firebase_messaging_service.dart';
import 'package:sorveteria/src/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // defini o app para não girar a tela
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
        home: const Home(),
      ),
    );
  }
}
