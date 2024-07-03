import 'package:climate/providers/user_provider.dart';
import 'package:climate/responsive/mobile_screen_layout.dart';
import 'package:climate/responsive/responsive_layout_screen.dart';
import 'package:climate/responsive/web_screen_layout.dart';
import 'package:climate/screens/login_screen.dart';
import 'package:climate/screens/signup_screen.dart';
import 'package:climate/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

//MaterialApp is the starting point of your app, it tells Flutter that you are going to use Material components and follow material design in your app. Scaffold is used under MaterialApp , it gives you many basic functionalities, like AppBar , BottomNavigationBar , Drawer , FloatingActionButton etc

void main() async {
  //async await helps to execute the rest of the program and not wait until the specific asynchronous task is completed. Hence this makes it look synchronous(in order).
  WidgetsFlutterBinding
      .ensureInitialized(); //makes sure that the flutter widgets have been initialized before we move to firebase.
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyBGL64zwkUc9tvYnAHf3JMqULt5snNtnK4",
      appId: "1:690759588503:web:e26b2eecf45ad47774e7d2",
      messagingSenderId: "690759588503",
      projectId: "instagram-clone-c5df6",
      storageBucket: "instagram-clone-c5df6.appspot.com",
    )); //app widget is initialized
  } else {
    await Firebase.initializeApp(); //app widget is initialized
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //Provider, widgets listen to changes in the state and update as soon as they are notified. Therefore, instead of the entire widget tree rebuilding when there is a state change, only the affected widget is changed, thus reducing the amount of work and making the app run faster and more smoothly
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              UserProvider(), //to keep the user logged in even after restarting the app.
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        //used to persist the state of the app. If a user has logged in he remains logged in even after refreshing the page
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
