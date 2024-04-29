import 'package:chat_app_flutter/pages/social.dart';
import 'package:chat_app_flutter/service/database.dart';
import 'package:chat_app_flutter/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'home.dart';
import 'package:intl/intl.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email="",password="",name="",phone="";
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String generateID(String username) {
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();
    // Định dạng thời gian thành chuỗi YYYYMMDDHHmm
    String formattedDate = DateFormat('yyyyMMddHHmm').format(now);
    // Kết hợp tên người dùng và thời gian để tạo ID
    String id = '${username}_$formattedDate';
    return id;
  }
  validForm() async {
    if (password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        String user = emailController.text.replaceAll("@gmail.com", "");
        String updateUserName= user.replaceFirst(user[0], user[0].toUpperCase());
        String firstLetter = user.substring(0,1).toUpperCase();
        String id=generateID(updateUserName.toUpperCase());
        Map<String, dynamic> userInfoMap = {
          "IdUser":id,
          "Name": nameController.text,
          "E-mail": emailController.text,
          "Phone": phoneController.text,
          "Username": updateUserName.toUpperCase(),
          "SearcchKey":firstLetter,
          "imageAvatar":"",
          "News":[],
        };
        print("UserInfoMap before adding: $userInfoMap");
        await DatabaseMethods().addUserDetail( id , userInfoMap);
        await SharedPreferenceHelper().saveIdUser(id);
        await SharedPreferenceHelper().saveUserName(nameController.text);
        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        await SharedPreferenceHelper().saveUserDisPlayName(emailController.text.replaceAll("@gmail.com", "").toUpperCase());
        await SharedPreferenceHelper().saveUserPhone(phoneController.text);
        // Thêm thông báo gỡ lỗi ở đây
        debugPrint("Valid form executed successfully!");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registered successfully"),));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Social()));
      } on FirebaseAuthException catch (e) {
        print("Error code: ${e.code}");
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orange,
              content: Text("Password is too weak"),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Account already exists"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
      catch(ex){
        print(ex);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/4.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrangeAccent,Colors.pinkAccent,Colors.yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105.0)
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Center(
                    child: Text("SignUp" , style: TextStyle(color: Colors.black , fontSize: 30),),
                  ),
                  Center(
                    child: Text("Create a new Account" , style: TextStyle(color: Colors.black54 , fontSize: 20),),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0) ,
                        // height: MediaQuery.of(context).size.height/2,
                        height: 560,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name" , style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                              SizedBox(height: 10.0,),
                              Container(
                                padding: EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(border: Border.all(
                                  width: 1.0,color: Colors.black,),
                                  borderRadius:BorderRadius.circular(10) ,
                                ),
                                child: TextFormField(
                                  controller: nameController,
                                  validator: (value){
                                    if(value==null||value.isEmpty){
                                      return "Please enter name";
                                    }
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.people_alt_outlined)
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Text("Email" , style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                              SizedBox(height: 10.0,),
                              Container(
                                padding: EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(border: Border.all(
                                  width: 1.0,color: Colors.black,),
                                  borderRadius:BorderRadius.circular(10) ,
                                ),
                                child: TextFormField(
                                  controller: emailController,
                                  validator: (value){
                                    if(value==null||value.isEmpty){
                                      return "Please enter email";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.mail_lock_outlined)
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Text("Phone" , style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                              SizedBox(height: 10.0,),
                              Container(
                                padding: EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(border: Border.all(
                                  width: 1.0,color: Colors.black,),
                                  borderRadius:BorderRadius.circular(10) ,
                                ),
                                child: TextFormField(
                                  controller: phoneController,
                                  validator: (value){
                                    if(value==null||value.isEmpty){
                                      return "Please enter phone";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.phone_android_outlined)
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text("Password" , style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                              SizedBox(height: 10.0,),
                              Container(
                                padding: EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(border: Border.all(
                                  width: 1.0,color: Colors.black,),
                                  borderRadius:BorderRadius.circular(10) ,
                                ),
                                child: TextFormField(
                                  controller: passwordController,
                                  validator: (value){
                                    if(value==null||value.isEmpty){
                                      return "Please enter password";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.key_off_outlined)
                                  ),
                                  obscureText: true,
                                ),
                              ),

                              SizedBox(height: 20,),
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                child:ElevatedButton(
                                  onPressed: (){
                                    if(_formKey.currentState!.validate()){
                                      setState(() {
                                        print(emailController.text);
                                        email=emailController.text;
                                        name=nameController.text;
                                        phone=phoneController.text;
                                        password=passwordController.text;
                                      });
                                    }
                                    validForm();
                                  },
                                  child: Text("Sign Up",style: TextStyle(color: Colors.black,fontSize: 18),),),
                              ),

                            ],
                          ),
                        )
                      ),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Text("Don't have an account?" , style: TextStyle(fontSize: 16),),
                  //     Text("Sign Up now!" , style: TextStyle(color: Colors.blueAccent,fontSize: 16),),
                  //   ],
                  // ),

                ],
              ),

            ),

          ],
        ),
      ),
    );
  }
}
