import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/cartpage.dart';
import 'package:ecommerce/colors.dart';
import 'package:ecommerce/favouratepage.dart';
import 'package:ecommerce/loginpage.dart';
import 'package:ecommerce/orders.dart';
import 'package:ecommerce/views/shared/appstyle.dart';
import 'package:ecommerce/views/shared/tiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String username = "Fetching...";

  void getDetails() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection("profile")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        Map test = element.data();
        username = test["username"];
      });
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kSecondaryColor),
      body: SafeArea(
        child: Container(
          height: 750.h,
          decoration: BoxDecoration(color: Color(kSecondaryColor)),
          child: Column(
            children: [
              const SizedBox(
                height: 7,
              ),
              Container(
                height: 90.h,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            SizedBox(
                                height: 35.h,
                                width: 35.w,
                                child: const Icon(Icons.account_circle_rounded,
                                    size: 45)),
                            const SizedBox(
                              width: 25,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 7),
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Username: " + username,
                                    style: appstyle(
                                        15, Colors.black, FontWeight.w500),
                                  ),
                                  Text(
                                    "Email: " +
                                        FirebaseAuth.instance.currentUser!.email
                                            .toString(),
                                    style: appstyle(
                                        15, Colors.black, FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Column(
                children: [
                  Container(
                    height: 170.h,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TilesWidget(
                            OnTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => myOrders()));
                            },
                            title: "Order",
                            leading: Icons.delivery_dining_rounded),
                        TilesWidget(
                            OnTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Favourates(
                                            cross: true,
                                          )));
                            },
                            title: "My Favourates",
                            leading: Icons.favorite_rounded),
                        TilesWidget(
                            OnTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => cartPage(
                                            value: 1,
                                          )));
                            },
                            title: "Cart",
                            leading: Icons.shopping_cart_rounded)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  Container(
                    height: 60.h,
                    color: Colors.white,
                    child: TilesWidget(
                        OnTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginPage()));
                        },
                        title: "Logout",
                        leading: Icons.logout_rounded),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
