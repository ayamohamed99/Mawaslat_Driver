import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/fleetdetails.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/selectlanguage.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/sos.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/updatevehicle.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/pages/vehicleInformations/upload_docs.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              languages[choosenLanguage]['text_settings'],
              style: const TextStyle(color: Colors.black),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(CupertinoIcons.chevron_back),
              color: Colors.black,
            ),
          ),
          body: Column(
            children: [
              //language
              InkWell(
                onTap: () async {
                  var nav = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectLanguage()));
                  if (nav) {
                    setState(() {});
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(media.width * 0.025),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/changeLanguage.png',
                        fit: BoxFit.contain,
                        width: media.width * 0.075,
                      ),
                      SizedBox(
                        width: media.width * 0.025,
                      ),
                      SizedBox(
                        width: media.width * 0.55,
                        child: Text(
                          languages[choosenLanguage]['text_change_language'],
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

              //sos
              userDetails['role'] != 'owner'
                  ? InkWell(
                      onTap: () async {
                        var nav = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Sos()));

                        if (nav) {
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(media.width * 0.025),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/sos.png',
                              fit: BoxFit.contain,
                              width: media.width * 0.075,
                            ),
                            SizedBox(
                              width: media.width * 0.025,
                            ),
                            SizedBox(
                              width: media.width * 0.55,
                              child: Text(
                                languages[choosenLanguage]['text_sos'],
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
                  : Container(),

              //documents
              InkWell(
                onTap: () async {
                  var nav = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Docs(
                                fromPage: '2',
                              )));
                  if (nav) {
                    setState(() {});
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(media.width * 0.025),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/manageDocuments.png',
                        fit: BoxFit.contain,
                        width: media.width * 0.075,
                      ),
                      SizedBox(
                        width: media.width * 0.025,
                      ),
                      SizedBox(
                        width: media.width * 0.55,
                        child: Text(
                          languages[choosenLanguage]['text_manage_docs'],
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

              //update vehicles

              userDetails['owner_id'] == null && userDetails['role'] == 'driver'
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UpdateVehicle()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(media.width * 0.025),
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
                                    ['text_updateVehicle'],
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
                  : Container(),
              //fleet details
              userDetails['owner_id'] != null && userDetails['role'] == 'driver'
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FleetDetails()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(media.width * 0.025),
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
                                    ['text_fleet_details'],
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
                  : Container(),

              //delete account
              userDetails['owner_id'] == null
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          deleteAccount = true;
                        });
                        valueNotifierHome.incrementNotifier();
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(media.width * 0.025),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_forever,
                              size: media.width * 0.075,
                            ),
                            SizedBox(
                              width: media.width * 0.025,
                            ),
                            SizedBox(
                              width: media.width * 0.55,
                              child: Text(
                                languages[choosenLanguage]
                                    ['text_delete_account'],
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
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
