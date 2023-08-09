import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/bankdetails.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/walletpage.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';

import '../NavigatorPages/driverearnings.dart';

class Finances extends StatefulWidget {
  const Finances({Key? key}) : super(key: key);

  @override
  State<Finances> createState() => _FinancesState();
}

class _FinancesState extends State<Finances> {
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
              languages[choosenLanguage]['text_finance'],
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
//earnings
              userDetails['owner_id'] == null
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DriverEarnings()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(media.width * 0.025),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/Earnings.png',
                              fit: BoxFit.contain,
                              width: media.width * 0.075,
                            ),
                            SizedBox(
                              width: media.width * 0.025,
                            ),
                            SizedBox(
                              width: media.width * 0.55,
                              child: Text(
                                languages[choosenLanguage]['text_earnings'],
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

              //wallet
              userDetails['owner_id'] == null &&
                      userDetails['show_bank_info_feature_on_mobile_app'] == "1"
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WalletPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(media.width * 0.025),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/walletImage.png',
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
                                    fontSize: media.width * sixteen,
                                    color: textColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),

              //bank details
              userDetails['owner_id'] == null &&
                      userDetails["show_wallet_feature_on_mobile_app"] == "1"
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BankDetails()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(media.width * 0.025),
                        child: Row(
                          children: [
                            Icon(Icons.account_balance,
                                size: media.width * 0.075),
                            SizedBox(
                              width: media.width * 0.025,
                            ),
                            SizedBox(
                              width: media.width * 0.55,
                              child: Text(
                                languages[choosenLanguage]['text_updateBank'],
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
