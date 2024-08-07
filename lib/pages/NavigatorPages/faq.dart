import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';

class Faq extends StatefulWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  bool _faqCompleted = false;
  dynamic _selectedQuestion;
  bool _isLoading = true;

  @override
  void initState() {
    faqDatas();
    super.initState();
  }

  navigateLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

//get faq datas

  faqDatas() async {
    var val = await getFaqData(center.latitude, center.longitude);
    if (mounted) {
      if (val == 'logout') {
        navigateLogout();
      }
      setState(() {
        _isLoading = false;
        _faqCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: ValueListenableBuilder(
          valueListenable: valueNotifierHome.value,
          builder: (context, value, child) {
            return Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Stack(
                children: [
                  Container(
                    height: media.height * 1,
                    width: media.width * 1,
                    color: page,
                    padding: EdgeInsets.fromLTRB(media.width * 0.05,
                        media.width * 0.05, media.width * 0.05, 0),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top),
                        Stack(
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.only(bottom: media.width * 0.05),
                              width: media.width * 1,
                              alignment: Alignment.center,
                              child: Text(
                                languages[choosenLanguage]['text_faq'],
                                style: GoogleFonts.tajawal(
                                    fontSize: media.width * twenty,
                                    fontWeight: FontWeight.w600,
                                    color: textColor),
                              ),
                            ),
                            Positioned(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.arrow_back)))
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        SizedBox(
                          width: media.width * 0.9,
                          height: media.height * 0.16,
                          child: Image.asset(
                            'assets/images/faqPage.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: (faqData.isNotEmpty)
                                ? Column(
                                    children: faqData
                                        .asMap()
                                        .map((i, value) {
                                          return MapEntry(
                                              i,
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedQuestion = i;
                                                  });
                                                },
                                                child: Container(
                                                  width: media.width * 0.9,
                                                  margin: EdgeInsets.only(
                                                      top: media.width * 0.025,
                                                      bottom:
                                                          media.width * 0.025),
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.05),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: page,
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2)),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                              // color: Colors.red,
                                                              width:
                                                                  media.width *
                                                                      0.7,
                                                              child: Text(
                                                                faqData[i][
                                                                    'question'],
                                                                style: GoogleFonts.tajawal(
                                                                    fontSize: media
                                                                            .width *
                                                                        fourteen,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        textColor),
                                                              )),
                                                          RotatedBox(
                                                              quarterTurns:
                                                                  (_selectedQuestion ==
                                                                          i)
                                                                      ? 2
                                                                      : 0,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/chevron-down.png',
                                                                width: media
                                                                        .width *
                                                                    0.075,
                                                              ))
                                                        ],
                                                      ),
                                                      AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        // padding: EdgeInsets.only(top: media.width*0.025),
                                                        child: (_selectedQuestion ==
                                                                i)
                                                            ? Container(
                                                                padding: EdgeInsets.only(
                                                                    top: media
                                                                            .width *
                                                                        0.025),
                                                                child: Text(
                                                                  faqData[i][
                                                                      'answer'],
                                                                  style: GoogleFonts.tajawal(
                                                                      fontSize:
                                                                          media.width *
                                                                              twelve,
                                                                      color:
                                                                          textColor),
                                                                ))
                                                            : Container(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        })
                                        .values
                                        .toList(),
                                  )
                                : (_faqCompleted == true)
                                    ? Text(
                                        languages[choosenLanguage]
                                            ['text_noDataFound'],
                                        style: GoogleFonts.tajawal(
                                            fontSize: media.width * eighteen,
                                            fontWeight: FontWeight.w600,
                                            color: textColor),
                                      )
                                    : Container(),
                          ),
                        )
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
                                _isLoading = true;
                                _faqCompleted = false;
                                faqDatas();
                              });
                            },
                          ))
                      : Container(),
                  //loader
                  (_isLoading == true)
                      ? const Positioned(top: 0, child: Loading())
                      : Container()
                ],
              ),
            );
          }),
    );
  }
}
