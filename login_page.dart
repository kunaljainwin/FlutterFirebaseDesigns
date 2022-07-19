import 'dart:async';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:artstick/constants.dart';

import 'package:artstick/pages/drawer.dart';
import 'package:artstick/utils/themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:artstick/services/authentication.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

// flutter run -d chrome --web-port 2020

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  var counter = 0;

  //firebase related variables above
//controlling Login button animation with set state
  bool changedButton = false;
  bool changedButton1 = false;
  bool isPasswordObscure = true;
  //phone authentication
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  //used for form handling
  final _formKey = GlobalKey<FormState>();
  PageController pageController = PageController();
  //new and old user
  bool oldUser = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
    // var brightness = SchedulerBinding.instance!.window.platformBrightness;
    // isDarkMode = brightness == Brightness.dark;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var timer = Timer.periodic(const Duration(seconds: 60), (timer) {
    //   print(timer.tick);
    //   counter--;
    //   if (counter == 0) {
    //     print('Cancel timer');
    //     timer.cancel();
    //   }
    // });
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: 20.w, left: 20.w, top: 0.5.h),
                    child: SizedBox(
                      height: 30.h,
                      width: 90.w,
                      child: Image.asset(
                        ThemeMode.system == ThemeMode.dark
                            ? "assets/images/3.png"
                            : "assets/images/22.png",
                        // fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: const Text(
                      "Welcome",
                      textScaleFactor: 2,
                    ),
                  ),
                  SizedBox(
                    height: 37.h,
                    child: PageView(
                        reverse: kIsWeb,
                        controller: pageController,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: kIsWeb ? 20.w : 10.w,
                                left: kIsWeb ? 20.w : 10.w,
                                top: 0.5.h),
                            child: Column(
                              children: [
                                SizedBox(height: 2.h),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.length != 10) {
                                      return "Invalid Phone Number ";
                                    }
                                    return null;
                                  },
                                  controller: _phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      hintText: "91+",
                                      helperText: "eg.- 94******36",
                                      labelText: 'Phone Number',
                                      prefixIcon: const Icon(Icons.phone),
                                      suffixIcon: counter > 0
                                          ? StatefulBuilder(
                                              builder: (BuildContext context,
                                                  void Function(void Function())
                                                      setState) {
                                                Future.delayed(
                                                        Duration(seconds: 1))
                                                    .then((value) => setState(
                                                          () {
                                                            counter--;
                                                          },
                                                        ));

                                                return Text(
                                                    "00:" + counter.toString());
                                              },
                                            )
                                          : Container(child: null),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              commonRadius))),
                                  textInputAction: TextInputAction.go,
                                  toolbarOptions: ToolbarOptions(paste: true),
                                  autofillHints: [
                                    AutofillHints.telephoneNumber,
                                    AutofillHints.telephoneNumberDevice
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text.rich(
                                  TextSpan(
                                      text:
                                          "By continuing, you agree to the Artstick's ",
                                      children: [
                                        TextSpan(children: [
                                          TextSpan(
                                            text: "Terms and conditions",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launch(termsAndConditions);
                                              },
                                          ),
                                          TextSpan(text: " and "),
                                          TextSpan(
                                            text: "Data Privacy Policy",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launch(userDataPrivacyPolicy);
                                              },
                                          ),
                                          const TextSpan(
                                            text: ".",
                                          ),
                                        ])
                                      ]),
                                ),
                                SizedBox(height: 3.h),
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: ArgonButton(
                                        height: 40,
                                        borderRadius:
                                            changedButton ? 100 : commonRadius,
                                        width: changedButton ? 40 : 80,
                                        // splashColor: Colors.transparent,
                                        // highlightColor: Colors.transparent,
                                        // color: Theme.of(context).cardColor,
                                        child: changedButton
                                            ? const Icon(
                                                Icons.done,
                                              )
                                            : Text(
                                                "Get otp",
                                                textScaleFactor: 1.1,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                        loader: SpinKitThreeInOut(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                          size: 20,
                                        ),
                                        roundLoadingShape: true,
                                        onTap: (startLoading, stopLoading,
                                            btnState) async {
                                          if (btnState == ButtonState.Idle) {
                                            startLoading();
                                            try {
                                              if (_formKey.currentState!
                                                  .validate()) {
// setState(() {
                                                //   counter = 60;
                                                //   changedButton = !changedButton;
                                                // });
                                                await signInWithNumber(
                                                        context,
                                                        _phoneNumberController
                                                            .text,
                                                        _smsController.text)
                                                    .then((value) async {
                                                  setState(() {
                                                    changedButton =
                                                        !changedButton;
                                                  });

                                                  await Future.delayed(
                                                          Duration(seconds: 6))
                                                      .then((value) {
                                                    setState(() {
                                                      changedButton =
                                                          !changedButton;
                                                    });
                                                  });
                                                });
                                              } else {
                                                stopLoading();
                                              }
                                            } catch (e) {
                                              debugPrint(e.toString());
                                            }

//
                                            stopLoading();
                                          } else {
                                            stopLoading();
                                          }
                                        },
                                      ),

                                      //  Material(
                                      //   elevation: changedButton ? 0 : 4,
                                      //   color: Colors.white,
                                      //   child: InkWell(
                                      //     splashColor: Colors.transparent,
                                      //     onTap: () async {
                                      //       if (_formKey.currentState!
                                      //           .validate()) {
                                      //         setState(() {
                                      //           counter = 60;
                                      //           changedButton = !changedButton;
                                      //         });
                                      //         await signInWithNumber(
                                      //             context,
                                      //             _phoneNumberController.text,
                                      //             _smsController.text);
                                      //         // Future.delayed(
                                      //         //         Duration(seconds: 4))
                                      //         // .whenComplete(() {
                                      //         setState(() {
                                      //           changedButton = !changedButton;
                                      //           // });
                                      //         });
                                      //       }
                                      //     },
                                      //     child:
                                      //      AnimatedContainer(
                                      //       duration:
                                      //           const Duration(seconds: 2),
                                      //       curve: Curves.slowMiddle,
                                      //       width: changedButton ? 30 : 100,
                                      //       height: 30,
                                      //       child: changedButton
                                      //           ? const Icon(
                                      //               Icons.done,
                                      //             )
                                      //           : Text(
                                      //               "Get Otp",
                                      //               textScaleFactor: 1,
                                      //               style: TextStyle(
                                      //                   color: Colors.black),
                                      //             ),
                                      //       alignment: Alignment.center,
                                      //       decoration: BoxDecoration(
                                      //         border: Border.all(
                                      //             color: Colors.blue),
                                      //         borderRadius:
                                      //             BorderRadius.circular(
                                      //                 changedButton ? 100 : 0),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              controller.forward();
                                            });
                                            pageController.animateToPage(1,
                                                curve: Curves.bounceOut,
                                                duration: Duration(seconds: 1));
                                          },
                                          child: Text.rich(
                                            TextSpan(
                                                text: "Email ",
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.email_rounded,
                                                      size: 20,
                                                    ),
                                                  )
                                                ],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            textAlign: TextAlign.start,
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: kIsWeb ? 20.w : 10.w,
                                left: kIsWeb ? 20.w : 10.w,
                                top: 0.5.h),
                            child: Column(
                              children: [
                                // Text(
                                //   "welcome",
                                //   textScaleFactor: 2.h / 6,
                                //   maxLines: 1,
                                //   style: const TextStyle(),
                                // ),
                                // SizedBox(height: 3.h),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.endsWith("@gmail.com")) {
                                      return "Invalid Email ";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      hintText: "Enter Email",
                                      helperText: "eg.- username@gmail.com",
                                      labelText: "Email",
                                      prefixIcon: const Icon(Icons.mail),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(1.h))),
                                  onChanged: (value) {
                                    userEmail = value.trim();
                                  },
                                ),
                                SizedBox(height: 2.h),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 8) {
                                      return value.length.toString() +
                                          "/8 " +
                                          "Weak Password";
                                    }
                                    return null;
                                  },
                                  obscureText: isPasswordObscure,
                                  decoration: InputDecoration(
                                    hintText: "Enter Password",
                                    labelText: "Password",

                                    counter: kIsWeb
                                        ? Text.rich(
                                            TextSpan(
                                                text:
                                                    "By continuing, you agree to the Artstick's ",
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(children: [
                                                    TextSpan(
                                                      text:
                                                          "Terms and conditions",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              launch(
                                                                  termsAndConditions);
                                                            },
                                                    ),
                                                    TextSpan(text: " and "),
                                                    TextSpan(
                                                      text:
                                                          "Data Privacy Policy",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              launch(
                                                                  userDataPrivacyPolicy);
                                                            },
                                                    ),

                                                    const TextSpan(
                                                      text: ".",
                                                    ),
                                                    //                                            TextSpan(
                                                    //                                       text: "",
                                                    //                                       recognizer: TapGestureRecognizer()..onTap = () { launch(cookieManagementPolicy);
                                                    // },
                                                    //                                            ),
                                                  ])
                                                ]),
                                          )
                                        : null,

                                    // filled: false,
                                    prefixIcon: const Icon(Icons.lock),

                                    suffixIcon: GestureDetector(
                                        child: Icon(
                                          isPasswordObscure
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            isPasswordObscure =
                                                !isPasswordObscure;
                                          });
                                        }),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(1.h),
                                    ),
                                    //fillColor: Colors.pink,
                                  ),
                                  onChanged: (value) {
                                    passWord = value.trim();
                                  },
                                ),
                                Align(
                                  child: TextButton(
                                    onPressed: () {
                                      if (userEmail.contains("@gmail.com")) {
                                        try {
                                          FirebaseAuth.instance
                                              .sendPasswordResetEmail(
                                                  email: userEmail)
                                              .then((value) =>
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Password reset link send to " +
                                                              userEmail,
                                                      timeInSecForIosWeb: 2));
                                        } catch (e) {
                                          debugPrint(e.toString());
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: userEmail.toString() +
                                                "is not valid Email " +
                                                userEmail,
                                            timeInSecForIosWeb: 2);
                                      }
                                    },
                                    child: const Text(
                                      'Forgot Password ?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 15),
                                    ),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide.none)),
                                  ),
                                  alignment: Alignment.centerRight,
                                ),
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: ArgonButton(
                                        height: 40,
                                        borderRadius:
                                            changedButton ? 100 : commonRadius,
                                        width: changedButton ? 40 : 80,
                                        // splashColor: Colors.transparent,
                                        // highlightColor: Colors.transparent,
                                        // color: Theme.of(context).cardColor,
                                        child: Text(
                                          oldUser ? "Login" : "Sign up",
                                        ),
                                        loader: SpinKitThreeInOut(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                          size: 20,
                                        ),
                                        roundLoadingShape: true,
                                        onTap: (startLoading, stopLoading,
                                            btnState) async {
                                          if (btnState == ButtonState.Idle) {
                                            startLoading();
                                            try {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                oldUser
                                                    ? await signInUser()
                                                    : await createUser();
                                                await Future.delayed(
                                                        Duration(seconds: 4))
                                                    .whenComplete(() {
                                                  setState(() {
                                                    changedButton =
                                                        !changedButton;
                                                  });
                                                });
                                              } else {
                                                stopLoading();
                                              }
                                            } catch (e) {
                                              debugPrint(e.toString());
                                            }

//
                                            stopLoading();
                                          } else {
                                            stopLoading();
                                          }
                                        },
                                      ),

                                      //  Material(
                                      //   elevation: changedButton ? 0 : 4,
                                      //   color: Colors.white,
                                      //   child: InkWell(
                                      //     splashColor: Colors.transparent,
                                      //     onTap: () async {
                                      //       if (_formKey.currentState!
                                      //           .validate()) {
                                      //         setState(() {
                                      //           changedButton = !changedButton;
                                      //         });
                                      //         oldUser
                                      //             ? await signInUser()
                                      //             : await createUser();
                                      //         Future.delayed(
                                      //                 Duration(seconds: 4))
                                      //             .whenComplete(() {
                                      //           setState(() {
                                      //             changedButton =
                                      //                 !changedButton;
                                      //           });
                                      //         });
                                      //       }
                                      //     },
                                      //     child: AnimatedContainer(
                                      //       duration:
                                      //           const Duration(seconds: 2),
                                      //       curve: Curves.slowMiddle,
                                      //       width: changedButton ? 40 : 100,
                                      //       height: 40,
                                      //       child: changedButton
                                      //           ? const Icon(
                                      //               Icons.done,
                                      //             )
                                      //           : Text(
                                      //               oldUser
                                      //                   ? "Login"
                                      //                   : "Sign up",
                                      //               textScaleFactor: 1,
                                      //               style: TextStyle(
                                      //                   color: Colors.black),
                                      //             ),
                                      //       alignment: Alignment.center,
                                      //       decoration: BoxDecoration(
                                      //         border: Border.all(
                                      //             color: Colors.blue),
                                      //         borderRadius:
                                      //             BorderRadius.circular(
                                      //                 changedButton ? 100 : 40),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          pageController.animateToPage(0,
                                              curve: Curves.bounceOut,
                                              duration: Duration(seconds: 1));
                                        },
                                        child: Text.rich(
                                          TextSpan(
                                              text: "Phone ",
                                              children: [
                                                WidgetSpan(
                                                    child: Icon(
                                                  Icons.phone,
                                                  size: 20,
                                                  color: Colors.green,
                                                ))
                                              ],
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  !oldUser
                      ? TextButton(
                          onPressed: () async {
                            await signInAnonymously();
                          },
                          child: const Text("Sign in Anonymously"))
                      : SizedBox.shrink(),
                  TextButton(
                    child: Text(
                        !oldUser
                            ? "Already have an account? Log in"
                            : "New to Artstick? Sign up",
                        textScaleFactor: 1,
                        style: const TextStyle(
                          color: Colors.grey,
                        )),
                    onPressed: () {
                      setState(() {
                        oldUser = !oldUser;
                      });
                    },
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(side: BorderSide.none)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 2,
                        )),
                        const Text("            OR            "),
                        Expanded(
                            child: Divider(
                          thickness: 2,
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  changedButton1
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              changedButton1 = !changedButton1;
                            });

                            try {
                              await signInWithGoogle();
                            } catch (we) {
                              setState(() {
                                changedButton1 = !changedButton1;
                              });
                            }
                          },
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white),
                          icon: SizedBox(
                            height: 6.h,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'http://pngimg.com/uploads/google/google_PNG19635.png',
                            ),
                          ),
                          label: !changedButton1
                              ? Text(
                                  oldUser
                                      ? "  Sign in with Google"
                                      : "  Sign up with Google",
                                  style: TextStyle(color: Colors.black),
                                )
                              : Stack(fit: StackFit.passthrough, children: [
                                  CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                                    ),
                                  )
                                ])),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
