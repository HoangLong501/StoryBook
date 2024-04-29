import 'package:chat_app_flutter/pages/searchuser.dart';
import 'package:chat_app_flutter/service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  String idUser1 , idUser2;
   Profile({super.key , required this.idUser1 , required this.idUser2});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool add=false;
  String? name;
  String getNewsfeedIdUserName(String a, String b) {
    if (a.compareTo(b) > 0) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
   setName()async{
    final QuerySnapshot snapshot= await DatabaseMethods().getUserById(widget.idUser2);
    name="${snapshot.docs[0]["Username"]}";
  }
  onTheLoad()async{
    await setName();
    //await getCombinedNewsfeeds(idUser!);
    //await getAndSetMessage();
    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              // Text(widget.username + "Name Nguoi dung"),
              // Text(widget.username2 + "Name ProFile"),
              Padding(
                  padding: EdgeInsets.only(top: 40 ,left: 20 , right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap:(){
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>
                              SearchUser()));
                        },
                        child: Icon(Icons.arrow_back ,size: 30,)),
                    Icon(Icons.search_outlined ,size: 30,)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 60),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: Image.network("https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png",).image,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(name!=null ? name!:"Ten hien thi" , style: TextStyle(fontSize: 34),),

              ),
              Padding(
                  padding: EdgeInsets.only(top: 60,left: 40,right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap:()async{
                          var newsFeedId = getNewsfeedIdUserName(widget.idUser2, widget.idUser1);
                          final snapshot = await FirebaseFirestore.instance.collection('connections').doc(newsFeedId).get();
                          if(snapshot.exists){
                            add=true;
                            print("da ket ban");
                            return ;
                          }else{
                            await FirebaseFirestore.instance.collection('connections').doc(newsFeedId).set({
                              'user': [widget.idUser2,widget.idUser1]
                            });
                          }
                        },
                        child: Container(
                          width: 140,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.blueAccent
                          ),
                          child: Center(child: Text( add!=true?"Thêm bạn bè":"Hủy kết bạn", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)),
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey
                        ),
                        child: Center(child: Text("Nhắn tin", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 20),)),
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
