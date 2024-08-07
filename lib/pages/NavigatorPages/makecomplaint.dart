import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class MakeComplaint extends StatefulWidget {
  final int fromPage;
  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  MakeComplaint({required this.fromPage});

  @override
  State<MakeComplaint> createState() => _MakeComplaintState();
}

int complaintType = 0;
String complaintDesc = '';

class _MakeComplaintState extends State<MakeComplaint> {
  bool _isLoading = true;
  bool _showOptions = false;
  TextEditingController complaintText = TextEditingController();
  bool _success = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  navigateLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

//get complaint data
  getData() async {
    dynamic val;
    if (mounted) {
      setState(() {
        complaintType = 0;
        complaintDesc = '';
        generalComplaintList = [];
      });
    }
    if (widget.fromPage == 1) {
      val = await getGeneralComplaint("request");
    } else {
      val = await getGeneralComplaint("general");
    }
    if (mounted) {
      if (val == 'logout') {
        navigateLogout();
      }
      setState(() {
        _isLoading = false;
        if (generalComplaintList.isNotEmpty) {
          complaintType = 0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: Material(
        child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Stack(
            children: [
              Container(
                height: media.height * 1,
                width: media.width * 1,
                color: page,
                padding: EdgeInsets.only(
                    left: media.width * 0.05, right: media.width * 0.05),
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).padding.top +
                            media.width * 0.05),
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: media.width * 0.05),
                          width: media.width * 1,
                          alignment: Alignment.center,
                          child: Text(
                            languages[choosenLanguage]['text_make_complaints'],
                            style: GoogleFonts.tajawal(
                                fontSize: media.width * twenty,
                                fontWeight: FontWeight.w600,
                                color: textColor),
                          ),
                        ),
                        Positioned(
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Icon(Icons.arrow_back)))
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    (generalComplaintList.isNotEmpty)
                        ? Expanded(
                            child: Column(children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (_showOptions == false) {
                                    _showOptions = true;
                                  } else {
                                    _showOptions = false;
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: media.width * 0.05,
                                    right: media.width * 0.05),
                                height: media.width * 0.12,
                                width: media.width * 0.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: borderLines, width: 1.2)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(generalComplaintList[complaintType]
                                        ['title']),
                                    RotatedBox(
                                      quarterTurns:
                                          (_showOptions == true) ? 2 : 0,
                                      child: Container(
                                        height: media.width * 0.08,
                                        width: media.width * 0.08,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/chevron-down.png'),
                                                fit: BoxFit.contain)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: media.width * 0.08,
                            ),
                            Container(
                              padding: EdgeInsets.all(media.width * 0.025),
                              width: media.width * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: borderLines, width: 1.2)),
                              child: TextField(
                                controller: complaintText,
                                minLines: 5,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.tajawal(
                                      fontSize: media.width * fourteen),
                                  hintText: languages[choosenLanguage]
                                          ['text_complaint_2'] +
                                      ' (' +
                                      languages[choosenLanguage]
                                          ['text_complaint_3'] +
                                      ')',
                                ),
                              ),
                            ),
                          ]))
                        : Container(),
                    (generalComplaintList.isNotEmpty)
                        ? Container(
                            padding: EdgeInsets.all(media.width * 0.05),
                            child: Button(
                                onTap: () async {
                                  if (complaintText.text.length >= 10) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    complaintDesc = complaintText.text;
                                    dynamic result;
                                    if (widget.fromPage == 1) {
                                      result = await makeRequestComplaint();
                                    } else {
                                      result = await makeGeneralComplaint();
                                    }
                                    if (result == 'logout') {
                                      navigateLogout();
                                    } else if (result == 'success') {
                                      _success = true;
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                text: languages[choosenLanguage]
                                    ['text_submit']),
                          )
                        : Container()
                  ],
                ),
              ),

              //complaint options

              (_showOptions == true)
                  ? Positioned(
                      top: media.width * 0.35 +
                          MediaQuery.of(context).padding.top,
                      child: Container(
                        padding: EdgeInsets.all(media.width * 0.025),
                        margin: EdgeInsets.only(
                            left: media.width * 0.1, right: media.width * 0.05),
                        height: media.width * 0.3,
                        width: media.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 1.2, color: borderLines),
                          color: page,
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: generalComplaintList
                                .asMap()
                                .map((i, value) {
                                  return MapEntry(
                                      i,
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            complaintType = i;
                                            _showOptions = false;
                                          });
                                        },
                                        child: Container(
                                          width: media.width * 0.7,
                                          padding: EdgeInsets.only(
                                              top: media.width * 0.025,
                                              bottom: media.width * 0.025),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1.1,
                                                      color: (i ==
                                                              generalComplaintList
                                                                      .length -
                                                                  1)
                                                          ? Colors.transparent
                                                          : borderLines))),
                                          child: Text(
                                              generalComplaintList[i]['title']),
                                        ),
                                      ));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      ))
                  : Container(),

              //success
              (_success == true)
                  ? Positioned(
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
                              border:
                                  Border.all(width: 1.2, color: borderLines),
                              color: page,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: media.width * 0.7,
                                  child: Text(
                                    languages[choosenLanguage]
                                        ['text_complaint_success'],
                                    style: GoogleFonts.tajawal(
                                        fontSize: media.width * sixteen,
                                        fontWeight: FontWeight.w600,
                                        color: textColor),
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.025,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: media.width * 0.7,
                                  child: Text(
                                    languages[choosenLanguage]
                                        ['text_complaint_success_2'],
                                    style: GoogleFonts.tajawal(
                                        fontSize: media.width * sixteen,
                                        fontWeight: FontWeight.w600,
                                        color: textColor),
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                Button(
                                    onTap: () {
                                      Navigator.pop(context, true);
                                    },
                                    text: languages[choosenLanguage]
                                        ['text_thankyou'])
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                  : Container(),
              //loader
              (_isLoading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container(),

              //no internet
              (internet == false)
                  ? Positioned(
                      top: 0,
                      child: NoInternet(
                        onTap: () {
                          internetTrue();
                        },
                      ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
