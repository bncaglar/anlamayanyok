import 'package:anlamayanyok/Giris%20Ekrani/Authentication_Service.dart';
import 'package:anlamayanyok/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class KayitOl extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get authStateChanges => _auth.authStateChanges();

  @override
  _KayitOlState createState() => _KayitOlState();
}

class _KayitOlState extends State<KayitOl> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _displayname = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<User> get authStateChanges => _auth.authStateChanges();

  bool isPassVisiblex = true;
  bool isPassVisibley = true;
  bool progressDurumu = false;
  bool emaildogrumu = false;
  bool sifredogrumu = false;
  bool isimdogrumu = false;
  var _url = 'https://anlamayan-yok-web.firebaseapp.com/';
  bool sozlesmeDurumu = false;
  final kayitBasarili = SnackBar(
    content: Text("kayıt başarılı!"),
    action: SnackBarAction(
      label: 'Tamam',
      textColor: Colors.white,
      onPressed: () {

      },
    ),
    backgroundColor: Colors.green,
  );
  final errorMessage = SnackBar(
    content: Text('Kayıt yaparken bir hata oluştu!'),
    action: SnackBarAction(
      label: 'Tekrar dene',
      textColor: Colors.white,
      onPressed: () {},
    ),
    backgroundColor: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    double _fontSizeQuery = MediaQuery.of(context).size.width;
    double _fontSizeHeight = MediaQuery.of(context).size.height;
    double textSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFACDFAFA),
                  Color(0xFAD5F8F8),
                  Color(0xFAE7FCFC),
                  Color(0xFAE8F6F6),
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
                    padding: EdgeInsets.only(top: _fontSizeHeight / 7.5),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        "Kayıt Ol",
                        style: GoogleFonts.cinzel(
                          fontStyle: FontStyle.normal,
                          fontSize: textSize * 35,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _fontSizeHeight * .035,
                  ),
                  Container(
                    height: _fontSizeHeight / 10.5,
                    width: _fontSizeQuery / 1.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 5,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(11.0),
                      child: TextFormField(
                        controller: _displayname,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            if (_displayname.text.length >= 3) {
                              setState(() {
                                isimdogrumu = true;
                              });
                            } else {
                              isimdogrumu = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: "Ad Soyad",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _fontSizeHeight * .035,
                  ),
                  Container(
                    height: _fontSizeHeight / 10.5,
                    width: _fontSizeQuery / 1.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.17),
                          spreadRadius: 5,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(11.0),
                      child: TextFormField(
                        onChanged: (text) {
                          setState(() {
                            if (_emailController.text.length != 0 &&
                                _emailController.text.contains("@")) {
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
                        controller: _emailController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          icon: Icon(Icons.email_rounded),
                          hintText: "E-posta",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _fontSizeHeight * .035,
                  ),
                  Container(
                    height: _fontSizeHeight / 10.5,
                    width: _fontSizeQuery / 1.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.18),
                          spreadRadius: 5,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(11.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: isPassVisibley,
                        onChanged: (value) {
                          setState(() {
                            if (_passwordController.text.length >= 3) {
                            } else {}
                          });
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: isPassVisibley
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: () => setState(
                                  () => isPassVisibley = !isPassVisibley),
                            ),
                            icon: Icon(Icons.lock_outline_rounded),
                            hintText: "Şifre"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _fontSizeHeight * .035,
                  ),
                  Container(
                    height: _fontSizeHeight / 10.5,
                    width: _fontSizeQuery / 1.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(11.0),
                      child: TextFormField(
                        onChanged: (text) {
                          setState(() {
                            if (_passwordController.text ==
                                _passwordController1.text) {
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
                        controller: _passwordController1,
                        obscureText: isPassVisiblex,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: isPassVisiblex
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: () => setState(
                                  () => isPassVisiblex = !isPassVisiblex),
                            ),
                            icon: Icon(Icons.lock_outline_rounded),
                            hintText: "Şifre Tekrar giriniz"),
                      ),
                    ),
                  ),
                  Container(
                    height: _fontSizeHeight * .085,
                    width: double.infinity,
                    child: CheckboxListTile(
                      title: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              style: TextStyle(color: Colors.blue),
                              text: "Kullanıcı sözleşmesini ",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  _launchURL();
                                }),
                          TextSpan(
                            style: TextStyle(color: Colors.black),
                            text: "okudum, kabul ediyorum.",
                          )
                        ]),
                      ),
                      value: sozlesmeDurumu,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool veri) {
                        setState(() {
                          sozlesmeDurumu = veri;
                        });
                      },
                    ),
                  ),
                  sozlesmeDurumu && isimdogrumu && emaildogrumu && sifredogrumu
                      ? GestureDetector(
                          onTap: () async {
                            setState(() {
                              progressDurumu = true;
                            });
                            try {
                             await context.read<AuthenticationService>().signUp(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  displayName: _displayname.text.trim()).then((value) {
                               return Navigator.pushReplacement(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) => AuthenticationWrapper()));
                             });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(kayitBasarili);
                              setState(() {
                                progressDurumu =false;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(errorMessage);
                            }
                          },
                          child: Container(
                            height: _fontSizeHeight / 11,
                            width: _fontSizeQuery / 1.20,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
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
                                        "Kayıt ol",
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
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 5,
                                blurRadius: 7,
                              ),
                            ],
                            color: Color(0xFA525F72),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                              child: progressDurumu
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                    )
                                  : Text(
                                      "Kayıt ol",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: textSize * 20,
                                      ),
                                    )),
                        ),
                  Container(
                    height: _fontSizeHeight / 13,
                    width: _fontSizeQuery,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back_outlined),
                                    SizedBox(width: _fontSizeQuery / 50),
                                    Text(
                                      "Geri dön",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: textSize * 17),
                                    ),
                                  ],
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
        ],
      ),
    );
  }

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
//0xFA4E6D99 kapalı renk
//0xFA728FB8 açık renk
