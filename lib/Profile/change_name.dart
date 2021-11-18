import 'package:anlamayanyok/Giris%20Ekrani/Authentication_Service.dart';
import 'package:anlamayanyok/Services/DBService.dart';
import 'package:anlamayanyok/utilities/App_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ChangeName extends StatefulWidget {
  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final error = SnackBar(
    content:
    Text('Ad Soyad en az 3 karakter olmalıdır!'),
    action: SnackBarAction(
      label: 'Tekrar dene',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    backgroundColor: Colors.red,
  );
  final created = SnackBar(
    content:
    Text('Ad Soyad değiştirildi!'),
    action: SnackBarAction(
      label: 'Tamam',
      textColor: Colors.white,
      onPressed: () {
      },
    ),
    backgroundColor: Colors.green,
  );
  final AuthenticationService authx = AuthenticationService(FirebaseAuth.instance);
  final TextEditingController _displayname = TextEditingController();
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
                  "İsmini değiştir",
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
                "Ad soyad",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.profileTextColor,
                    fontSize: 12),
              ),
              Container(

                height: _fontSizeHeight / 40,
              ),
              Center(
                child:  Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: AppColors.modalBottomSheetColor,
                  ),
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    controller: _displayname,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixText: "    ",
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "",
                      hintStyle: TextStyle(
                        color: AppColors.primaryWightColor
                      )
                    ),
                    onChanged: (text){
                    },
                  ),
                ),
              ),
              Container(
                height: _fontSizeHeight / 40,
              ),
              InkWell(
                onTap: () async{
                  String uid = user.uid.toString();
                  if(_displayname.text.length>=3){
                   await user.updateProfile(displayName: _displayname.text);
                    await DBService.instance.NameUpload(uid, _displayname.text);
                   ScaffoldMessenger.of(context).showSnackBar(created);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(error);
                  }
                },
                child: Container(
                  width:double.infinity,
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
