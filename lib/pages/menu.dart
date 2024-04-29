import 'package:chat_app_flutter/pages/profile.dart';
import 'package:chat_app_flutter/pages/profileSelf.dart';
import 'package:chat_app_flutter/pages/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/shared_pref.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String? username,idUser;

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }
  getTheSharedPref() async {
    username = await SharedPreferenceHelper().getDisPlayName();
    idUser = await SharedPreferenceHelper().getIdUser();
    print(idUser);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top:38.0 , left: 10),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back , size: 30,)),
                  SizedBox(width: 20,),
                  Text("MENU" , style: TextStyle(fontSize: 20),)
                ],
              ),
              Padding(
                padding:  EdgeInsets.only(left: 10 , top: 60),
                child: GestureDetector(
                  onTap: (){
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context)=>Profile()));
                  },
                  child: Row(
                    children: [
                       CircleAvatar(
                          backgroundImage: Image.network("https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png",width: 60,height: 60,).image,
                          radius: 30,
                        ),
                      SizedBox(width: 20,),
                      Text(username!=null?username! :"Invalid NAME" , style: TextStyle(fontSize: 22),),
                      SizedBox(width: 150,),
                      Icon(Icons.arrow_drop_down_circle_outlined)
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.zero,

                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 30,
                    width: MediaQuery.of(context).size.width/1.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade400
                    ),
                    child: MaterialButton(
                      onPressed: (){
                        print("Nhan vao chuyen huong");
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                      },
                      child: Text("Chỉnh sửa trang cá nhân" , style:
                        TextStyle(fontSize: 18),),
                    ),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30 ,left: 10,right: 10),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/2.4,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,left:20 ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.groups,size: 30,color: Colors.blueAccent,),
                            Text("Nhóm",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width/2.4,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,left:20 ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.settings_backup_restore,size: 30,color: Colors.blueAccent,),
                            Text("Kỷ niệm",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10 ,left: 10,right: 10),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/2.4,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,left:20 ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.live_tv_outlined,size: 30,color: Colors.blueAccent,),
                            Text("Video",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width/2.4,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,left:20 ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.people,size: 30,color: Colors.blueAccent,),
                            Text("Bạn bè",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10 ,left: 10,right: 10),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/2.4,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,left:20 ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.bookmark_border,size: 30,color: Colors.blueAccent,),
                            Text("Đã lưu",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width/2.4,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,left:20 ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.storefront_outlined,size: 30,color: Colors.blueAccent,),
                            Text("Marketplace",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10 ,left: 10,right: 10),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/2.4,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,left:20 ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.dynamic_feed_sharp,size: 30,color: Colors.blueAccent,),
                            Text("Bảng feed",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width/2.4,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,left:20 ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.card_giftcard_sharp,size: 30,color: Colors.blueAccent,),
                            Text("Hẹn hò",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 80),
                width: MediaQuery.of(context).size.width/1.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade400
                ),
                child: MaterialButton(
                    onPressed: (){
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context)=>SignIn()));
                    },
                  child: Text("ĐĂNG XUẤT"),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
