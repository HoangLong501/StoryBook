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
class Social3 extends StatefulWidget {
  const Social3({super.key});
  @override
  State<Social3> createState() => _SocialState();
}
class _SocialState extends State<Social3> {
  final ScrollController _listViewController =ScrollController();
  final GlobalKey _topKey = GlobalKey();
  String? username , idUser;
  Stream? newsfeedStream;
  getTheSharedPref() async {
    username = await SharedPreferenceHelper().getDisPlayName();
    idUser = await SharedPreferenceHelper().getIdUser();
    print(idUser);
    setState(() {
    });
  }
  onTheLoad()async{
    await getTheSharedPref();
    newsfeedStream = DatabaseMethods().getCombinedNewsfeedsStream(idUser!);
    //newsfeedStream = DatabaseMethods().getCombinedNewsfeedsStream("VUIVE_202404051810");
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();

    onTheLoad();
  }
  Widget chatRoomList() {
    return StreamBuilder(
      stream: newsfeedStream,
      builder: (context, AsyncSnapshot snapshot) {
        print("StreamBuilder is rebuilt");
        return snapshot.hasData ?
        //Text("Có snapshot"
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              final ds = snapshot.data![index];
              if(ds.data()!=null){
                return NewsfeedDetail(username: ds["userName"], content: ds["content"], imageUrl: ds["image"] , time: ds["ts"],);
              }else {
                return Text("Khoong co document");
              }
            }
        ):Center(child: CircularProgressIndicator(),);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        primary: true,
        slivers: [
          // SliverAppBar nếu bạn muốn có thanh appbar cuộn cùng
          SliverList(
            key: _topKey,
            delegate: SliverChildListDelegate([
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("facebook" ,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400,color: Colors.blue),),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width/4,),
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
                  SizedBox(height: 20),
                  Row( // Không cuộn ở đa
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8,right: 8),
                        child: Icon(Icons.home_outlined ,size: 40,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8,right: 8),
                        child: Icon(Icons.tv_outlined ,size: 40,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8,right: 8),
                        child: Icon(Icons.people_alt_outlined ,size: 40,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8,right: 8),
                        child: Icon(Icons.videogame_asset_rounded ,size: 40,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8,right: 8),
                        child: Icon(Icons.notifications_none_outlined ,size: 40,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8,right: 8),
                        child: Icon(Icons.menu ,size: 40,),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: CircleAvatar(
                          backgroundImage: Image.network("https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png").image,
                          radius: 30,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          height: 48,
                          width: MediaQuery.of(context).size.width/1.5,
                          padding: EdgeInsets.only(left: 16),
                          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                              color:Colors.grey.shade50
                          ),
                          child:TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Bạn đang nghĩ gì ?",
                              hintStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w800),
                            ),
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8,right: 18),
                        child: Icon(Icons.image ,size: 40,),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ]),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160.0,
                    child: Card(
                      child: Center(
                        child: Text('Card ${index + 1}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 10,
              decoration: BoxDecoration(color: Colors.grey),
            ),
          ),
          SliverFillRemaining(
            child: StreamBuilder(
              stream: newsfeedStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text("No data available"));
                }
                // Kiểm tra dữ liệu trong snapshot.data
                if (snapshot.data is List<Map<String, dynamic>>) {
                  // Ép kiểu dữ liệu
                  List<Map<String, dynamic>> dataList = snapshot.data;
                  // Sử dụng ListView.builder để hiển thị dữ liệu
                  return ListView.builder(
                    controller: _listViewController,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      // Lấy phần tử từ danh sách
                      Map<String, dynamic> data = dataList[index];
                      // Xử lý dữ liệu để hiển thị
                      return NewsfeedDetail(
                        username: data["userName"],
                        content: data["content"],
                        imageUrl: data["image"],
                        time: data["ts"],
                      );
                    },
                  );
                } else {
                  // Trường hợp dữ liệu không phù hợp
                  return Center(child: Text("Invalid data format"));
                }
              },
            ),

          )
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: () {
            Scrollable.ensureVisible(_topKey.currentContext!,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut);
            _listViewController.animateTo(
              0,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          child: Icon(Icons.arrow_upward),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.home),
              onPressed: () {
                // Xử lý sự kiện khi nhấn vào nút Home

              },
            ),
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.people),
              onPressed: () {
                // Xử lý sự kiện khi nhấn vào nút Search
              },
            ),
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.trending_up),
              onPressed: () {
                // Xử lý sự kiện khi nhấn vào nút Notifications
              },
            ),
          ],
        ),
      ),

    );
  }
}

class NewsfeedDetail extends StatefulWidget {
  String? username , content , imageUrl ,time;
  NewsfeedDetail({super.key , required this.username, required this.content , required this.imageUrl ,required this.time});
  @override
  State<NewsfeedDetail> createState() => _NewsfeedDetailState();
}
class _NewsfeedDetailState extends State<NewsfeedDetail> {
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
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width/3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.thumb_up_alt_outlined),
                        SizedBox(width: 6,),
                        Text("Thích",style: TextStyle(fontSize: 16),)
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

