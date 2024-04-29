import 'package:chat_app_flutter/pages/chatpage.dart';
import 'package:chat_app_flutter/pages/social.dart';
import 'package:chat_app_flutter/service/database.dart';
import 'package:chat_app_flutter/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  bool search = false;
  String? myName , myPhone,myUserName,myEmail;
  Stream? chatRoomStream;
  getTheSharedPref()async{
  myName=await SharedPreferenceHelper().getDisPlayName();
  myPhone=await SharedPreferenceHelper().getUserPhone();
  myUserName=await SharedPreferenceHelper().getUserName();
  myEmail=await SharedPreferenceHelper().getUserEmail();
  setState(() {
  });
  }
  onTheLoad()async{
    await getTheSharedPref();
    chatRoomStream = await DatabaseMethods().getChatRooms();
    setState(() {
    });
  }
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, AsyncSnapshot snapshot) {
        //print("StreamBuilder is rebuilt");
          return snapshot.hasData ?
           //Text("Có snapshot"
          ListView.builder(
              key: ValueKey("chatRoomListView"),
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context,index){
                DocumentSnapshot ds=snapshot.data.docs[index];
                if(ds.data()!=null){
                  return ChatRoomTitle(chatRoomId: ds.id, lastMessage: ds["LastMessage"],
                        myUsername:myUserName!, time: ds["LastMessageSendTs"]);
                }else {
                  return Text("Khoong co document");
                }
              }
          ):Center(child: CircularProgressIndicator(),);
            },
          );
  }
  @override
  void initState() {
    super.initState();
    onTheLoad();
  }
  String getChatRoomIdUserName(String a, String b) {
    if (a.compareTo(b) > 0) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  var queryResultSet =[];
  var tempSearchStore=[];
  initSearch(String value){
    if (value.isEmpty){
      setState(() {
        queryResultSet=[];
        tempSearchStore=[];
      });
    }
    setState(() {
      search=true;
    });
    if (queryResultSet.isEmpty) {
      DatabaseMethods().search(value).then((QuerySnapshot docs){
        for(int i = 0; i < docs.docs.length; i++){
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      for (var element in queryResultSet) {
        // Thực hiện tìm kiếm không chỉ giới hạn đến ký tự đầu tiên
        if (element['Username'].toLowerCase().contains(value.toLowerCase())) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SingleChildScrollView(
          // margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
          child: Column(
            children: [
              Padding(
                   padding: EdgeInsets.only(left: 20 , right: 20 , top: 40 , bottom: 20),
                   child:  Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       search? Expanded(
                           child: TextField(
                             decoration: InputDecoration(
                                 border: InputBorder.none,
                                  hintText: "Search User",
                                hintStyle: TextStyle(color: Colors.black38,fontSize: 20,fontWeight: FontWeight.w500),
                             ),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),
                             onChanged: (value){
                               initSearch(value.toUpperCase());
                             },
                           ),
                       ):
                       GestureDetector(
                         onTap: (){
                           Navigator.pushReplacement(
                               context,
                               MaterialPageRoute(builder: (context) => Social()));
                         },
                         child: Row(
                           children: [
                             Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white,),
                             Text("Home" , style: TextStyle(
                                 color: Colors.white,fontSize: 24,fontWeight: FontWeight.w500),
                             ),
                           ],
                         ),
                       ),
                       GestureDetector(
                         onTap: (){
                           search=true;
                           setState(() {
                           });
                         },
                         child: Container(
                           padding: EdgeInsets.all(6),
                           child: search ?
                               GestureDetector(
                                 onTap: (){
                                   search=false;
                                   setState(() {
                                   });
                                 },
                                 child: Icon(Icons.close_sharp , color: Colors.white,),
                               )
                           :Icon(Icons.search_outlined , color: Colors.white,)
                         ),
                       ),
                     ],
                   ),
                 ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                height: search? MediaQuery.of(context).size.height/1.19 : MediaQuery.of(context).size.height/1.15,
                decoration: BoxDecoration(
                  color: Colors.white ,
                  borderRadius: BorderRadius.circular(10)
                ),
                child:
                   search ?ListView(
                     padding: EdgeInsets.only(left: 10,right: 10),
                     primary: false,
                     shrinkWrap: true,
                     children:
                       tempSearchStore.map((element){
                         return buildResultCard(element);
                       }).toList()
                   ):chatRoomList(),
                ),
            ],
          ),
      ),
    );
  }
  Widget buildResultCard(data){
    return GestureDetector(
      onTap: ()async{
        search=false;
        setState(() {
        });
        var chatRoomId= getChatRoomIdUserName(myUserName!.toUpperCase(),data["Username"] );
        print(myUserName);
        print(data["Username"]);
        Map<String , dynamic> chatRoomInfoMap={
          "user":[myUserName?.toUpperCase(),data["Username"]],
        };
        await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        print(chatRoomId);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ChatPage(name: data["Name"], profile: data["Phone"], username: data["Username"])));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSPxliccSvodnSAgl3UaJdMWFigduYjlk0lQ&usqp=CAU").image,
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data["Name"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                    SizedBox(height: 10,),
                    Text(data["Username"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class ChatRoomTitle extends StatefulWidget {
  final String chatRoomId ,lastMessage ,  myUsername , time;
  const ChatRoomTitle({super.key , required this.chatRoomId,required this.lastMessage,required this.myUsername,required this.time});
  @override
  State<ChatRoomTitle> createState() => _ChatRoomTitleState();
}
class _ChatRoomTitleState extends State<ChatRoomTitle> {
  String name="",username="",id="",phone="";

  String getUsernameFromChatRoomId(String chatRoomId, String myUsername) {
    List<String> parts = chatRoomId.split("_");
    String otherUsername = parts.firstWhere((element) => element != myUsername);
    return otherUsername;
  }
  getThisUserInfo() async {
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username.toUpperCase());
    if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
      name = '${querySnapshot.docs[0]["Name"]}';
      username = '${querySnapshot.docs[0]["Username"]}';
      id = '${querySnapshot.docs[0]["ID"]}';
      phone = '${querySnapshot.docs[0]["Phone"]}';
    }
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    username = getUsernameFromChatRoomId(widget.chatRoomId, widget.myUsername.toUpperCase());
    getThisUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //print(username);
        //print(widget.myUsername.toUpperCase());
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>
            ChatPage(name:name , profile:phone , username:username , username2:widget.myUsername.toUpperCase() ,)));
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
              child:  Text(username.substring(0,2) , style: TextStyle(fontWeight: FontWeight.w900,fontSize: 30,color: Colors.white),),
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
                      Text(username, style: TextStyle(color: Colors.black,fontSize: 20 , fontWeight: FontWeight.w500),),
                    ],
                  ),
                  Text(widget.lastMessage,overflow:TextOverflow.ellipsis, style: TextStyle(color: Colors.black45,fontSize: 18),)
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20,top: 10),
                child: Text(widget.time , style: TextStyle(color: Colors.black45,fontSize: 16),))
          ],
        ),
      ),
    );
  }
}
