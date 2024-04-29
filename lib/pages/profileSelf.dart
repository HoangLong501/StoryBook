import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:chat_app_flutter/service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../service/shared_pref.dart';
import 'package:firebase_storage/firebase_storage.dart';
class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}
class _MyProfileState extends State<MyProfile> {
  FToast? fToast;
  TextEditingController usernameController = TextEditingController();
  String? username , idUser , imageUrlAvatar;
  File? _selectedImage;

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("This is a Custom Toast"),
        ],
      ),
    );
    fToast!.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
    // fToast!.showToast(
    //     child: toast,
    //     toastDuration: Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         child: child,
    //         top: 16.0,
    //         left: 16.0,
    //       );
    //     });
  }
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast!.init(context);
    onTheLoad();
  }
  Future _pickImageGallery()async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnImage!.path);
      //print(_selectedImage);
    });
    // imageUrlAvatar=await uploadImage(_selectedImage!);
    // print(_selectedImage);
  }
  Future uploadImage(File image) async {
    String nameImage = randomAlphaNumeric(20);
    // Tạo một tham chiếu đến vị trí bạn muốn tải hình ảnh lên
    final ref = FirebaseStorage.instance.ref().child('$username/images/$nameImage.jpg');
    // Tải hình ảnh lên Firebase Storage
    final taskSnapshot = await ref.putFile(image);
    // Lấy URL của hình ảnh
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    if (imageUrl != null) {
      imageUrlAvatar = imageUrl;
    }
  }

  getTheSharedPref() async {
    username = await SharedPreferenceHelper().getUserName();
    idUser = await SharedPreferenceHelper().getIdUser();
    imageUrlAvatar = await SharedPreferenceHelper().getImageUser();
    //imageUrlAvatar ??= null;
    print(idUser);
    print(username);
    print(imageUrlAvatar);
    setState(() {
    });
  }
  onTheLoad()async{
    await getTheSharedPref();
    if(mounted){
      setState(() {
      });
    }
  }
  updateProfile()async{
    if(_selectedImage!=null && usernameController.text!=""){
      await uploadImage(_selectedImage!);
      Map<String,dynamic> profileInfoMap={
        "Name":usernameController.text,
        "imageAvatar":imageUrlAvatar,
      };
      DatabaseMethods().updateUserDetail(idUser!, profileInfoMap);
      await SharedPreferenceHelper().saveUserName(usernameController.text);
      await SharedPreferenceHelper().saveImageUser(imageUrlAvatar!);
      _showToast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 40 ,left: 20,right: 20),
            child: Row(
              children: [
                GestureDetector(
                    onTap:(){
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back,size: 30,)),
                SizedBox(width: 10,),
                Text("Chỉnh sửa trang cá nhân" , style: TextStyle(
                  fontSize: 20
                ),)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40 ,left: 20,right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ảnh đại diện" , style: TextStyle(
                    fontSize: 20 ,fontWeight: FontWeight.w700
                ),),
                SizedBox(width: 10,),
                TextButton(
                  onPressed: (){
                    _pickImageGallery();
                    setState(() {
                    });
                  },
                    child: Text("Chỉnh sửa" , style: TextStyle(
                        fontSize: 18,color: Colors.blueAccent
                    ),)
                  ),
              ],
            ),
          ),
          _selectedImage==null ? Padding(
              padding: EdgeInsets.only(top: 16),
            child: imageUrlAvatar !=null ? CircleAvatar(
              radius: 60,
               backgroundImage: Image.network(imageUrlAvatar!).image,
            ): CircleAvatar(
              radius: 70,
              backgroundColor: Colors.cyan,
              child: Text(username!=null ? username!.substring(0,2) : "Lỗi tên") ,
            ),
          ):Padding(
            padding: EdgeInsets.only(top: 16),
            child:CircleAvatar(
              radius: 70,
              backgroundImage:Image.file(_selectedImage!).image,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40 ,left: 20,right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Tên người dùng" , style: TextStyle(
                    fontSize: 20 ,fontWeight: FontWeight.w700
                ),),
                SizedBox(width: 10,),
                Text(username!=null ? username! : "Lỗi tên" , style: TextStyle(
                      fontSize: 18,color: Colors.blueAccent
                  ),),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40 ,left: 20,right: 20),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: "Sửa tên",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            )
          ),
          Padding(padding: EdgeInsets.all(20),
          child: MaterialButton(
            color: Colors.grey.shade200,
            onPressed: (){
              if(imageUrlAvatar!=null && imageUrlAvatar!=""){
                updateProfile();
              }

            },
            child: Text("Cập nhật"),
          ),
          ),
        ],
      ),
    );
  }
}
