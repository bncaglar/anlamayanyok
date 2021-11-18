import 'package:anlamayanyok/utilities/App_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final shouldbesame = SnackBar(
    content: Text('Şifreler aynı olmalıdır!'),
    action: SnackBarAction(
      label: 'Tekrar dene',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    backgroundColor: Colors.red,
  );
  final atleasthree = SnackBar(
    content: Text('Şifre en az 3 karakter olmalıdır!'),
    action: SnackBarAction(
      label: 'Tekrar dene',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    backgroundColor: Colors.red,
  );
  final changed = SnackBar(
    content: Text('Şifre değiştirildi!'),
    action: SnackBarAction(
      label: 'Tamam',
      textColor: Colors.white,
      onPressed: () {},
    ),
    backgroundColor: Colors.green,
  );
  bool isPassVisibley = true;
  bool isPassVisiblex = true;
  final TextEditingController _passwordControllerx = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

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
              "Şifreni değiştir",
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
                "Şifre",
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
                      LengthLimitingTextInputFormatter(20),
                    ],
                    controller: _passwordController,
                    obscureText: isPassVisibley,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    autocorrect: false,
                    decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: (){
                            setState(() {
                              isPassVisibley = !isPassVisibley;
                            });
                          },
                          child: Icon(
                              isPassVisibley
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.primaryWightColor),
                        ),
                        prefixText: "    ",
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: " Yeni şifre",
                        hintStyle:
                            TextStyle(color: AppColors.primaryWightColor)),
                    onChanged: (text) {},
                  ),
                ),
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
                      LengthLimitingTextInputFormatter(20),
                    ],
                    controller: _passwordControllerx,
                    obscureText: isPassVisiblex,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    autocorrect: false,
                    decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: (){
                            setState(() {
                              isPassVisiblex = !isPassVisiblex;
                            });
                          },
                          child: Icon(
                              isPassVisiblex
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.primaryWightColor),
                        ),
                        prefixText: "    ",
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: " Yeni şifreyi tekrar giriniz",
                        hintStyle:
                            TextStyle(color: AppColors.primaryWightColor)),
                    onChanged: (text) {},
                  ),
                ),
              ),
              Container(
                height: _fontSizeHeight / 40,
              ),
              InkWell(
                onTap: () async {
                  if(_passwordController.text == _passwordControllerx.text){
                    if(_passwordController.text.length>=3 && _passwordControllerx.text.length>=3){
                     await user.updatePassword(_passwordControllerx.text);
                      ScaffoldMessenger.of(context).showSnackBar(changed);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(atleasthree);
                    }
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(shouldbesame);
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
