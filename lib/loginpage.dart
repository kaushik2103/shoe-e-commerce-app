import 'package:ecommerce/colors.dart';
import 'package:ecommerce/controllers/password_notify.dart';
import 'package:ecommerce/home.dart';
import 'package:ecommerce/register.dart';
import 'package:ecommerce/views/shared/appstyle.dart';
import 'package:ecommerce/views/shared/customfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // instance of the notifer is created
    var authNotifer = Provider.of<Login_notify>(context);
    return Scaffold(
      backgroundColor: Color(kPrimaryColor),
      appBar: AppBar(
        backgroundColor: Color(kPrimaryColor),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(kPrimaryColor),
          systemNavigationBarColor: Color(kPrimaryColor), // status bar color
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          color: Color(kPrimaryColor),
          child: Column(
            // conventional method to display children in column or row
            // padding: EdgeInsets.zero,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Back",
                style: appstyle(40, Color(kSecondaryColor), FontWeight.w700),
              ),
              Text(
                "Login in your account",
                style: appstyle(16, Color(kSecondaryColor), FontWeight.w700),
              ),
              SizedBox(
                height: 50.h,
              ),
              CustomField(
                hintText: "Email",
                ts: TextInputAction.done,
                controller: email,
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
                controller: pass,
                obscureText: authNotifer.issecured,
                suffixIcon: GestureDetector(
                  onTap: () {
                    authNotifer.issecured = !authNotifer.issecured;
                  },
                  child: !authNotifer.issecured
                      ? const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                        )
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        resetPassword(email.text);
                      },
                      child: Text(
                        "Forgot Password",
                        style: appstyle(16, Colors.white, FontWeight.w500),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => resgisterUser()));
                      },
                      child: Text(
                        "Register",
                        style: appstyle(16, Colors.white, FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text, password: pass.text);

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
                      "L O G I N",
                      style:
                          appstyle(20, Color(kPrimaryColor), FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
