import 'package:anlamayanyok/Giris%20Ekrani/Authentication_Service.dart';
import 'package:anlamayanyok/Services/DBService.dart';
import 'package:anlamayanyok/utilities/App_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeMail extends StatefulWidget {
  @override
  _ChangeMailState createState() => _ChangeMailState();
}

class _ChangeMailState extends State<ChangeMail> {
  final error = SnackBar(
    content: Text('Lütfen geçerli bir e-posta girin!'),
    action: SnackBarAction(
      label: 'Tekrar dene',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    backgroundColor: Colors.red,
  );
  final error2 = SnackBar(
    content: Text('Lütfen çıkış yapıp tekrar deneyin!'),
    action: SnackBarAction(
      label: 'Tamam',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    backgroundColor: Colors.red,
  );
  final created = SnackBar(
    content: Text('E-posta değiştirildi!'),
    action: SnackBarAction(
      label: 'Tamam',
      textColor: Colors.white,
      onPressed: () {},
    ),
    backgroundColor: Colors.green,
  );
  bool emaildogrumu = false;
  final AuthenticationService authx =
      AuthenticationService(FirebaseAuth.instance);
  final TextEditingController _emailController = TextEditingController();
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    print(user.displayName);
    double _fontSizeQuery = MediaQuery.of(context).size.width;
    double _fontSizeHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            child: Center(
                child: Text(
              "E-postanı değiştir",
              style:
                  TextStyle(color: AppColors.primaryWightColor, fontSize: 20),
            )),
            decoration: new BoxDecoration(
              color: AppColors.backgroundPrimaryColor,
            ),
          ),
        ),
        backgroundColor: AppColors.backgroundPrimaryColor,
        body: Padding(
          padding: EdgeInsets.only(
              right: _fontSizeQuery / 30, left: _fontSizeQuery / 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: _fontSizeHeight / 45,
                width: double.infinity,
              ),
              Text(
                "E-posta",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.profileTextColor,
                    fontSize: 12),
              ),
              Container(
                height: _fontSizeHeight / 40,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: AppColors.modalBottomSheetColor,
                  ),
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(45),
                    ],
                    controller: _emailController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                        prefixText: "    ",
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: " Yeni e-posta",
                        hintStyle:
                            TextStyle(color: AppColors.primaryWightColor)),
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
                  ),
                ),
              ),
              Container(
                height: _fontSizeHeight / 40,
              ),
              InkWell(
                onTap: () async {
                  String uid = user.uid.toString();
                  try {
                    if(emaildogrumu){
                      await DBService.instance
                          .emailUpload(uid, _emailController.text);
                       await user.updateEmail(_emailController.text);
                      print(_emailController.text);
                      await user.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(created);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(error);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(error2);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: _fontSizeHeight / 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: AppColors.primaryGreyColor,
                  ),
                  child: Center(
                    child: Text(
                      "Kaydet",
                      style: TextStyle(
                        color: AppColors.profileTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
