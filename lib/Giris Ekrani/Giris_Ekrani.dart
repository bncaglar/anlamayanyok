import 'package:anlamayanyok/AnaSayfa/FirstNavigation.dart';
import 'package:anlamayanyok/Giris%20Ekrani/Authentication_Service.dart';
import 'package:anlamayanyok/Giris%20Ekrani/google_sign_in.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'SifreniMiUnuttun.dart';
import 'package:anlamayanyok/Giris%20Ekrani/Kay%C4%B1tOl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Giris_Ekrani extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get authStateChanges => _auth.authStateChanges();

  @override
  _Giris_EkraniState createState() => _Giris_EkraniState();
}

class _Giris_EkraniState extends State<Giris_Ekrani> {
  String giris = "Giriş";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final snackBar = SnackBar(
    content:
    Text('Giriş yaparken bir hata oluştu!'),
    action: SnackBarAction(
      label: 'Tekrar dene',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    backgroundColor: Colors.red,
  );
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<User> get authStateChanges => _auth.authStateChanges();
  bool isPassVisible = true;
  bool progressDurumu = false;
  bool isSignIn = false;
  bool emaildogrumu = false;
  bool sifredogrumu = false;

  @override
  Widget build(BuildContext context) {
    double _fontSizeQuery = MediaQuery.of(context).size.width;
    double _fontSizeHeight = MediaQuery.of(context).size.height;
    double textSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFADAF6F6),
                    Color(0xFAE3FAFA),
                    Color(0xFAF0FCFC),
                    Color(0xFAF4FDFD),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: _fontSizeHeight / 25),
                      child: Container(
                        width: _fontSizeQuery / 1,
                        height: _fontSizeHeight / 4,
                        // color: Colors.black,
                        child: Image.asset(
                          "pdfs/logomuz.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        "Anlamayan Yok",
                        style: GoogleFonts.cinzel(
                          fontStyle: FontStyle.normal,
                          fontSize: textSize * 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _fontSizeHeight * .05,
                    ),
                    Container(
                      height: _fontSizeHeight / 10.5,
                      width: _fontSizeQuery / 1.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(11.0),
                        child: TextFormField(
                          controller: _emailController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (text) {
                            setState(() {
                              if (_emailController.text.length != 0 &&
                                  _emailController.text.contains("@") &&
                                  _emailController.text.contains(".")) {
                                setState(() {
                                  emaildogrumu = true;
                                });
                              } else {
                                setState(() {
                                  emaildogrumu = false;
                                });
                              }
                            });
                          },
                          decoration: InputDecoration(
                            icon: Icon(Icons.email_rounded),
                            hintText: "E-posta",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _fontSizeHeight * .025,
                    ),
                    Container(
                      height: _fontSizeHeight / 10.5,
                      width: _fontSizeQuery / 1.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(11.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: isPassVisible,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (text) {
                            setState(() {
                              if (_passwordController.text.length >= 3 &&
                                  _passwordController.text.length <= 30) {
                                setState(() {
                                  sifredogrumu = true;
                                });
                              } else {
                                setState(() {
                                  sifredogrumu = false;
                                });
                              }
                            });
                          },
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                icon: isPassVisible
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                onPressed: () => setState(
                                    () => isPassVisible = !isPassVisible),
                              ),
                              hintText: "Şifre"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _fontSizeHeight * .012,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: _fontSizeQuery / 2),
                          child: GestureDetector(
                            onTap: () {
                              _push(context, SifreniMiUnuttun());
                            },
                            child: Container(
                              height: _fontSizeHeight / 30,
                              width: _fontSizeQuery / 2.2,
                              alignment: Alignment.bottomRight,
                              child: Center(
                                  child: Text(
                                "Şifreni mi unuttun?",
                                style: TextStyle(
                                    fontSize: textSize * 14,
                                    color: Color(0xFA383836)),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: _fontSizeHeight * .017,
                    ),
                    emaildogrumu && sifredogrumu
                        ? GestureDetector(
                            onTap: () async {
                                setState(() {
                                  progressDurumu = true;
                                });
                                try{
                                 var _firebaseAuth =  FirebaseAuth.instance;
                                  await _firebaseAuth.signInWithEmailAndPassword(
                                      email: _emailController.text, password: _passwordController.text);
                                 // await context.read<AuthenticationService>().signIn(
                                 //      email: _emailController.text.trim(),
                                 //      password: _passwordController.text.trim()
                                 // );
                                 if(_firebaseAuth.currentUser != null){
                                   _push(context, FirstNavigation());
                                 }else{
                                   print("error occured!");
                                   setState(() {
                                     progressDurumu = false;
                                   });
                                 }
                                }catch(e){
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                            },
                            child: Container(
                              height: _fontSizeHeight / 11,
                              width: _fontSizeQuery / 1.20,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                  ),
                                ],
                                color: Color(0xFA08101C),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                  child: progressDurumu
                                      ? CircularProgressIndicator(
                                          strokeWidth: 2,
                                        )
                                      : Text(
                                          giris,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize * 20,
                                          ),
                                        )),
                            ),
                          )
                        : Container(
                            height: _fontSizeHeight / 11,
                            width: _fontSizeQuery / 1.20,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                ),
                              ],
                              color: Color(0xFA525F72),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                                child: progressDurumu
                                    ? CircularProgressIndicator(
                                        strokeWidth: 2,
                                      )
                                    : Text(
                                        giris,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: textSize * 20,
                                        ),
                                      )),
                          ),
                    SizedBox(
                      height: _fontSizeHeight * .030,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: _fontSizeQuery * .37,
                          color: Color(0xFA383836),
                        ),
                        Container(
                          child: Text(" Ya da "),
                        ),
                        Container(
                          height: 1,
                          width: _fontSizeQuery * .37,
                          color: Color(0xFA383836),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: _fontSizeHeight / 85,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SignInButton(
                          Buttons.Google,
                          text: "Google ile giriş yap",
                          onPressed: () async {
                              try {
                               // final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                             //  await provider.googlelogin();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: _fontSizeHeight / 45,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hesabın mı yok? ",
                                style: TextStyle(
                                    fontSize: textSize * 14,
                                    color: Color(0xFA2B2B2A)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _push(context, KayitOl());
                                },
                                child: Text(
                                  'Kayıt ol',
                                  style: TextStyle(
                                    color: Color(0xFA323231),
                                    fontWeight: FontWeight.bold,
                                    fontSize: textSize * 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isSignIn
                ? Stack(
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}
