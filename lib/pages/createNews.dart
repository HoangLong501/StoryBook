import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:chat_app_flutter/pages/social.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../service/database.dart';
import '../service/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
class CreateNews extends StatefulWidget {
  const CreateNews({super.key});
  @override
  State<CreateNews> createState() => _CreateNewsState();
}

class _CreateNewsState extends State<CreateNews> {
  File? _selectedImage;
  String? idUser , username , newsFeedId , urlImage;

  TextEditingController contentController = TextEditingController();

  Future _pickImageGallery()async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnImage!.path);
    });
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
        urlImage = imageUrl;
    }
  }
  String getChatRoomIdUserName(String a, String b) {
    if (a.compareTo(b) > 0) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  getTheSharedPref() async {
    username = await SharedPreferenceHelper().getDisPlayName();
    idUser = await SharedPreferenceHelper().getIdUser();
    setState(() {
    });
  }
  onTheLoad()async{
    await getTheSharedPref();
    //await getAndSetMessage();
    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
    onTheLoad();
  }
  Future<void> addNews(bool send) async {
    if (contentController.text != "" ) {
      DateTime now = DateTime.now();
      String id=randomAlphaNumeric(10);
      Timestamp timestamp = Timestamp.fromDate(now);
      String timeNow = DateFormat('h:mma').format(now);
      List react=[];
      Map<String, dynamic> newsInfoMap = {
        "ID":id,
        "userName": username,
        "content": contentController.text,
        "image": urlImage,
        "ts": timeNow,
        "newTimestamp":timestamp,
        "react": react,
        "reactCount":react.length
      };
      try {
        // Thêm newsfeed mới vào Firestore và lấy DocumentReference của nó.
        DocumentReference? docRef = await DatabaseMethods().addNews(id,newsInfoMap);
        if (docRef != null) {
          String newsId = docRef.id;
          // Lấy danh sách tin tức của người dùng hiện tại.
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('user').doc(idUser!).get();
          Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
          List<String> newsList = List.from(userData?['News'] ?? []);
          // Thêm newsId mới vào đầu danh sách tin tức của người dùng.
          newsList.insert(0, newsId);
          // Cập nhật danh sách tin tức của người dùng với danh sách mới.
          await FirebaseFirestore.instance.collection('user').doc(idUser!).update({
            'News': newsList,
          });
          print('Đã thêm newsfeed mới và cập nhật danh sách tin tức của người dùng thành công.');
        } else {
          print('Đã xảy ra lỗi khi thêm tin tức');
        }
      } catch (error) {
        print('Đã xảy ra lỗi khi thêm tin tức hoặc cập nhật danh sách tin tức của người dùng: $error');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 26,left: 20),
            child: Row(
              children: [
                GestureDetector(
                    onTap:(){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Social()));
                    },
                    child: Icon(Icons.arrow_back_ios_outlined)),
                Text("Tạo bài viết",style: TextStyle(fontSize: 18),),
                SizedBox(width: 160,),
                SizedBox(
                  child: Container(
                    height: 34,
                      width: 80,
                      decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                          padding: EdgeInsets.only(left:12 ,top: 4 ),
                          child: GestureDetector(
                              onTap: () async{
                                if (_selectedImage != null) {
                                  await uploadImage(_selectedImage!); // Tải hình ảnh lên trước khi thêm bài viết
                                }
                                   addNews(true);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => Social()));
                              },
                              child: Text("ĐĂNG",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black45),)))),
                ),
              ],
            ),
          ),
           Padding(
               padding: EdgeInsets.only(left: 16,top: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: Image.network("https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png").image,
                      radius: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10,top: 4),
                            child: Text(username != null ? username!.toUpperCase() : "", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10,top: 4),
                                decoration: BoxDecoration(color: Colors.lightBlueAccent.shade100 ,borderRadius: BorderRadius.circular(6)),
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: RichText(
                                      text: TextSpan(
                                        children: <InlineSpan>[
                                          WidgetSpan(
                                            child: Icon(Icons.lock_clock_outlined,color: Colors.blue,size: 18,),
                                          ),
                                          TextSpan(
                                            text: 'Chỉ mình tôi ',
                                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.blue)
                                          ),
                                          WidgetSpan(
                                            child: Icon(Icons.arrow_drop_down,color: Colors.blue,size: 18,),
                                          ),
                                        ],
                                      ),
                                    ),
                                )
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 10,top: 4),
                                decoration: BoxDecoration(color: Colors.lightBlueAccent.shade100 ,borderRadius: BorderRadius.circular(6)),
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Icon(Icons.add,color: Colors.blue,size: 18,),
                                        ),
                                        TextSpan(
                                            text: 'Album',
                                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.blue)
                                        ),
                                        WidgetSpan(
                                          child: Icon(Icons.arrow_drop_down,color: Colors.blue,size: 18,),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 10,top: 4),
                                decoration: BoxDecoration(color: Colors.lightBlueAccent.shade100 ,borderRadius: BorderRadius.circular(6)),
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Icon(Icons.settings_applications,color: Colors.blue,size: 18,),
                                        ),
                                        TextSpan(
                                            text: 'Tắt',
                                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.blue)
                                        ),
                                        WidgetSpan(
                                          child: Icon(Icons.arrow_drop_down,color: Colors.blue,size: 18,),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ),

                          ],
                        ),
                      ],
                    ),
                  ],
                ),
           ),
           Padding(
             padding: EdgeInsets.all(10),
             child: TextField(
                maxLines: _selectedImage!=null ? 4: 16,
                controller: contentController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 24 ,color: Colors.black38),
                  hintText:  "Bạn đang nghĩ gì ? ",
                ),
              ),
           ),
          _selectedImage!=null ? Expanded(
            child: Image.file(_selectedImage!),
          ) : Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(Icons.photo , size: 40,color: Colors.green.shade300,),
                          SizedBox(width: 20,),
                          Text("Ảnh/Video" ,style: TextStyle(fontSize: 24),),
                        ],
                      ),
                    ),
                    onTap: (){
                      _pickImageGallery();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.people_alt_outlined , size: 40,color: Colors.blueAccent,),
                        SizedBox(width: 20,),
                        Text("Gắn thẻ người khác" ,style: TextStyle(fontSize: 24),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_emotions_outlined , size: 40,color: Colors.orangeAccent,),
                        SizedBox(width: 20,),
                        Text("Cảm xúc/Hoạt động" ,style: TextStyle(fontSize: 24),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.location_pin , size: 40,color: Colors.redAccent,),
                        SizedBox(width: 20,),
                        Text("Check in" ,style: TextStyle(fontSize: 24),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.video_camera_back_outlined , size: 40,color: Colors.purpleAccent,),
                        SizedBox(width: 20,),
                        Text("Video trực tiếp" ,style: TextStyle(fontSize: 24),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.sort_by_alpha_outlined , size: 40,color: Colors.cyan,),
                        SizedBox(width: 20,),
                        Text("Màu nền" ,style: TextStyle(fontSize: 24),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_rounded , size: 40,color: Colors.green,),
                        SizedBox(width: 20,),
                        Text("Camera" ,style: TextStyle(fontSize: 24),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.gif , size: 40,color: Colors.teal,),
                        SizedBox(width: 20,),
                        Text("File GIF" ,style: TextStyle(fontSize: 24),),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
