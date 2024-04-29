import 'dart:math';

import 'package:chat_app_flutter/pages/profile.dart';
import 'package:chat_app_flutter/pages/social.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/shared_pref.dart';
class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  String? myName ,idUser;
  getTheSharedPref()async{
    myName=await SharedPreferenceHelper().getDisPlayName();
    idUser = await SharedPreferenceHelper().getIdUser();
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    getTheSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 14,top: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap :(){
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>
                                Social()));
                          },
                          child: Icon(Icons.arrow_back_outlined , size: 30,)),
                      SizedBox(width:20 ,),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search User",
                            hintStyle: TextStyle(color: Colors.black38,fontSize: 20,fontWeight: FontWeight.w500),
                          ),style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),
                          onChanged: (value){
            
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 14,top: 20 ,right: 14),
                  child: Column(
                    children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Gần đây", style: TextStyle(fontSize: 24 , fontWeight: FontWeight.w700),),
                           Text("Xem tất cả" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w400 , color: Colors.blueAccent),),
                         ],
                       ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('user').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Something went wrong'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(), // Đặt physics là NeverScrollableScrollPhysics()
                      shrinkWrap: true, // Đặt shrinkWrap là t
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Lấy dữ liệu từ tài liệu tại vị trí index
                        var user = snapshot.data!.docs[index];
                        //print(myName);
                        if(user["Username"] !=myName){
                          return UserList(idUser: user["IdUser"] , nameUser: user["Username"],);
                        }else{
                          return SizedBox.shrink();
                        }
                      },
                    );
                  },
                ),
            
              ],
            ),
          ),
    );
  }
}

class UserList extends StatefulWidget {
  final String idUser , nameUser;
  const UserList({super.key , required this.idUser , required this.nameUser});
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
    String? myName,myPhone , myId;
  getTheSharedPref()async{
    myName=await SharedPreferenceHelper().getDisPlayName();
    myId=await SharedPreferenceHelper().getIdUser();
    myPhone=await SharedPreferenceHelper().getUserPhone();
    setState(() {
    });
  }

    @override
  void initState() {
    super.initState();
    getTheSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        //var newsFeedId= getChatRoomIdUserName(myUserName!.toUpperCase(),data["Username"] );
        print(myId);
        print(widget.idUser);
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>
             Profile(idUser1: myId!, idUser2: widget.idUser)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Color.fromRGBO(
                randomBetween(0, 256),
                randomBetween(0, 256),
                randomBetween(0, 256),
                1.0, // Độ trong suốt (1.0 là màu đậm, 0.0 là màu trong suốt)
              ),
              child:  Text(widget.nameUser.substring(0,2) , style: TextStyle(fontWeight: FontWeight.w900,fontSize: 30,color: Colors.white),),
            ),
            SizedBox(width: 14,),
            SizedBox(
              width: MediaQuery.of(context).size.width/2.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.nameUser, style: TextStyle(color: Colors.black,fontSize: 20 , fontWeight: FontWeight.w500),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
