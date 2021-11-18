import '../Conversations/conversations.dart';
import 'package:anlamayanyok/Conversations/message.dart';
import 'package:anlamayanyok/Services/Contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBService {
  static DBService instance = DBService();

  FirebaseFirestore _db;

  DBService() {
    _db = FirebaseFirestore.instance;
  }

  String _userCollection = "Users";
  String _conversationsCollection = "Conversations";

  Future<void> createUserInDB(
      String _uid, String _name, String _email, String _imageURL) async {
    try {
      return await _db.collection(_userCollection).doc(_uid).set({
        "name": _name,
        "email": _email,
        "image": _imageURL,
        "lastSeen": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> ImageUploadProfile(String _uid, String _imageURL) async {
    try {
      return await _db.collection(_userCollection).doc(_uid).update({
        "image": _imageURL,
      });
    } catch (e) {
      print(e);
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> NameUpload(String _uid, String _name) async {
    try {
      return await _db.collection(_userCollection).doc(_uid).update({
        "name": _name,
      });
    } catch (e) {
      print(e);
    }
  }
  Future<void> emailUpload(String _uid, String _mail) async {
    try {
      return await _db.collection(_userCollection).doc(_uid).update({
        "email": _mail,
      });
    } catch (e) {
      print(e);
    }
  }
  Future<void> updateUserLastSeenTime(String _userID) {
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.update({"lastSeen": Timestamp.now()});
  }

  Future<void> sendMessage(String _conversationID, Message _message) {
    var _ref = _db.collection(_conversationsCollection).doc(_conversationID);
    var _messageType = "";
    switch (_message.type) {
      case MessageType.Text:
        _messageType = "text";
        break;
      case MessageType.Image:
        _messageType = "image";
        break;
      default:
    }
    return _ref.update({
      "messages": FieldValue.arrayUnion(
        [
          {
            "message": _message.content,
            "senderID": _message.senderID,
            "timestamp": _message.timestamp,
            "type": _messageType,
          }
        ],
      ),
    });
  }

  Future<void> deleteWholeMessage(String _conversationID) {
    var _ref =
        _db.collection(_conversationsCollection).doc(_conversationID).delete();
    return _ref;
  }

  Future<void> deleteWholeMessageOtherPart(String userID, String myID) {
    var _ref = _db
        .collection(_userCollection)
        .doc(myID)
        .collection(_conversationsCollection)
        .doc(userID)
        .delete();
    return _ref;
  }

  Future<void> deleteUserFromAuth() {
    var del = FirebaseAuth.instance.currentUser.delete();
    return del;
  }

  Future<void> deleteUserFromStore(String myID) {
    var _delete = _db.collection(_userCollection).doc(myID).delete();
    return _delete;
  }

  Future<void> createOrGetConversartion(String _currentID, String _recepientID,
      Future<void> _onSuccess(String _conversationID)) async {
    var _ref = _db.collection(_conversationsCollection);
    var _userConversationRef = _db
        .collection(_userCollection)
        .doc(_currentID)
        .collection(_conversationsCollection);

    try {
      var conversation = await _userConversationRef.doc(_recepientID).get();
      final data = conversation.data();
      if (data != null) {
        return _onSuccess(data["conversationID"]);
      } else {
        var _conversationRef = _ref.doc();
        await _conversationRef.set(
          {
            "members": [_currentID, _recepientID],
            "ownerID": _currentID,
            'messages': [],
          },
        );
        return _onSuccess(_conversationRef.id);
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    var _ref = _db
        .collection(_userCollection)
        .doc(_userID)
        .collection(_conversationsCollection);
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<Contact>> getUsersInDB(String _searchName) {
    var _ref = _db
        .collection(_userCollection)
        .where("name", isGreaterThanOrEqualTo: _searchName)
        .where("name", isLessThan: _searchName + 'z');
    return _ref.get().asStream().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return Contact.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<Conversation> getConversation(String _conversationID) {
    var _ref = _db.collection(_conversationsCollection).doc(_conversationID);

    return _ref.snapshots().map((_doc) {
      return Conversation.fromFirestore(_doc);
    });
  }
}
