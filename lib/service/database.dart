import 'package:chat_app_flutter/service/shared_pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseMethods {
  Future addUserDetail(String id ,Map<String , dynamic> userInfoMap )async{
    return await FirebaseFirestore.instance
        .collection("user").doc(id)
        .set(userInfoMap);
  }
  Future<void> updateUserDetail(String id, Map<String, dynamic> updatedUserInfoMap) async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .update(updatedUserInfoMap);
      print("Cập nhật thông tin người dùng thành công!");
    } catch (e) {
      print("Lỗi khi cập nhật thông tin người dùng: $e");
    }
  }
  Future<QuerySnapshot> getUserByEmail (String email) async {
    return await FirebaseFirestore.instance
        .collection("user").where("E-mail" , isEqualTo: email).get();
  }
  Future<QuerySnapshot> search(String username) async {
    return await FirebaseFirestore.instance.collection("user").where("SearcchKey",isEqualTo: username.substring(0,1).toUpperCase()).get();
  }
  createChatRoom(String chatRoomId , Map<String , dynamic>chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).get();
    if(snapshot.exists){
      return true;
    } else {
      // Cập nhật thời gian vào map trước khi đặt nó vào Firestore
      return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).set(chatRoomInfoMap);
    }
  }
  Future addMessage(String chatRoomId, Map<String,dynamic> messInfoMap ) async {
    return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("chats").doc().set(messInfoMap);
  }
  createNewsfeed( Map<String , dynamic>newsfeedInfoMap) async {
    final snapshot = await FirebaseFirestore.instance.collection("newsfeed").doc().get();
    if(snapshot.exists){
      return true;
    } else {
      // Cập nhật thời gian vào map trước khi đặt nó vào Firestore
      return FirebaseFirestore.instance.collection("newsfeed").doc().set(newsfeedInfoMap);
    }
  }

  Future<DocumentReference?> addNews(String idNewsfeed, Map<String, dynamic> newsfeedInfoMap) async {
    try {
      // Sử dụng ID tùy chỉnh được cung cấp để thêm dữ liệu vào Firestore.
      DocumentReference docRef = FirebaseFirestore.instance.collection("newsfeed").doc(idNewsfeed);
      await docRef.set(newsfeedInfoMap);
      print('Đã thêm tin tức thành công ');
      // Trả về DocumentReference của tài liệu đã thêm.
      return docRef;
    } catch (e) {
      print("Lỗi khi thêm tin tức vào Firestore: $e");
      // Xử lý lỗi tại đây nếu cần.
      return null;
    }
  }
  updateLastMessageSend(String chatRoomId , Map<String , dynamic>lastMessageInfoMap)  {
    print(chatRoomId);
    return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).update(lastMessageInfoMap);
  }
  Future<QuerySnapshot> getUserInfo(String username)async{
    return await FirebaseFirestore.instance.collection("user").where("Username" , isEqualTo: username).get();
  }
  Future<QuerySnapshot> getUserById(String id)async{
    return await FirebaseFirestore.instance.collection("user").where("IdUser" , isEqualTo: id).get();
  }
  Future<Stream<QuerySnapshot>> getChatRoomMessage(chatRoomId)async{
    return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("chats").orderBy("time",descending: true).snapshots();
  }
  Future<Stream<QuerySnapshot>> getChatRooms()async{
    String? myUserName = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance.collection("chatrooms").orderBy("Time",descending: true)
        .where("user",arrayContains: myUserName!.toUpperCase()).snapshots();
  }

  // Future<Stream<QuerySnapshot>> getNews()async{
  //   return FirebaseFirestore.instance.collection("newsfeed").orderBy("ts",descending: true).snapshots();
  // }
  Stream<QuerySnapshot> getNews() async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("newsfeed")
          .orderBy("ts", descending: true)
          .snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách tin tức: $error');
    }
  }
  Stream<QuerySnapshot> getNewsTrend() async* {
    try {
      print("Có đi vào hàm getNewsTrend");
      // DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
      //
      // // Truy vấn tin tức trong khoảng thời gian 7 ngày gần đây nhất
      // yield* FirebaseFirestore.instance
      //     .collection("newsfeed")
      //     .where("newTimestamp", isGreaterThan: Timestamp.fromDate(sevenDaysAgo))
      //     .orderBy("reactCount", descending: true)
      //     .snapshots();
      yield* FirebaseFirestore.instance
          .collection("newsfeed")
          .orderBy("reactCount", descending: true)
          .snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách tin tức: $error');
    }
  }
  // Future<Stream<QuerySnapshot>> getNewsFriendOnly(String userID)async{
  //   return FirebaseFirestore.instance.collection("newsfeed").orderBy("ts",descending: true).snapshots();
  // }
  // Future<Stream<QuerySnapshot>> getNewsfeed()async{
  //   String? myUserName = await SharedPreferenceHelper().getUserName();
  //   return FirebaseFirestore.instance.collection("newsfeed").orderBy("Time",descending: false)
  //       .where("user",arrayContains: myUserName!.toUpperCase()).snapshots();
  // }
  Stream<List<Map<String, dynamic>>> getCombinedNewsfeedsStream(String currentUserId) async* {
    try {
      Set<String> newsfeedIds = {};
      List<String> connectedUserIds = [];

      // 1. Truy vấn collection 'connections' để lấy danh sách các người dùng đã kết nối với người dùng hiện tại
      QuerySnapshot connectionsSnapshot = await FirebaseFirestore.instance
          .collection('connections')
          .where('user', arrayContains: currentUserId)
          .get();

      // 2. Lấy danh sách người dùng đã kết nối
      for (QueryDocumentSnapshot connectionDoc in connectionsSnapshot.docs) {
        List<String> users = [];
        Map<String, dynamic>? data = connectionDoc.data() as Map<String, dynamic>?;

        if (data != null && data['user'] is List<dynamic>) {
          users = List<String>.from(data['user']);
        }
        connectedUserIds.addAll(users);
      }

      // 3. Bao gồm cả người dùng hiện tại vào danh sách
      connectedUserIds.add(currentUserId);

      // 4. Lấy danh sách tin tức của mỗi người dùng kết nối
      for (String userId in connectedUserIds) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('user').doc(userId).get();
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          List<String> newsList = List<String>.from(userData['News'] ?? []);

          // Lấy thông tin của từng newsfeed
          for (String newsfeedId in newsList) {
            newsfeedIds.add(newsfeedId);
          }
        } else {
          print('Không tìm thấy thông tin cho người dùng có ID: $userId');
        }
      }

      // 5. Lấy thông tin chi tiết của các newsfeed duy nhất
      List<Map<String, dynamic>> allNewsfeeds = [];
      for (String newsfeedId in newsfeedIds) {
        DocumentSnapshot newsfeedDoc = await FirebaseFirestore.instance.collection('newsfeed').doc(newsfeedId).get();
        Map<String, dynamic>? newsfeedData = newsfeedDoc.data() as Map<String, dynamic>?;

        if (newsfeedData != null) {
          allNewsfeeds.add(newsfeedData);
        }
      }

      // 6. Đẩy dữ liệu vào luồng
      yield allNewsfeeds;
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách tin tức của các người dùng kết nối: $error');
    }
    print("Hàm get được gọi");
  }

  Future<bool> checkUserReact(String newsfeedId, String userId) async {
    try {
      // Lấy thông tin của newsfeed cụ thể
      DocumentSnapshot newsfeedSnapshot = await FirebaseFirestore.instance
          .collection('newsfeed')
          .doc(newsfeedId)
          .get();

      // Kiểm tra xem newsfeed có tồn tại không
      if (newsfeedSnapshot.exists) {
        // Lấy dữ liệu của newsfeed
        Map<String, dynamic> newsfeedData = newsfeedSnapshot.data() as Map<String, dynamic>;

        // Lấy danh sách các userId đã react
        List<String> reactUsers = List<String>.from(newsfeedData['react'] ?? []);

        // Kiểm tra xem userId đã có trong danh sách react chưa
        if (reactUsers.contains(userId)) {
          // Nếu có, trả về true
          return true;
        } else {
          // Nếu không, trả về false
          return false;
        }
      } else {
        // Nếu newsfeed không tồn tại, trả về false

        return false;
      }
    } catch (error) {
      // Xử lý lỗi nếu có và trả về false
      print('Đã xảy ra lỗi khi kiểm tra react của người dùng cho newsfeed: $error');
      return false;
    }
  }
  Future<void> updateNewsfeedReact(String newsfeedId, String userId) async {
    try {
      // Lấy thông tin của newsfeed cụ thể
      DocumentSnapshot newsfeedSnapshot = await FirebaseFirestore.instance
          .collection('newsfeed')
          .doc(newsfeedId)
          .get();

      // Kiểm tra xem newsfeed có tồn tại không
      if (newsfeedSnapshot.exists) {
        // Lấy dữ liệu của newsfeed
        Map<String, dynamic> newsfeedData = newsfeedSnapshot.data() as Map<String, dynamic>;

        // Lấy danh sách các userId đã react
        List<String> reactUsers = List<String>.from(newsfeedData['react'] ?? []);
        // int reactCount = newsfeedData["reactCount"];
        // print(reactCount);
        // Kiểm tra xem userId đã có trong danh sách react chưa
        if (reactUsers.contains(userId)) {
          // Nếu có, loại bỏ userId khỏi danh sách
          reactUsers.remove(userId);

        } else {
          // Nếu không, thêm userId vào danh sách
          reactUsers.add(userId);

        }

        // Cập nhật trường 'react' của newsfeed với danh sách mới
        await FirebaseFirestore.instance
            .collection('newsfeed')
            .doc(newsfeedId)
            .update({'react': reactUsers,"reactCount":reactUsers.length});

        print('Cập nhật ${reactUsers.length}');
        print('Cập nhật react thành công cho newsfeed có ID: $newsfeedId');
      } else {

        // Nếu newsfeed không tồn tại
        print('Newsfeed với ID: $newsfeedId không tồn tại');
      }
    } catch (error) {

      // Xử lý lỗi nếu có
      print('Đã xảy ra lỗi khi cập nhật react cho newsfeed: $error');
    }
  }


}