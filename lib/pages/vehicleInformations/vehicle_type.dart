// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/managevehicles.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/pages/vehicleInformations/referral_code.dart';
import 'package:tagyourtaxi_driver/pages/vehicleInformations/vehicle_make.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class VehicleType extends StatefulWidget {
  const VehicleType({Key? key}) : super(key: key);

  @override
  State<VehicleType> createState() => _VehicleTypeState();
}

dynamic myVehicalType;
dynamic myVehicleId;
dynamic myVehicleIconFor;

class _VehicleTypeState extends State<VehicleType> {
  bool _loaded = false;

  @override
  void initState() {
    getvehicle();
    super.initState();
  }

  bool _isLoading = false;

  String uploadError = '';

//navigate
  navigateRef() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Referral()),
        (route) => false);
  }

  navigateLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

  navigateMap() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Maps()),
        (route) => false);
  }

//get vehicle type
  getvehicle() async {
    myVehicalType = '';
    myVehicleId = '';
    myVehicleIconFor = '';
    await getvehicleType();
    if (mounted) {
      setState(() {
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: media.width * 0.08,
                  right: media.width * 0.08,
                  top: media.width * 0.05 + MediaQuery.of(context).padding.top),
              height: media.height * 1,
              width: media.width * 1,
              color: page,
              child: Column(
                children: [
                  Container(
                      width: media.width * 1,
                      color: topBar,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back)),
                        ],
                      )),
                  SizedBox(
                    height: media.height * 0.04,
                  ),
                  SizedBox(
                      width: media.width * 1,
                      child: Text(
                        languages[choosenLanguage]['text_vehicle_type'],
                        style: GoogleFonts.tajawal(
                            fontSize: media.width * twenty,
                            color: textColor,
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 10),
                  (_loaded != false && vehicleType.isNotEmpty)
                      ? Expanded(
                          child: SingleChildScrollView(
                          child: Column(
                            children: vehicleType
                                .asMap()
                                .map((i, value) => MapEntry(
                                    i,
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      width: media.width * 1,
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            myVehicleId = vehicleType[i]['id'];
                                            myVehicleIconFor = vehicleType[i]
                                                ['icon_types_for'];
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                (vehicleType[i]['icon'] != null)
                                                    ? SizedBox(
                                                        width:
                                                            media.width * 0.133,
                                                        height:
                                                            media.width * 0.133,
                                                        child: Image.network(
                                                          vehicleType[i]
                                                              ['icon'],
                                                          fit: BoxFit.contain,
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height:
                                                            media.width * 0.133,
                                                        width:
                                                            media.width * 0.133,
                                                      ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  vehicleType[i]['name'],
                                                  style: GoogleFonts.tajawal(
                                                      fontSize:
                                                          media.width * twenty,
                                                      color: textColor),
                                                ),
                                              ],
                                            ),
                                            (myVehicleId ==
                                                    vehicleType[i]['id'])
                                                ? Icon(
                                                    Icons.done,
                                                    color: buttonColor,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    )))
                                .values
                                .toList(),
                          ),
                        ))
                      : Container(),
                  (myVehicleId != '')
                      ? SafeArea(
                          child: Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Button(
                                onTap: () async {
                                  if (getBoolAsync('register')) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const VehicleMake()));
                                  } else {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (userDetails.isEmpty) {
                                      var reg = await registerDriver();
                                      log('vvv: $reg reg');
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (reg == 'true') {
                                        navigateRef();
                                        serviceLocations.clear();
                                        vehicleMake.clear();
                                        vehicleModel.clear();
                                        vehicleType.clear();
                                      } else {
                                        setState(() {
                                          uploadError = reg.toString();
                                        });
                                      }
                                    } else if (userDetails['role'] == 'owner') {
                                      var reg = await addDriver();
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (reg == 'true') {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Container(
                                                width: media.width * 0.8,
                                                color: Colors.white,
                                                child: Text(
                                                  languages[choosenLanguage]
                                                      ['text_vehicle_added'],
                                                  style: TextStyle(
                                                      color: textColor),
                                                ),
                                              ),
                                              actions: [
                                                Button(
                                                    width: media.width * 0.2,
                                                    height: media.width * 0.1,
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const ManageVehicles()),
                                                      );
                                                    },
                                                    text: "OK")
                                              ],
                                            );
                                          },
                                        );

                                        serviceLocations.clear();
                                        vehicleMake.clear();
                                        vehicleModel.clear();
                                        vehicleType.clear();
                                      } else if (reg == 'logout') {
                                        navigateLogout();
                                      } else {
                                        setState(() {
                                          uploadError = reg.toString();
                                        });
                                      }
                                    } else {
                                      var update = await updateVehicle();
                                      if (update == 'success') {
                                        navigateMap();
                                        serviceLocations.clear();
                                        vehicleMake.clear();
                                        vehicleModel.clear();
                                        vehicleType.clear();
                                      } else if (update == 'logout') {
                                        navigateLogout();
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                },
                                text: languages[choosenLanguage]['text_next']),
                          ),
                        )
                      : Container()
                ],
              ),
            ),

            //no internet
            (internet == false)
                ? Positioned(
                    top: 0,
                    child: NoInternet(
                      onTap: () {
                        setState(() {
                          internetTrue();
                        });
                      },
                    ))
                : Container(),

            //loader
            (!_loaded && !_isLoading)
                ? const Positioned(top: 0, child: Loading())
                : Container()
          ],
        ),
      ),
    );
  }
}
