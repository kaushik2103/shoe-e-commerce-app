
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/colors.dart';
import 'package:ecommerce/controllers/password_notify.dart';
import 'package:ecommerce/home.dart';
import 'package:ecommerce/views/shared/appstyle.dart';
import 'package:ecommerce/views/shared/customfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class resgisterUser extends StatefulWidget {
  const resgisterUser({super.key});

  @override
  State<resgisterUser> createState() => _resgisterUserState();
}

class _resgisterUserState extends State<resgisterUser> {
  TextEditingController email_lg = TextEditingController();
  TextEditingController pass_lg = TextEditingController();
  TextEditingController confm_lg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // instance of the notifer is created
    var authNotifer = Provider.of<Login_notify>(context);
    return Scaffold(
      backgroundColor: Color(kPrimaryColor),
      body: SafeArea(
        child: Container(
          color: Color(kPrimaryColor),
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            // conventional method to display children in column or row
            // padding: EdgeInsets.zero,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: appstyle(40, Colors.white, FontWeight.w700),
              ),
              Text(
                "Create your account",
                style: appstyle(16, Colors.white, FontWeight.w700),
              ),
              SizedBox(
                height: 50.h,
              ),
              CustomField(
                keyboard: TextInputType.emailAddress,
                hintText: "Username",
                ts: TextInputAction.done,
                controller: confm_lg,
                validator: (Username) {
                  if (Username!.isEmpty) {
                    // checking the input user
                    return 'Username can\'t be null';
                  }
                },
                prefixIcon: const Icon(
                  Icons.person_2_rounded,
                  color: Color(kPrimaryColor),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              CustomField(
                hintText: "Email",
                ts: TextInputAction.done,
                controller: email_lg,
                validator: (email) {
                  if (email!.isEmpty && !email.contains("@")) {
                    // checking the input user
                    return 'Please provide valid email';
                  }
                },
                prefixIcon: const Icon(
                  Icons.email,
                  color: Color(kPrimaryColor),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              CustomField(
                keyboard: TextInputType.emailAddress,
                hintText: "Password",
                ts: TextInputAction.done,
                controller: pass_lg,
                obscureText: authNotifer.issecured,
                suffixIcon: GestureDetector(
                  onTap: () {
                    authNotifer.issecured = !authNotifer.issecured;
                  },
                  child: !authNotifer.issecured
                      ? const Icon(Icons.visibility, color: Colors.grey)
                      : const Icon(Icons.visibility_off, color: Colors.grey),
                ),
                validator: (password) {
                  if (password!.isEmpty && password.length < 7) {
                    // checking the input user
                    return 'Password too weak';
                  }
                },
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color(kPrimaryColor),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Login",
                    style: appstyle(16, Colors.white, FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email_lg.text, password: pass_lg.text);

                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(email_lg.text)
                        .collection("profile")
                        .doc(email_lg.text)
                        .set({"username": confm_lg.text, "email": email_lg.text});
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => home()));
                  },
                  child: Container(
                    height: 55.h,
                    width: 300,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Center(
                      child: Text(
                        "S I G N U P",
                        style: appstyle(20, Color(kPrimaryColor), FontWeight.bold),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
