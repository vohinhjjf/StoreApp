import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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
  final int _limitIncrement = 20;
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
      if (message.notification != null) {}
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
      body: WillPopScope(
        onWillPop: onBackPress,
        child: Stack(
          children: <Widget>[
            // List
            Column(
              children: [
                buildAppBar(),
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
                            padding: const EdgeInsets.all(10),
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
                        return const Center(
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
              child: isLoading ? LoadingView() : const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? LoadingView() : const SizedBox.shrink(),
    );
  }

  Widget buildAppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              "Conversations",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.pink[50],
              ),
              child: Row(
                children: const <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.pink,
                    size: 20,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "Add New",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorConstants.greyColor2,
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.search, color: ColorConstants.greyColor, size: 20),
          const SizedBox(width: 5),
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
              decoration: const InputDecoration.collapsed(
                hintText: 'Tìm người dùng (nhập chính xác tên)',
                hintStyle:
                    TextStyle(fontSize: 13, color: ColorConstants.greyColor),
              ),
              style: const TextStyle(fontSize: 13),
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
                        child: const Icon(Icons.clear_rounded,
                            color: ColorConstants.greyColor, size: 20))
                    : const SizedBox.shrink();
              }),
        ],
      ),
    );
  }

  Widget buildItem(
      BuildContext context, DocumentSnapshot? document, int index) {
    if (document != null) {
      CustomerModel userChat = CustomerModel.fromDocument(document);
      userId = userChat.id;
      if (userChat.id == currentUserId) {
        return const SizedBox.shrink();
      } else {
        return Container(
          margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
          child: TextButton(
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
                      peerId: userChat.id,
                      peerAvatar: userChat.image,
                      peerNickname: userChat.name,
                    ),
                  ),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  ColorConstants.greyColor2.withOpacity(0.5)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: userChat.image,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.account_circle_rounded,
                      size: 50,
                    ),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userChat.name,
                            maxLines: 1,
                            style: const TextStyle(
                                color: ColorConstants.primaryColor,
                                fontSize: 17),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: buildListMessage(),
                        ),
                        buildLoading(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
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
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$userId");
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatStream(groupChatId, 20),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  print(groupChatId);
                  print("sssssssssssssssssssss$listMessage");
                  if (listMessage.isNotEmpty) {
                    if (snapshot.data?.docs[0].get("idFrom") == currentUserId) {
                      return Row(
                        children: [
                          Text(
                              chatProvider
                                          .getLastMessage(
                                              snapshot.data?.docs[0])
                                          .length >=
                                      10
                                  ? "Ban: ${chatProvider.getLastMessage(snapshot.data?.docs[0]).substring(1, 10)}..."
                                  : "Ban: ${chatProvider.getLastMessage(snapshot.data?.docs[0])}",
                              style: const TextStyle(color: Colors.grey)),
                          const Spacer(),
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
                                  ? "${chatProvider.getLastMessage(snapshot.data?.docs[0]).substring(1, 15)}..."
                                  : chatProvider
                                      .getLastMessage(snapshot.data?.docs[0]),
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 10),
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
                    return const SizedBox();
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.themeColor,
                    ),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.themeColor,
              ),
            ),
    );
  }
}
