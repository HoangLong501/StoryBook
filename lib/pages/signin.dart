import 'package:chat_app_flutter/pages/signup.dart';
import 'package:chat_app_flutter/pages/social.dart';
import 'package:chat_app_flutter/pages/social2.dart';
import 'package:chat_app_flutter/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _StateSignIn();
}

class _StateSignIn extends State<SignIn> {
  String email="",password="",id="",name="",phone="",username="",image="";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  userLogin()async{
    try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
         QuerySnapshot querySnapshot=await DatabaseMethods().getUserByEmail(email);
        id="${querySnapshot.docs[0]["IdUser"]}";
        name="${querySnapshot.docs[0]["Name"]}";
        phone="${querySnapshot.docs[0]["Phone"]}";
        username="${querySnapshot.docs[0]["Username"]}";
        image="${querySnapshot.docs[0]["imageAvatar"]}";
        await SharedPreferenceHelper().saveUserDisPlayName(username);
        await SharedPreferenceHelper().saveUserName(name);
        await SharedPreferenceHelper().saveIdUser(id);
        await SharedPreferenceHelper().saveUserPhone(phone);
        await SharedPreferenceHelper().saveImageUser(image);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Social2()));
    }on FirebaseAuthException catch(e){
      if(e.code=='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user for that email",style: TextStyle(fontSize: 18),),backgroundColor: Colors.orange,));
      }else if(e.code=='wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Wrong password",style: TextStyle(fontSize: 18),),backgroundColor: Colors.orange,));
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
                      child: Text("SignIn" , style: TextStyle(color: Colors.black , fontSize: 30),),
                    ),
                    Center(
                      child: Text("Login to your account" , style: TextStyle(color: Colors.black54 , fontSize: 20),),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0) ,
                          // height: MediaQuery.of(context).size.height/2,
                          height: 350,
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
                                        return "Please Enter Email";
                                      }else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.mail_lock_outlined)
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
                                        return "Please Enter Password";
                                      }else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.key_off_outlined)
                                    ),
                                    obscureText: true,
                                  ),
                                ),
                                SizedBox(height: 6,),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child:Text("Forgot Password?" , style: TextStyle(color: Colors.blueAccent,fontSize: 18,fontStyle: FontStyle.italic),) ,
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child:ElevatedButton(
                                    onPressed: (){
                                      print("press signin");
                                      if(_formKey.currentState!.validate()){
                                        setState(() {
                                          email=emailController.text;
                                          password=passwordController.text;
                                        });
                                      }
                                      userLogin();
                                    },
                                    child: Text("Signin",style: TextStyle(color: Colors.black,fontSize: 18),),),
                                ),

                              ],
                            ),
                          )
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Don't have an account?" , style: TextStyle(fontSize: 16),),
                        TextButton(onPressed:(){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
                        },
                          child: Text("Sign Up now!" , style: TextStyle(color: Colors.blueAccent,fontSize: 16),),)
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
