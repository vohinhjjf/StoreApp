import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constant.dart';
import '../../utils/debouncer.dart';
import '../../utils/utilities.dart';
import 'provider/ChatProvider.dart';
import 'provider/MessageProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../models/customer_model.dart';
import '../../components/loading_view.dart';
import 'ChatScreen.dart';

class MessagesPage extends StatefulWidget {
  MessagesPage({Key? key}) : super(key: key);
  @override
  State createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  MessagesPageState({Key? key});

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final ScrollController listScrollController = ScrollController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<QueryDocumentSnapshot> listMessage = [];

  int _limit = 20;
  int _limitIncrement = 20;
  String _textSearch = "";
  bool isLoading = false;
  bool check = false;
  late ChatProvider chatProvider;

  late String userId = "";
  late String groupChatId = "";

  late String currentUserId;
  late MessageProvider messageProvider;
  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBarTec = TextEditingController();

  @override
  void initState() {
    super.initState();

    messageProvider = context.read<MessageProvider>();
    chatProvider = context.read<ChatProvider>();
    currentUserId = auth.currentUser!.uid;
    if (currentUserId != null) {
      debugPrint('movieTitle: $currentUserId');
    } else {
      currentUserId = '';
    }
    registerNotification();
    listScrollController.addListener(scrollListener);

    print(groupChatId);
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {

      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('push token: $token');
      if (token != null) {
        messageProvider.updateDataFirestore(
            FirestoreConstants.pathUserCollection,
            currentUserId,
            {'pushToken': token});
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void scrollListener() {
    if (listScrollController.offset >=
        listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  Future<bool> onBackPress() {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hỗ trợ khách hàng",
          style: TextStyle(color: ColorConstants.primaryColor),
        ),
        centerTitle: true,
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Column(
              children: [
                buildSearchBar(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: messageProvider.getStreamFireStore(
                        FirestoreConstants.pathUserCollection,
                        _limit,
                        _textSearch),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if ((snapshot.data?.docs.length ?? 0) > 0) {
                          return ListView.builder(
                            padding: EdgeInsets.all(10),
                            itemBuilder: (context, index) => buildItem(
                                context, snapshot.data?.docs[index], index),
                            itemCount: snapshot.data?.docs.length,
                            controller: listScrollController,
                          );
                        } else {
                          return const Center(
                            child: Text("No users"),
                          );
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.themeColor,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

            // Loading
            Positioned(
              child: isLoading ? LoadingView() : SizedBox.shrink(),
            )
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? LoadingView() : SizedBox.shrink(),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.search, color: ColorConstants.greyColor, size: 20),
          SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              onChanged: (value) {
                searchDebouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    btnClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Tìm khách hàng (nhập chính xác tên)',
                hintStyle:
                TextStyle(fontSize: 13, color: ColorConstants.greyColor),
              ),
              style: TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                    onTap: () {
                      searchBarTec.clear();
                      btnClearController.add(false);
                      setState(() {
                        _textSearch = "";
                      });
                    },
                    child: Icon(Icons.clear_rounded,
                        color: ColorConstants.greyColor, size: 20))
                    : SizedBox.shrink();
              }),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorConstants.greyColor2,
      ),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }

  Widget buildItem(
      BuildContext context, DocumentSnapshot? document, int index) {
    if (document != null) {
      CustomerModel userChat = CustomerModel.fromDocument(document);
      userId = userChat.id;
      if (userChat.id == currentUserId) {
        return SizedBox.shrink();
      } else {
        return Container(
          child: TextButton(
            child: Row(
              children: <Widget>[
                Image.network(
                  userChat.image,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.themeColor,
                        value: loadingProgress.expectedTotalBytes !=
                            null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, object, stackTrace) {
                    return const Icon(
                      Icons.account_circle,
                      size: 35,
                      color: ColorConstants.greyColor,
                    );
                  },
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '${userChat.name ?? "ll"}',
                            maxLines: 1,
                            style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontSize: 17),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                        ),
                        Container(
                          child: buildListMessage(),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                        buildLoading(),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20),
                  ),
                ),
              ],
            ),
            onPressed: () {
              if (Utilities.isKeyboardShowing()) {
                Utilities.closeKeyboard(context);
              }
              check = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    arguments: ChatPageArguments(
                      peerId: userChat.id!,
                      peerAvatar:
                      userChat.image ?? 'https://cdn-icons-png.flaticon.com/512/1177/1177568.png?w=360',
                      peerNickname: userChat.name ?? 's',
                    ),
                  ),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all<Color>(ColorConstants.greyColor2),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  // Widget buildLastMessage() {
  //   QueryDocumentSnapshot lastMessage;
  //   groupChatId = 'pEodccDjmgQZ7Iu3iS8XjAW1Ep53-FLgTuZ4eRKXZRTPB6xrXNhxU0L33';
  //   return Flexible(
  //     child: groupChatId.isNotEmpty
  //         ? StreamBuilder<QuerySnapshot>(
  //             stream: chatProvider?.getLastChatStream(groupChatId, 1),
  //             builder: (BuildContext context,
  //                 AsyncSnapshot<QuerySnapshot> snapshot) {
  //               print("aaaaaaaaaaa${snapshot.data.toString()}");
  //               if (snapshot.hasData) {
  //                 lastMessage =
  //                     snapshot.data!.docs[snapshot.data!.docs.length - 1];
  //                 if (lastMessage != null) {
  //                   return Text(
  //                     chatProvider!.getLastMessage(snapshot.data?.docs[1]),
  //                   );
  //                 } else {
  //                   return Text("No message here yet...1");
  //                 }
  //               } else {
  //                 return Text("No message here yet...2");
  //               }
  //             },
  //           )
  //         : Text("No message here yet...3"),
  //   );
  // }
  void readLocal() {
    String peerId = userId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
  }

  Widget buildListMessage() {
    readLocal();
    print(
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" +
            userId);
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
        stream: chatProvider.getChatStream(groupChatId, 20),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage = snapshot.data!.docs;
            print(groupChatId);
            print("sssssssssssssssssssss" + listMessage.toString());
            if (listMessage.isNotEmpty) {
              if (snapshot.data?.docs[0].get("idFrom") ==
                  "yfoznXChE5hB3ZWlW26Lq7dVnyn1") {
                return Row(
                  children: [
                    Text(
                        chatProvider
                            .getLastMessage(
                            snapshot.data?.docs[0])
                            .length >=
                            15
                            ? "Ban: " +
                            chatProvider
                                .getLastMessage(
                                snapshot.data?.docs[0])
                                .substring(1, 15) +
                            "..."
                            : "Ban: " +
                            chatProvider.getLastMessage(
                                snapshot.data?.docs[0]),
                        style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Text(
                      DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(
                            chatProvider.getLastMessageTime(
                                snapshot.data?.docs[0]),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Text(
                        chatProvider
                            .getLastMessage(
                            snapshot.data?.docs[0])
                            .length >=
                            15
                            ? chatProvider
                            .getLastMessage(
                            snapshot.data?.docs[0])
                            .substring(1, 15) +
                            "..."
                            : chatProvider
                            .getLastMessage(snapshot.data?.docs[0]),
                        style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Text(
                      DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(
                            chatProvider.getLastMessageTime(
                                snapshot.data?.docs[0]),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return Text("");
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstants.themeColor,
              ),
            );
          }
        },
      )
          : Center(
        child: CircularProgressIndicator(
          color: ColorConstants.themeColor,
        ),
      ),
    );
  }
}
