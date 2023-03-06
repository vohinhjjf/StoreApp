import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/customer_model.dart';
import 'package:store_app/providers/auth_provider.dart';

class IdWithAvatar extends StatefulWidget {
  @override
  _IdWithAvatarState createState() => _IdWithAvatarState();
}
class _IdWithAvatarState extends State<IdWithAvatar> {
  var user = FirebaseAuth.instance.currentUser;
  PickedFile? imageFile ;
  final ImagePicker picker = ImagePicker();
  var auth = AuthProvider();
  final _repository = Repository();
  var id ='';

  @override
  initState() {
    getID();
    super.initState();
  }
  getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('ID').toString();
  }
  getImage() async {

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Stack(children: [
        buildImage(mPrimaryColor),
        Positioned(
          right: 0,
          top: 7,
          child: buildEditIcon(context,mPrimaryColor),
        )
      ])
    );
  }

  // Builds Profile Image
  Widget buildImage(Color color) {
    var image = imageFile == null
    ?AssetImage("assets/images/user.jfif")
        :FileImage(File(imageFile!.path));
    return CircleAvatar(
      radius: 95,
      backgroundColor: color,
      child: FutureBuilder(
        future: _repository.getUserById(user!.uid),
        builder: (BuildContext context, AsyncSnapshot<CustomerModel> snapshot) {
          if(snapshot.hasData){
            image = NetworkImage(snapshot.data!.image);
            return CircleAvatar(
              backgroundImage: image as ImageProvider,
              radius: 90,
            );
          }
          else {
            return const CircleAvatar(
              backgroundImage: AssetImage("assets/images/user.jfif"),
              radius: 90,
            );
          }
        },
      )
    );
  }

  // Builds Edit Icon on Profile Picture
  Widget buildEditIcon(BuildContext context,Color color) => buildCircle(
      all: 0,
      child:
      IconButton(
        onPressed: () {
          //print(imageFile!.path);
          showModalBottomSheet(
            context: context,
            builder: ((builder) => bottomSheet(context)),
          );
        },
        icon: Icon(
          Icons.edit,
          color: color,
          size: 20,
        ),
      ),
      );

  // Builds/Makes Circle for Edit Icon on Profile Picture
  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
            padding: EdgeInsets.all(all),
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color(0x99FFFFFF),
                  Colors.white
                ]),
                borderRadius: BorderRadius.circular(45),
                border:
                Border.all(color: mPrimaryColor, width: 2)),
            child: child,
          ));


  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text("Chọn ảnh hoặc video", style: TextStyle(fontSize: footnote)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () => _openGallary(context, ImageSource.camera),
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera", style: TextStyle(fontSize: footnote))),
              TextButton.icon(
                  onPressed: () => _openGallary(context, ImageSource.gallery),
                  icon: const Icon(Icons.collections),
                  label: const Text("Thư viện", style: TextStyle(fontSize: footnote)))
            ],
          )
        ],
      ),
    );
  }

  void _openGallary(BuildContext context, ImageSource source) async {
    final media = await picker.getImage(source: source);

    auth.addAvatar(media!);
    setState(() {
      imageFile = media;
    });

    Navigator.of(context).pop();
  }

}
