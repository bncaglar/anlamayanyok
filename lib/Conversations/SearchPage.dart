import 'dart:math';

import 'package:anlamayanyok/Conversations/Conversation_Page.dart';
import 'package:anlamayanyok/Provider/auth_provider.dart';
import 'package:anlamayanyok/Services/DBService.dart';
import 'package:anlamayanyok/utilities/App_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:anlamayanyok/Services/Contacts.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  String _searchText;
  var newVariable;
  final user = FirebaseAuth.instance.currentUser;
  final _random = new Random();
  @override
  void initState() {
    super.initState();
    DBService.instance.updateUserLastSeenTime(user.uid);
  }
  _SearchPageState(){
    _searchText ="";
  }
  FirebaseAuth auth;

  refreshList(_usersData) async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      updateDataInList(_usersData);
    });
  }
  var listToShow = [];
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Container(
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: _searchPageUI(),
        ),
      ),
    );
  }
  Widget _searchPageUI(){
    final snackBar = SnackBar(
      content: Text('Kullanıcılar yüklenirken bir hata oluştu!'),
      action: SnackBarAction(
        label: 'Tekrar dene',textColor: Colors.white,
        onPressed: () {
          setState(() {});
        },
      ),
      backgroundColor: Colors.red,
    );
    try{
      return Builder(builder: (BuildContext _context){
        auth = FirebaseAuth.instance;
        return Scaffold(
          backgroundColor: AppColors.backgroundPrimaryColor,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height:MediaQuery.of(context).size.height*0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width *0.03),
                      child: _userSearchField(),
                    ),
                    _usersListView(),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    }catch(e){
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Widget _userSearchField(){
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.height*0.02),
        decoration: BoxDecoration(
          color: AppColors.modalBottomSheetColor,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child:TextField(
          autocorrect: false,
          style: TextStyle(
            color: AppColors.textPrimaryColor,
          ),
          onSubmitted: (_input){
            setState(() {
              _searchText = _input;
            });
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search,color: AppColors.primaryWightColor),
            labelStyle: TextStyle(
              color: AppColors.primaryWightColor,
              fontWeight: FontWeight.w400
            ),
            labelText: "Arama",
            border: OutlineInputBorder(
              borderSide: BorderSide.none
            ),
          ),
        ) ,
      ),
    );
  }
  Widget _usersListView(){
    return RefreshIndicator(
      child: StreamBuilder<List<Contact>>(
        stream:DBService.instance.getUsersInDB(_searchText) ,
          builder: (context, _snapshot){
          var _usersData = _snapshot.data;
          if(_usersData != null){
            _usersData.removeWhere((_contact) => _contact.id == auth.currentUser.uid);
            newVariable = _usersData;
          }
        return _snapshot.hasData
            ? Container(
              height :MediaQuery.of(context).size.height * 0.80,
               child: ListView.builder(
                 itemCount: _usersData.length,
                  itemBuilder: (BuildContext _context,
                int _index){
                  var _userData = _usersData[_index];
                var _currentTime = DateTime.now();
                var _recepientID = _usersData[_index].id;
                  timeago.setLocaleMessages('tr', timeago.TrMessages());
                  var _isUserActive = !_userData.lastseen.toDate().isBefore(
                _currentTime.subtract(Duration(minutes: 1),
                ),
              );
              return ListTile(
                onTap: (){
                  DBService.instance.createOrGetConversartion(
                      auth.currentUser.uid, _recepientID,
                          (String _conversationID) async{
                        _push(context, ConversationPage(_conversationID,
                            _recepientID,
                            _userData.name,
                            _userData.image,
                        ));
                      });
                },
                title: Text(_userData.name,style: TextStyle(
                    color: AppColors.primaryWightColor,
                    fontWeight: FontWeight.w600
                ),),
                leading: Container(
                  height: MediaQuery.of(context).size.height * .075,
                  width: MediaQuery.of(context).size.width * .14,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(_userData.image),
                    backgroundColor: Colors.transparent,),
                ),
                trailing:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:<Widget> [
                    _isUserActive ?
                    Text("Çevrimiçi",
                      style: TextStyle(
                          color: AppColors.primaryWightColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),) :  Text("Son Görülme",
                      style: TextStyle(
                          color: AppColors.primaryWightColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),),
                    _isUserActive ? Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ):Text(
                      timeago.format(_userData.lastseen.toDate(), locale: 'tr'
                      ),
                      style: TextStyle(
                          color: AppColors.primaryWightColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 13),)
                  ],
                ) ,
              );
            },
          ),
        ): Center(
          child: SpinKitFadingCircle(
            color: Colors.blue,
            size: 50.0,
          ),
        );
      }),
      onRefresh: () {

        return refreshList(newVariable);},
    );
  }
  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
   updateDataInList(_usersData) {
    listToShow = new List.generate(10, (_) => _usersData[_random.nextInt(_usersData.length)]);
  }
}
