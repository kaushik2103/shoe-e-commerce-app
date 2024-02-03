import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/colors.dart';
import 'package:ecommerce/model/productcart.dart';
import 'package:ecommerce/profilepage.dart';
import 'package:ecommerce/services/helper.dart';
import 'package:ecommerce/views/productpage.dart';
import 'package:ecommerce/views/shared/appstyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

// email need to be updated
class Favourates extends StatefulWidget {
  const Favourates({super.key, required this.cross});

  final bool cross;

  @override
  State<Favourates> createState() => _FavouratesState();
}

class _FavouratesState extends State<Favourates> {
  bool isLoading = true;
  late Future<List<Sneakers>> favourateShoes;
  List<String> shoe_id = [];
  List<String> shoe_fav = [];
  List<String> shoe_cat = [];

  final user = FirebaseAuth.instance.currentUser!;

  // method to get fav shoes from the firebase
  Future<void> getUsersShoes(String mail) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(mail)
        .collection("shoes")
        .get()
        .then((value) {
      value.docs.forEach((shoe) {
        Map myShoe = shoe.data();
        shoe_id.add(myShoe['id']);
        shoe_fav.add(myShoe['fav']);
        shoe_cat.add(myShoe['gend']);
      });
      setState(() {
        isLoading = false;
        favourateShoes =
            helper().getListMaleSneakersById(shoe_id, shoe_cat, shoe_fav);
      });
    });
  }

  void getdetails() async {
    await getUsersShoes(user.email.toString()); // here is the user mail id
  }

  @override
  void initState() {
    super.initState();
    getdetails();

    // set state is used as line 60 get already exexuted
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kSecondaryColor),
      appBar: widget.cross
          ? AppBar(
              backgroundColor: Color(kSecondaryColor),
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(kPrimaryColor),
                ),
              ),
              toolbarHeight: 45,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(kSecondaryColor),
                systemNavigationBarColor: Color(kSecondaryColor), // status bar color
              ),
            )
          : AppBar(
              backgroundColor: Color(kSecondaryColor),
              elevation: 0,
              toolbarHeight: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(kSecondaryColor),
                systemNavigationBarColor:
                    Colors.grey.shade300, // status bar color
              ),
            ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                padding: widget.cross
                    ? const EdgeInsets.fromLTRB(16, 0, 0, 0)
                    : const EdgeInsets.fromLTRB(16, 35, 0, 0),
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Favourites",
                          style:
                              appstyle(36, Color(kPrimaryColor), FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: isLoading
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: Color(kPrimaryColor),
                        )),
                      )
                    : Container(
                        child: FutureBuilder(
                            future: favourateShoes,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                print(" Error ${snapshot.error}");

                                return Text(" Error ${snapshot.error}");
                              } else {
                                final shoelist = snapshot.data;
                                return shoelist!.isEmpty
                                    ? Center(
                                        child: Container(
                                          height:
                                              MediaQuery.of(context).size.height,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 50.w),
                                            child: Image.asset("images/pose.png"),
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: shoelist.length,
                                        padding: widget.cross
                                            ? const EdgeInsets.only(top: 80)
                                            : const EdgeInsets.only(top: 100),
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12)),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors
                                                              .grey.shade500,
                                                          spreadRadius: 5,
                                                          blurRadius: 0.3,
                                                          offset:
                                                              const Offset(0, 1))
                                                    ]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => productPage(
                                                                    shoesize: shoelist[
                                                                            index]
                                                                        .sizes,
                                                                    id: shoelist[
                                                                            index]
                                                                        .id,
                                                                    category: shoelist[
                                                                            index]
                                                                        .category)));
                                                      },
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(12),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: shoelist[
                                                                        index]
                                                                    .imageUrl[0],
                                                                height: 70,
                                                                width: 70,
                                                                fit: BoxFit.fill,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 20.0,
                                                                      top: 12),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    shoelist[
                                                                            index]
                                                                        .name,
                                                                    style: appstyle(
                                                                        16,
                                                                        Colors
                                                                            .black,
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    shoelist[
                                                                            index]
                                                                        .category,
                                                                    style: appstyle(
                                                                        14,
                                                                        Colors
                                                                            .grey,
                                                                        FontWeight
                                                                            .w600),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "\₹ ${shoelist[index].price}",
                                                                        style: appstyle(
                                                                            18,
                                                                            Colors
                                                                                .black,
                                                                            FontWeight
                                                                                .w600),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(8),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          // no need to change other parameters
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection("users")
                                                              .doc(user.email)
                                                              .collection("shoes")
                                                              .doc(shoelist[index]
                                                                  .id)
                                                              .update({
                                                            "fav": "false",
                                                            "id": shoelist[index]
                                                                .id,
                                                            "gend":
                                                                shoelist[index]
                                                                    .category,
                                                          });

                                                          shoelist
                                                              .removeAt(index);
                                                          setState(() {});
                                                        },
                                                        child: const Icon(
                                                          Icons
                                                              .heart_broken_rounded,
                                                          color: Color(
                                                              kPrimaryColor),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                              }
                            }),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
