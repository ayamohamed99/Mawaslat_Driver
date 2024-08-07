import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/main.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/about.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/driverdetails.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/editprofile.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/faq.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/history.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/makecomplaint.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/myroutebookings.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/referral.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/walletpage.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/pages/navDrawer/finances.dart';
import 'package:tagyourtaxi_driver/pages/navDrawer/settings.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/pages/payment/payment_page.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

import '../NavigatorPages/managevehicles.dart';
import '../NavigatorPages/notification.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  bool _isLoading = false;
  String _error = '';

  navigateLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

  
  @override
  void initState() {
    super.initState();

    if (!getBoolAsync('userInfoAdded')) {
      facebookAppEvents.setUserData(
        email: userDetails['email'],
        phone: userDetails['mobile'],
      );
      setValue('userInfoAdded', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          color: page,
          width: media.width * 0.8,
          child: Directionality(
            textDirection: (languageDirection == 'rtl')
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Drawer(
              child: SizedBox(
                width: media.width * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: media.width * 0.05 +
                            MediaQuery.of(context).padding.top,
                      ),
                      SizedBox(
                        width: media.width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: media.width * 0.2,
                              width: media.width * 0.2,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          userDetails['profile_picture']
                                              .toString()),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              width: media.width * 0.025,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: media.width * 0.45,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: media.width * 0.3,
                                        child: Text(
                                          userDetails['name'],
                                          style: GoogleFonts.tajawal(
                                              fontSize: media.width * eighteen,
                                              color: textColor,
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                        ),
                                      ),
                                      //edit profile
                                      InkWell(
                                        onTap: () async {
                                          var val = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EditProfile()));
                                          if (val != null) {
                                            if (val) {
                                              setState(() {});
                                            }
                                          }
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: media.width * eighteen,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.01,
                                ),
                                SizedBox(
                                  width: media.width * 0.45,
                                  child: Text(
                                    userDetails['email'],
                                    style: GoogleFonts.tajawal(
                                        fontSize: media.width * fourteen,
                                        color: textColor),
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: valueNotifierNotification.value,
                        builder: (context, value, child) {
                          return Container(
                            padding: EdgeInsets.only(top: media.width * 0.02),
                            width: media.width * 0.7,
                            child: Column(
                              children: [
                                //my route bookings
                                userDetails['role'] != 'owner' &&
                                        userDetails[
                                                'enable_my_route_booking_feature'] ==
                                            "1"
                                    ? InkWell(
                                        onTap: () async {
                                          var nav = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyRouteBooking()));
                                          if (nav != null) {
                                            if (nav) {
                                              setState(() {});
                                            }
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(
                                                  media.width * 0.025),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/myroute.png',
                                                    fit: BoxFit.contain,
                                                    width: media.width * 0.075,
                                                  ),
                                                  SizedBox(
                                                    width: media.width * 0.025,
                                                  ),
                                                  SizedBox(
                                                    width: media.width * 0.45,
                                                    child: Text(
                                                      languages[choosenLanguage]
                                                          ['text_my_route'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      sixteen,
                                                              color: textColor),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),

                                            // SizedBox(width: media.width*0.05,),
                                            if (userDetails[
                                                    'my_route_address'] !=
                                                null)
                                              InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  var dist = calculateDistance(
                                                      center.latitude,
                                                      center.longitude,
                                                      double.parse(userDetails[
                                                              'my_route_lat']
                                                          .toString()),
                                                      double.parse(userDetails[
                                                              'my_route_lng']
                                                          .toString()));

                                                  if (dist > 5000.0 ||
                                                      userDetails[
                                                              'enable_my_route_booking'] ==
                                                          "1") {
                                                    var val =
                                                        await enableMyRouteBookings(
                                                            center.latitude,
                                                            center.longitude);
                                                    if (val == 'logout') {
                                                      navigateLogout();
                                                    } else if (val !=
                                                        'success') {
                                                      setState(() {
                                                        _error = val;
                                                      });
                                                    }
                                                  } else {
                                                    _error = languages[
                                                            choosenLanguage][
                                                        'text_myroute_warning'];
                                                  }

                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: media.width * 0.005,
                                                      right:
                                                          media.width * 0.005),
                                                  height: media.width * 0.05,
                                                  width: media.width * 0.1,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            media.width *
                                                                0.025),
                                                    color: (userDetails[
                                                                'enable_my_route_booking'] ==
                                                            1)
                                                        ? Colors.green
                                                            .withOpacity(0.4)
                                                        : Colors.grey
                                                            .withOpacity(0.6),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: (userDetails[
                                                                'enable_my_route_booking'] ==
                                                            1)
                                                        ? MainAxisAlignment.end
                                                        : MainAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height:
                                                            media.width * 0.045,
                                                        width:
                                                            media.width * 0.045,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: (userDetails[
                                                                      'enable_my_route_booking'] ==
                                                                  1)
                                                              ? Colors.green
                                                              : Colors.grey,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                //notification
                                if (userDetails['role'] == 'driver')
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NotificationPage()));
                                      setState(() {
                                        userDetails['notifications_count'] = 0;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(
                                              media.width * 0.025),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/notification.png',
                                                fit: BoxFit.contain,
                                                width: media.width * 0.075,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.025,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.49,
                                                child: Text(
                                                  languages[choosenLanguage]
                                                          ['text_notification']
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.tajawal(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: textColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        (userDetails['notifications_count'] ==
                                                0)
                                            ? Container()
                                            : Container(
                                                height: 20,
                                                width: 20,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: buttonColor,
                                                ),
                                                child: Text(
                                                  userDetails[
                                                          'notifications_count']
                                                      .toString(),
                                                  style: GoogleFonts.tajawal(
                                                      fontSize: media.width *
                                                          fourteen,
                                                      color: buttonText),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                //wallet page
                                if (userDetails[
                                        'show_bank_info_feature_on_mobile_app'] ==
                                    "1")
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WalletPage()));
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(media.width * 0.025),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/walletIcon.png',
                                            fit: BoxFit.contain,
                                            width: media.width * 0.075,
                                          ),
                                          SizedBox(
                                            width: media.width * 0.025,
                                          ),
                                          SizedBox(
                                            width: media.width * 0.55,
                                            child: Text(
                                              languages[choosenLanguage]
                                                  ['text_enable_wallet'],
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.tajawal(
                                                  fontSize:
                                                      media.width * sixteen,
                                                  color: textColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                //mange card
                                InkWell(
                                  onTap: () {
                                    PaymentScreen.navigate(
                                      context,
                                      amount: 1,
                                      isManage: true,
                                    );
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(media.width * 0.025),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/walletIcon.png',
                                          fit: BoxFit.contain,
                                          width: media.width * 0.075,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.025,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.55,
                                          child: Text(
                                            choosenLanguage == "en"
                                                ? "Manage Cards"
                                                : "ادارة البطاقات",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.tajawal(
                                                fontSize: media.width * sixteen,
                                                color: textColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                //history
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const History()));
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(media.width * 0.025),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/history.png',
                                          fit: BoxFit.contain,
                                          width: media.width * 0.075,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.025,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.55,
                                          child: Text(
                                            languages[choosenLanguage]
                                                ['text_enable_history'],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.tajawal(
                                                fontSize: media.width * sixteen,
                                                color: textColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                //referral
                                userDetails['owner_id'] == null &&
                                        userDetails['role'] == 'driver'
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ReferralPage()));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              media.width * 0.025),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/referral.png',
                                                fit: BoxFit.contain,
                                                width: media.width * 0.075,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.025,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.55,
                                                child: Text(
                                                  languages[choosenLanguage]
                                                      ['text_enable_referal'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.tajawal(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: textColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),

                                //manage vehicle

                                userDetails['role'] == 'owner'
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ManageVehicles()));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              media.width * 0.025),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/updateVehicleInfo.png',
                                                fit: BoxFit.contain,
                                                width: media.width * 0.075,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.025,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.55,
                                                child: Text(
                                                  languages[choosenLanguage]
                                                      ['text_manage_vehicle'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.tajawal(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: textColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),

                                //manage Driver

                                userDetails['role'] == 'owner'
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DriverList()));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              media.width * 0.025),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/managedriver.png',
                                                fit: BoxFit.contain,
                                                width: media.width * 0.075,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.025,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.55,
                                                child: Text(
                                                  languages[choosenLanguage]
                                                      ['text_manage_drivers'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.tajawal(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: textColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),

                                //faq
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Faq()));
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(media.width * 0.025),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/faq.png',
                                          fit: BoxFit.contain,
                                          width: media.width * 0.075,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.025,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.55,
                                          child: Text(
                                            languages[choosenLanguage]
                                                ['text_faq'],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.tajawal(
                                                fontSize: media.width * sixteen,
                                                color: textColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                // //make complaints
                                InkWell(
                                  onTap: () async {
                                    var nav = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MakeComplaint(
                                                  fromPage: 0,
                                                )));
                                    if (nav) {
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(media.width * 0.025),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/makecomplaint.png',
                                          fit: BoxFit.contain,
                                          width: media.width * 0.075,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.025,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.55,
                                          child: Text(
                                            languages[choosenLanguage]
                                                ['text_make_complaints'],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.tajawal(
                                                fontSize: media.width * sixteen,
                                                color: textColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                //about
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const About()));
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(media.width * 0.025),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            size: media.width * 0.075),
                                        SizedBox(
                                          width: media.width * 0.025,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.55,
                                          child: Text(
                                            languages[choosenLanguage]
                                                ['text_about'],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.tajawal(
                                                fontSize: media.width * sixteen,
                                                color: textColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Finances(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(media.width * 0.025),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.wallet, size: 30),
                                        SizedBox(
                                          width: media.width * 0.025,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.5,
                                          child: Text(
                                            languages[choosenLanguage]
                                                ['text_finance'],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.tajawal(
                                                fontSize: media.width * sixteen,
                                                color: textColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Settings(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(media.width * 0.025),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.settings,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.025,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.5,
                                          child: Text(
                                            languages[choosenLanguage]
                                                ['text_settings'],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.tajawal(
                                                fontSize: media.width * sixteen,
                                                color: textColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                //logout
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      logout = true;
                                    });
                                    valueNotifierHome.incrementNotifier();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(media.width * 0.025),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/logout.png',
                                          fit: BoxFit.contain,
                                          width: media.width * 0.075,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.025,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.55,
                                          child: Text(
                                            languages[choosenLanguage]
                                                ['text_logout'],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.tajawal(
                                                fontSize: media.width * sixteen,
                                                color: textColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        (_error != '')
            ? Positioned(
                top: 0,
                child: Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  color: Colors.transparent.withOpacity(0.6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(media.width * 0.05),
                        width: media.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: page),
                        child: Column(
                          children: [
                            SizedBox(
                              width: media.width * 0.8,
                              child: Text(
                                _error.toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.tajawal(
                                    fontSize: media.width * sixteen,
                                    color: textColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: media.width * 0.05,
                            ),
                            Button(
                                onTap: () async {
                                  setState(() {
                                    _error = '';
                                  });
                                },
                                text: languages[choosenLanguage]['text_ok'])
                          ],
                        ),
                      )
                    ],
                  ),
                ))
            : Container(),
        if (_isLoading == true) const Positioned(child: Loading())
      ],
    );
  }
}
