import 'dart:async';

import 'package:anlamayanyok/Conversations/Conversation_Page.dart';
import 'package:anlamayanyok/Conversations/SearchPage.dart';
import 'package:anlamayanyok/Provider/auth_provider.dart';
import 'package:anlamayanyok/Services/DBService.dart';
import 'package:anlamayanyok/utilities/App_color.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Conversations/message.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Conversations/conversations.dart';
import 'package:sizer/sizer.dart';

class RecentConversationsPage extends StatefulWidget {
  @override
  _RecentConversationsPageState createState() =>
      _RecentConversationsPageState();
}

class _RecentConversationsPageState extends State<RecentConversationsPage> {
  double _height;
  double _width;
  static final user = FirebaseAuth.instance.currentUser;
  final myID = user.uid;
  Future<Null> _refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _conversationsListViewWidget(context);
    });
  }
  final afterDelete = SnackBar(
    content:
    Text('Sohbet temizlendi'),
    action: SnackBarAction(
      label: 'Tamam',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    backgroundColor: Colors.red,
  );
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimaryColor,
        appBar: AppBar(
          flexibleSpace: Container(
            child: Center(
                child: Text(
                  "Mesajlarım",
                  style:
                      TextStyle(color: AppColors.primaryWightColor, fontSize: 20),
                )),
            decoration: new BoxDecoration(
              color: AppColors.backgroundPrimaryColor,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          child: GestureDetector(
              onLongPress: () {
                Text("Sohbet başlat");
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              )),
          onPressed: () {
            _push(context, SearchPage());
          },
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: _height,
                width: _width,
                child: ChangeNotifierProvider<AuthProvider>.value(
                  value: AuthProvider.instance,
                  child: _conversationsListViewWidget(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _conversationsListViewWidget(BuildContext context) {
    double heightofScreen = MediaQuery.of(context).size.height;
    double widthofScreen = MediaQuery.of(context).size.width;
    final snackBar = SnackBar(
      content: Text('Mesajlar yüklenirken bir hata oluştu!'),
      action: SnackBarAction(
        label: 'Tekrar dene',
        textColor: Colors.white,
        onPressed: () {
          setState(() {});
        },
      ),
      backgroundColor: Colors.red,
    );
    try {
      return RefreshIndicator(
        child: Builder(
          builder: (BuildContext _context) {
            var auth = FirebaseAuth.instance.currentUser;
            return Container(
              height: _height,
              width: _width,
              child: StreamBuilder<List<ConversationSnippet>>(
                stream: DBService.instance.getUserConversations(auth.uid),
                builder: (_context, _snapshot) {
                  var _data = _snapshot.data;
                  if (_data != null) {
                    return _data.length != 0
                        ? ListView.builder(
                            itemCount: _data.length,
                            itemBuilder: (_context, _index) {
                              final item = _data[_index];
                              return Slidable(
                                key: ValueKey(item),
                                dismissal: SlidableDismissal(

                                  dismissThresholds: <SlideActionType, double>{
                                    SlideActionType.secondary: 0.0
                                  },
                                  child: Container(),
                                  onDismissed: (actionType) async {
                                    await DBService.instance.deleteWholeMessageOtherPart(
                                        _data[_index].id,
                                        myID);
                                    setState(() {
                                      _data.removeAt(_index);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(afterDelete);
                                  },
                                ),
                                actionPane: SlidableStrechActionPane(),
                                actionExtentRatio: 1,
                                secondaryActions: [slideAction()],
                                child: Container(
                                  height: heightofScreen *0.115,
                                  //color: Colors.pink,
                                  padding: EdgeInsets.only(top: 10),
                                  child: ListTile(
                                    onTap: () {
                                      _push(
                                          context,
                                          ConversationPage(
                                            _data[_index].conversationID,
                                            _data[_index].id,
                                            _data[_index].name,
                                            _data[_index].image,
                                          ));
                                    },
                                    title: Text(
                                      _data[_index].name,
                                      style: TextStyle(
                                          color: AppColors.primaryWightColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      _data[_index].type == MessageType.Text
                                          ? _data[_index].lastMessage
                                          : "Dosya: Fotoğraf",
                                      style: TextStyle(
                                          color: AppColors.primaryWightColor,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        _data[_index].image,
                                      ),
                                    ),
                                    trailing: _listTileTrailingWidgets(
                                        _data[_index].timestamp),
                                  ),
                                ),
                              );
                            },
                          )
                        : Align(
                            child: Text(
                              "Şimdilik mesajınız yok!",
                              style: TextStyle(
                                  color: AppColors.primaryWightColor,
                                  fontSize: 15),
                            ),
                          );
                  } else {
                    return SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 50.0,
                    );
                  }
                },
              ),
            );
          },
        ),
        onRefresh: _refreshList,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  IconSlideAction slideAction() {
    return IconSlideAction(
      color: Colors.transparent,
      iconWidget: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.dismissRedColor,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Container(
          height: 5,
          width: 5,
         padding: EdgeInsets.only(top: 18, bottom: 18),
         margin: EdgeInsets.only(top: 5, bottom: 5),
          child: Image.asset(
            "pdfs/icons/trash.png",
            height: 3,
            width: 4,
          ),
        ),
      ),
    );
  }
  Widget _listTileTrailingWidgets(Timestamp _lastMessageTimestamp) {
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          "Son Mesaj",
          style: TextStyle(
              color: AppColors.primaryWightColor,
              fontWeight: FontWeight.w500,
              fontSize: 15),
        ),
        Text(
          timeago.format(_lastMessageTimestamp.toDate(), locale: 'tr'),
          style: TextStyle(
              color: AppColors.primaryWightColor,
              fontWeight: FontWeight.w300,
              fontSize: 14),
        ),
      ],
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}
