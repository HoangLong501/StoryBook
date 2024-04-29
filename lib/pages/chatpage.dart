import 'package:chat_app_flutter/service/database.dart';
import 'package:chat_app_flutter/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'home.dart';
class ChatPage extends StatefulWidget {
  String name ,profile , username , username2;
   ChatPage({super.key, required this.name , required this.profile , required this.username , this.username2=""});
  @override
  State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  String? myUserName,myPhone,myName,myEmail,messageId,chatRoomId;
  Stream? messageStream;

    getTheSharedPref() async {
    myUserName = await SharedPreferenceHelper().getUserName();
    myPhone = await SharedPreferenceHelper().getUserPhone();
    myName = await SharedPreferenceHelper().getDisPlayName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    if(widget.username2!=""){
      chatRoomId = getChatRoomIdUserName(widget.username.toUpperCase(), myUserName!.toUpperCase());
    }else{
      chatRoomId = getChatRoomIdUserName(widget.username.toUpperCase(), myUserName!.toUpperCase());
    }
    setState(() {
    });
  }
  onTheLoad()async{
    await getTheSharedPref();
    await getAndSetMessage();
    setState(() {

    });
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
  Widget chatMessageTitle(String message , bool sendByMe){
    return Row(
      mainAxisAlignment: sendByMe? MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
                  bottomRight: sendByMe?Radius.circular(0):Radius.circular(24),topRight: Radius.circular(24),
                  bottomLeft: sendByMe ? Radius.circular(24):Radius.circular(0),
              ),color: sendByMe? Colors.cyan.shade100:Colors.cyan.shade50
              ),
              child: Text(message, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black),),
            ),
        ),
      ],
    );
  }

  Widget chatMessage(){
    return StreamBuilder(
        stream: messageStream,
        builder: (context , AsyncSnapshot snapshot){
          return snapshot.hasData? ListView.builder(
              padding: EdgeInsets.only(bottom: 90,top: 130),
              itemCount: snapshot.data.docs.length,
              reverse: true,
              itemBuilder:(context,index){
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                return chatMessageTitle(documentSnapshot["message"], myUserName==documentSnapshot["sendBy"]);
              }
          ):Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }
  getAndSetMessage() async {
    if (chatRoomId != null) {
      messageStream = await DatabaseMethods().getChatRoomMessage(chatRoomId!);
      setState(() {});
    }
  }
  addMessage(bool sendMess ){
    if(messageController.text!=""){
      String mess = messageController.text;
      messageController.text="";

      DateTime now = DateTime.now();
      String timeNow =DateFormat('h:mma').format(now);

      Map<String,dynamic> messInfoMap ={
        "message":mess,
        "sendBy":myUserName,
        "ts":timeNow,
        "time":FieldValue.serverTimestamp(),
        "phone":myPhone,
      };

      DatabaseMethods().addMessage(chatRoomId!, messInfoMap).then((value){
        Map<String,dynamic> lastMessageInfoMap={
          "LastMessage":mess,
          "LastMessageSendTs":timeNow,
          "Time":FieldValue.serverTimestamp(),
          "LastMessageSendBy":myUserName,
        };
        DatabaseMethods().updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
        if(sendMess){
          messageId=null;
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Stack(
        children: [
          // Container chứa danh sách tin nhắn
          Container(
            margin: EdgeInsets.only(top: 80),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: chatMessage(),
          ),
          // Phần tiêu đề
          Padding(
            padding: EdgeInsets.only(left: 10,top: 40),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
                ),
                SizedBox(width: 10),
                Text(widget.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28, color: Colors.white)),
              ],
            ),
          ),
          // Container chứa input text và button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '   Type a message...',
                    hintStyle: TextStyle(color: Colors.black45),
                    suffixIcon: GestureDetector(
                        onTap: (){
                          addMessage(true);
                        },
                        child: Icon(Icons.send)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
