import 'dart:async';
import 'package:chat_app_flutter/service/database.dart';
import 'package:chat_app_flutter/pages/createNews.dart';
import 'package:chat_app_flutter/pages/searchuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../service/shared_pref.dart';
import 'home.dart';
import 'menu.dart';
class Social2 extends StatefulWidget {
  const Social2({super.key});
  @override
  State<Social2> createState() => _SocialState();
}
class _SocialState extends State<Social2> {
  String? username, idUser;
  int picked = 0;

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  getTheSharedPref() async {
    username = await SharedPreferenceHelper().getDisPlayName();
    idUser = await SharedPreferenceHelper().getIdUser();
    print(idUser);
    setState(() {});
  }

  onTheLoad() async {
    await getTheSharedPref();
    //newsfeedStream = await DatabaseMethods().getNews();
    setState(() {});
  }

  @override
  void dispose() {
    // Ngắt kết nối với stream khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Swipe(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Text("storybook" ,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400,color: Colors.blue),),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8,right: 8),
                        child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateNews()));
                            },
                            child: Icon(Icons.add_circle_outline ,size: 30,)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8,right: 8),
                        child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SearchUser()));
                            },
                            child: Icon(Icons.search_outlined,size: 30,)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8,right: 8),
                        child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home()));
                            },
                            child: Icon(Icons.messenger_outline,size: 30,)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                        picked = 0;
                      });
                    },
                    child: Icon(Icons.home_outlined ,
                      color: picked==0? Colors.blueAccent:Colors.grey,
                    )),
                Text("Home",style: TextStyle(fontSize: 12 ,fontWeight: FontWeight.w700,color: picked==0? Colors.blueAccent:Colors.grey, ),),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                        picked = 1;
                      });
                    },
                    child: Icon(Icons.people ,
                        color: picked==1? Colors.blueAccent:Colors.grey,
                    )),
                Text("Friend's Story",style: TextStyle(fontSize: 12 ,fontWeight: FontWeight.w700,color: picked==1? Colors.blueAccent:Colors.grey, ),),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                        picked = 2;
                      });
                    },
                    child: Icon(Icons.menu_book_rounded ,
                      color: picked==2? Colors.blueAccent:Colors.grey,
                    )),
                Text("Comics",style: TextStyle(fontSize: 12 ,fontWeight: FontWeight.w700,color: picked==2? Colors.blueAccent:Colors.grey, ),),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                        picked = 3;
                      });
                    },
                    child: Icon(Icons.menu ,
                      color: picked==3? Colors.blueAccent:Colors.grey,
                    )),
                Text("Menu",style: TextStyle(fontSize: 12 ,fontWeight: FontWeight.w700,color: picked==3? Colors.blueAccent:Colors.grey, ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewsfeedDetail extends StatefulWidget {
  final String username , content , imageUrl ,time , id;
  final List react;
  const NewsfeedDetail({super.key ,required this.id, required this.username, required this.content , required this.imageUrl ,required this.time ,required this.react});
  @override
  State<NewsfeedDetail> createState() => _NewsfeedDetailState();
}
class _NewsfeedDetailState extends State<NewsfeedDetail> {
  String? idUser;
  bool? react;
  bool clicked =true;
  @override
  void initState() {
    super.initState();
    onTheLoad();
  }
  getTheSharedPref() async {
    idUser = await SharedPreferenceHelper().getIdUser();
    react = await DatabaseMethods().checkUserReact(widget.id!,idUser!);
    if(react!=null){
      clicked=react!;
    }
    print(react);
    setState(() {
    });
  }
  onTheLoad()async{
    await getTheSharedPref();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYAT_UxKCDEO2k6BmW_R4ar8n4FHOm-WUwwHZ4A6VkSA&s").image,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.username!+"" ,
                        style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500) ,),
                      Text(widget.time!+""),
                    ],
                  ),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 10,left: 10,bottom: 10),
                child: Text(widget.content!+"",style: TextStyle(
                    fontSize: 18
                ),)),
            widget.imageUrl !=null ? Expanded(
              child: Image.network(
                widget.imageUrl!,
                fit: BoxFit.fill, // Đảm bảo hình ảnh sẽ phù hợp với không gian đã cung cấp mà không bị méo hoặc căng
              ),
            ):SizedBox(),
            Container(
              height: 24,
              decoration: BoxDecoration(color: Colors.white ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20 ,top: 4),
                child: Row(
                  children: [
                    Icon(Icons.emoji_emotions_outlined ,color: Colors.blueAccent,),
                    SizedBox(width: 6,),
                    Text(widget.react!.length.toString(),style: TextStyle(
                      fontSize: 18,
                    ),),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width/3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        DatabaseMethods().updateNewsfeedReact(widget.id!,idUser! );
                        setState(()  {
                          if(clicked==true){
                            clicked=false;
                          }else {
                            clicked=true;
                          }
                        });
                      },
                      child:Row(
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: clicked ? Colors.blue :Colors.black, // Màu sắc của icon thay đổi dựa trên tương tác
                          ),
                          SizedBox(width: 6,),
                          Text(
                            "Thích",
                            style: TextStyle(
                              fontSize: 16,
                              color:  clicked ? Colors.blue :Colors.black, // Màu sắc của text thay đổi dựa trên tương tác
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width/3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.messenger_outline),
                        SizedBox(width: 6,),
                        Text("Bình luận",style: TextStyle(fontSize: 16),)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width/3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.share_rounded),
                        SizedBox(width: 6,),
                        Text("Chia sẽ",style: TextStyle(fontSize: 16),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 10,
              decoration: BoxDecoration(color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}

