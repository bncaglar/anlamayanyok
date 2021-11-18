import 'dart:io';

import 'package:anlamayanyok/PhotoView/PhotoView.dart';
import 'package:anlamayanyok/Profile/change_email.dart';
import 'package:anlamayanyok/Profile/change_name.dart';
import 'package:anlamayanyok/Profile/change_password.dart';
import 'package:anlamayanyok/Services/DBService.dart';
import 'package:anlamayanyok/Services/authentication.dart';
import 'package:anlamayanyok/utilities/App_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class ProfileView extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get authStateChanges => _auth.authStateChanges();

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthService authx = AuthService();
  bool isPhotoUploaded = false;
  String imageUrl;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    DBService.instance.updateUserLastSeenTime(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    double _fontSizeQuery = MediaQuery.of(context).size.width;
    double _fontSizeHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimaryColor,
        appBar: AppBar(
          flexibleSpace: Container(
            child: Center(
                child: Text(
              "Hesabım",
              style:
                  TextStyle(color: AppColors.primaryWightColor, fontSize: 20),
            )),
            decoration: new BoxDecoration(
              color: AppColors.backgroundPrimaryColor,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  // height: _fontSizeHeight/45,
                  width: double.infinity,
                ),
                SizedBox(
                  height: _fontSizeHeight * .13,
                  width: _fontSizeQuery * .19,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("pdfs/placeholderpp.jpg"),
                        backgroundColor: Colors.transparent,
                      ),
                      (user.photoURL != null)
                          ? InkWell(
                              onTap: () {
                               // _push(context, PhotoViewPage(user.photoURL));
                              },
                              child: CircleAvatar(

                                backgroundImage: NetworkImage(user.photoURL),
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : Container(),
                      Positioned(
                        top: 55,
                        left: 50,
                        child: GestureDetector(
                          onTap: () {
                            uploadImage();
                          },
                          child: Container(
                            height: _fontSizeHeight * .045,
                            width: _fontSizeQuery * .10,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orangeAccent),
                            child: TextButton(
                              onPressed: () => uploadImage(),
                              child: Icon(
                                Icons.edit,
                                color: Color(0xFF47474E),
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: _fontSizeHeight / 45,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: _fontSizeQuery / 30, left: _fontSizeQuery / 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                      ),
                      Text(
                        "Profil bilgilerim",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.profileTextColor,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: _fontSizeQuery / 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: _fontSizeQuery / 4,
                            child: Text(
                              "Ad Soyad",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGreyColor),
                            ),
                          ),
                          Container(
                            width: _fontSizeQuery / 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Çağlar Binici",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.profileTextColor,
                                        fontSize: 12)),
                                Container(
                                  //height: _fontSizeHeight/45,
                                  width: _fontSizeQuery / 10,
                                  child: InkWell(
                                    onTap: () {
                                      _push(context, ChangeName());
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 17,
                                      color: AppColors.arrowIos,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: _fontSizeQuery / 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: _fontSizeQuery / 4,
                            child: Text(
                              "E-posta",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGreyColor),
                            ),
                          ),
                          Container(
                            width: _fontSizeQuery / 1.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(user.email,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.profileTextColor,
                                        fontSize: 12)),
                                Container(
                                  //height: _fontSizeHeight/45,
                                  width: _fontSizeQuery / 10,
                                  child: InkWell(
                                    onTap: () {
                                      _push(context, ChangeMail());
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 17,
                                      color: AppColors.arrowIos,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: _fontSizeQuery / 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: _fontSizeQuery / 4,
                            child: Text(
                              "Şifre",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGreyColor),
                            ),
                          ),
                          Container(
                            width: _fontSizeQuery / 1.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  //height: _fontSizeHeight/45,
                                  width: _fontSizeQuery / 10,
                                  child: InkWell(
                                    onTap: () {
                                      _push(context, ChangePassword());
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 17,
                                      color: AppColors.arrowIos,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: _fontSizeQuery / 13,
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: AppColors.profileTextColor,
                      ),
                      SizedBox(
                        height: _fontSizeQuery / 20,
                      ),
                      Text(
                        "Hesap kontrol",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.profileTextColor,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: _fontSizeQuery / 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: _fontSizeQuery / 4,
                            child: Text(
                              "Paylaş",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGreyColor),
                            ),
                          ),
                          Container(
                            width: _fontSizeQuery / 1.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  //height: _fontSizeHeight/45,
                                  width: _fontSizeQuery / 10,
                                  child: InkWell(
                                    onTap: () {
                                      share(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 17,
                                      color: AppColors.arrowIos,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: _fontSizeQuery / 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: _fontSizeQuery / 2.8,
                            child: Text(
                              "Yardım ve destek",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGreyColor),
                            ),
                          ),
                          Container(
                            width: _fontSizeQuery / 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  //height: _fontSizeHeight/45,
                                  width: _fontSizeQuery / 10,
                                  child: InkWell(
                                    onTap: () {
                                      _sendEmail();
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 17,
                                      color: AppColors.arrowIos,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: _fontSizeQuery / 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: _fontSizeQuery / 2.8,
                            child: Text(
                              "Hesabı sil",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGreyColor),
                            ),
                          ),
                          Container(
                            width: _fontSizeQuery / 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  //height: _fontSizeHeight/45,
                                  width: _fontSizeQuery / 10,
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Center(
                                                  child: Text(
                                                "Hesabı sil",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize:
                                                      _fontSizeQuery * .050,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )),
                                              actions: [
                                                Column(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        "Hesabı silmek istiyor musun?",
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize:
                                                              _fontSizeQuery *
                                                                  .040,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Center(
                                                      child: Container(
                                                        height: 1,
                                                        width: 265,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          child: Text(
                                                            "Hayır",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize:
                                                                  _fontSizeQuery *
                                                                      .047,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              _fontSizeQuery /
                                                                  5.5,
                                                        ),
                                                        TextButton(
                                                          child: Text(
                                                            "Evet",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize:
                                                                  _fontSizeQuery *
                                                                      .047,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            await DBService
                                                                .instance
                                                                .deleteUserFromAuth();
                                                            await DBService
                                                                .instance
                                                                .deleteUserFromStore(
                                                                    user.uid);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                              elevation: 8,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                            );
                                          });
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 17,
                                      color: AppColors.arrowIos,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: _fontSizeQuery / 6,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                        child: Text(
                                      "Çıkış yap",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: _fontSizeQuery * .050,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                                    actions: [
                                      Column(
                                        children: [
                                          Center(
                                            child: Text(
                                              "Çıkış yapmak istiyor musun?",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: _fontSizeQuery * .040,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                            child: Container(
                                              height: 1,
                                              width: 265,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                child: Text(
                                                  "Hayır",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize:
                                                        _fontSizeQuery * .047,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(
                                                width: _fontSizeQuery / 5.5,
                                              ),
                                              TextButton(
                                                child: Text(
                                                  "Evet",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize:
                                                        _fontSizeQuery * .047,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  setState(() async {
                                                    try {
                                                      await authx.signOut();
                                                      Navigator.pop(context);
                                                    } catch (e) {
                                                      print("error occured");
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  );
                                });
                          },
                          child: Container(
                            width: _fontSizeQuery / 3.2,
                            height: _fontSizeHeight / 15,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              color: AppColors.dismissRedColor,
                            ),
                            child: Center(
                              child: Text(
                                "Çıkış yap",
                                style: TextStyle(
                                  color: AppColors.primaryWightColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void share(BuildContext context) {
    final String text = " Anlamayan Yok artık Google Play Store'de! "
        "https://play.google.com/store/apps/details?id=com.anlamayanyok";
    Share.share(text);
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return page;
    }));
  }

  uploadImage() async {
    final snackBar = SnackBar(
      content: Text('Profil güncellendi!'),
      action: SnackBarAction(
        label: 'Sayfayı yenile',
        textColor: Colors.white,
        onPressed: () {
          setState(() {});
        },
      ),
      backgroundColor: Colors.green,
    );
    setState(() async {
      final _storage = FirebaseStorage.instance;
      final _picker = ImagePicker();
      PickedFile image;
      final user = FirebaseAuth.instance.currentUser;

      //Check Permissions
      await Permission.photos.request();

      var permissionStatus = await Permission.photos.status;

      if (permissionStatus.isGranted) {
        //Select Image
        image = await _picker.getImage(
            source: ImageSource.gallery, imageQuality: 20);
        setState(() {
          isPhotoUploaded = true;
        });
        var file = File(image.path);

        if (image != null) {
          //Upload to Firebase
          var snapshot = await _storage
              .ref()
              .child("ProfilFoto/" + user.email + "/" + user.uid)
              .putFile(file);

          var downloadUrl = await snapshot.ref.getDownloadURL();
          FirebaseAuth auth = FirebaseAuth.instance;
          String uid = auth.currentUser.uid.toString();
          setState(() async {
            imageUrl = downloadUrl;
            user.updateProfile(photoURL: imageUrl);
            await DBService.instance.ImageUploadProfile(uid, imageUrl);
            setState(() {
              isPhotoUploaded = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        } else {
          print('No Path Received');
        }
      } else {
        print('Grant Permissions and try again');
      }
    });
    setState(() {});
  }

  _sendEmail() async {
    final snackBar = SnackBar(
      content: Text('Bir hata oluştu!'),
      action: SnackBarAction(
        label: 'Tekrar dene',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
      backgroundColor: Colors.red,
    );
    try {
      final Email email = Email(
        body: 'Anlamayan Yok Destek ekibi',
        subject: 'Yardım ve Destek',
        recipients: ['anlamayanyok@gmail.com'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
