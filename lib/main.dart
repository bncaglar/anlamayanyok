import 'package:anlamayanyok/AnaSayfa/FirstNavigation.dart';
import 'package:anlamayanyok/Giris%20Ekrani/Authentication_Service.dart';
import 'package:anlamayanyok/Giris%20Ekrani/Giris_Ekrani.dart';
import 'package:anlamayanyok/Giris%20Ekrani/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [

        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Anlamayan Yok',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }


}
 class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
 }) : super(key: key);

   @override
   Widget build(BuildContext context) {
     final firebaseUser = context.watch<User>();
     return Scaffold(
       body: StreamBuilder(
           stream: FirebaseAuth.instance.authStateChanges(),
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
               return Center(child: CircularProgressIndicator());
             } else if (snapshot.hasData || firebaseUser != null) {
               return FirstNavigation();
             } else if(snapshot.hasError){
               return Center(child: Text("Bir şeyler yanlış gitti!"),);
             }
             else{
               return Giris_Ekrani();
             }
           }
       ),
     );
   }
   Widget buildLoading() => Stack(
     fit: StackFit.expand,
     children: [
       Center(child: CircularProgressIndicator()),
     ],
   );
 }


