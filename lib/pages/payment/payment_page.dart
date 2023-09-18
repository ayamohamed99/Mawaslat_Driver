// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/invoice.dart';
import 'package:tagyourtaxi_driver/pages/payment/paymob_man.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  static Future<bool?> navigate(
    BuildContext context, {
    required double amount,
    bool isPay = false,
    bool isManage = false,
  }) {
    return Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          amount: amount,
          isPay: isPay,
          isManage: isManage,
        ),
      ),
    );
  }

  const PaymentScreen({
    Key? key,
    required this.amount,
    this.isPay = false,
    this.isManage = false,
  }) : super(key: key);
  final double amount;
  final bool isPay;
  final bool isManage;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = true;
  String? paymentUrl;
  String? orderId;

  List<CardData> cards = [];

  bool loadWebView = false;

  @override
  void initState() {
    super.initState();
    // chooseAnother = true;
    // isLoading = false;
    init();
  }

  init() async {
    // await _addTestCards();
    final tempCards = PaymobMan.getCards();
    if (tempCards.isEmpty && !widget.isManage) {
      await startPayRoutine();
    } else {
      setState(() {
        cards = tempCards;
        isLoading = false;
      });
    }
  }

  Future startPayRoutine() async {
    final res =
        await PaymobMan.payWithCard((widget.amount * 100).toInt().toString());
    if (res == null) {
      return Navigator.pop(context, false);
    }
    paymentUrl = res["pay_url"];
    orderId = res["order_id"];

    setState(() {
      isLoading = false;
      loadWebView = true;
    });
  }

  Future<void> onPaymentSuccess([
    String? ordId,
    bool dontSave = false,
  ]) async {
    setState(() {
      isLoading = true;
    });
    if (!dontSave) {
      await PaymobMan.saveCardDetails(orderId!);
    }
    dynamic val3;
    if (widget.isPay) {
      val3 = await payMoneyStripe(ordId ?? orderId!);
    } else {
      val3 = await addMoneyStripe(widget.amount, ordId ?? orderId);
    }
    if (val3 == 'success') {
      if (widget.isPay) {
        await getUserDetails();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Invoice()),
            (route) => false);
      } else if (widget.isManage) {
        // await Future.delayed(const Duration(seconds: 3));
        final tempCards = PaymobMan.getCards();
        setState(() {
          cards = tempCards;
          isLoading = false;
          loadWebView = false;
        });
      } else {
        return Navigator.pop(context, true);
      }
    } else if (val3 == 'logout') {
      return navigateLogout();
    } else {
      return Navigator.pop(context, false);
    }
  }

  bool chooseAnother = false;
  bool isPayFailed = false;

  onPaymentFailed() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    if (widget.isManage) {
      final tempCards = PaymobMan.getCards();
      setState(() {
        cards = tempCards;
        isLoading = false;
        loadWebView = false;
      });
      return;
    }
    if (widget.isPay) {
      setState(() {
        loadWebView = false;
        isPayFailed = true;
        isLoading = false;
      });
      return;
    }
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Payment",
                      style: GoogleFonts.rubik(
                        fontSize: media.width * twenty,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                if (widget.isPay)
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final txt = choosenLanguage == "en"
                              ? "Problem with credit card entry, choose another payment method."
                              : "مشكلة في إدخال بيانات الكارد، اختار طريقة دفع أخري.";
                          return AlertDialog(
                            insetPadding: const EdgeInsets.all(10),
                            icon: const Icon(Icons.info),
                            content: Text(
                              txt,
                              style: GoogleFonts.rubik(
                                fontSize: media.width * sixteen,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            actions: [
                              Button(
                                text: choosenLanguage == "en"
                                    ? "Cancel"
                                    : "الغاء",
                                width: media.width * 0.4,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Button(
                                text: choosenLanguage == "en" ? "Ok" : "موافق",
                                width: media.width * 0.4,
                                color: Colors.blue,
                                onTap: () {
                                  setState(() {
                                    chooseAnother = true;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.info),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildBody(media),
                ),
                if (isLoading) const Loading(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(Size media) {
    if (chooseAnother) return chooseAnotherPayment(media);
    if (loadWebView) return _buildWebView();
    return _buildCards(media);
  }

// showDialog(){
//
//                                     await showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           var searchVal = '';
//                                           return AlertDialog(
//                                             insetPadding:
//                                                 const EdgeInsets.all(10),
//                                             content: StatefulBuilder(
//                                                 builder: (context, setState) {
//                                               return Container(
//                                                 width: media.width * 0.9,
//                                                 color: Colors.white,
//                                                 child: Directionality(
//                                                   textDirection:
//                                                       (languageDirection ==
//                                                               'rtl')
//                                                           ? TextDirection.rtl
//                                                           : TextDirection.ltr,
//                                                   child: Column(
//                                                     children: [
//                                                       Container(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .only(
//                                                                 left: 20,
//                                                                 right: 20),
//                                                         height: 40,
//                                                         width:
//                                                             media.width * 0.9,
//                                                         decoration: BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         20),
//                                                             border: Border.all(
//                                                                 color:
//                                                                     Colors.grey,
//                                                                 width: 1.5)),
//                                                         child: TextField(
//                                                           decoration: InputDecoration(
//                                                               contentPadding: (languageDirection ==
//                                                                       'rtl')
//                                                                   ? EdgeInsets.only(
//                                                                       bottom: media.width *
//                                                                           0.035)
//                                                                   : EdgeInsets.only(
//                                                                       bottom: media.width *
//                                                                           0.04),
//                                                               border: InputBorder
//                                                                   .none,
//                                                               hintText:
//                                                                   languages[choosenLanguage]
//                                                                       [
//                                                                       'text_search'],
//                                                               hintStyle: GoogleFonts.roboto(
//                                                                   fontSize: media
//                                                                           .width *
//                                                                       sixteen)),
//                                                           onChanged: (val) {
//                                                             setState(() {
//                                                               searchVal = val;
//                                                             });
//                                                           },
//                                                         ),
//                                                       ),
//                                                       const SizedBox(
//                                                           height: 20),
//                                                       Expanded(
//                                                         child:
//                                                             SingleChildScrollView(
//                                                           child: Column(
//                                                             children: countries
//                                                                 .asMap()
//                                                                 .map(
//                                                                     (i, value) {
//                                                                   return MapEntry(
//                                                                       i,
//                                                                       SizedBox(
//                                                                         width: media.width *
//                                                                             0.9,
//                                                                         child: (searchVal == '' &&
//                                                                                 countries[i]['flag'] != null)
//                                                                             ? InkWell(
//                                                                                 onTap: () {
//                                                                                   setState(() {
//                                                                                     phcode = i;
//                                                                                   });
//                                                                                   Navigator.pop(context);
//                                                                                 },
//                                                                                 child: Container(
//                                                                                   padding: const EdgeInsets.only(top: 10, bottom: 10),
//                                                                                   color: Colors.white,
//                                                                                   child: Row(
//                                                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                                     children: [
//                                                                                       Row(
//                                                                                         children: [
//                                                                                           Image.network(countries[i]['flag']),
//                                                                                           SizedBox(
//                                                                                             width: media.width * 0.02,
//                                                                                           ),
//                                                                                           SizedBox(
//                                                                                               width: media.width * 0.4,
//                                                                                               child: Text(
//                                                                                                 countries[i]['name'],
//                                                                                                 style: GoogleFonts.roboto(fontSize: media.width * sixteen),
//                                                                                               )),
//                                                                                         ],
//                                                                                       ),
//                                                                                       Text(
//                                                                                         countries[i]['dial_code'],
//                                                                                         style: GoogleFonts.roboto(fontSize: media.width * sixteen),
//                                                                                       )
//                                                                                     ],
//                                                                                   ),
//                                                                                 ))
//                                                                             : (countries[i]['flag'] != null && countries[i]['name'].toLowerCase().contains(searchVal.toLowerCase()))
//                                                                                 ? InkWell(
//                                                                                     onTap: () {
//                                                                                       setState(() {
//                                                                                         phcode = i;
//                                                                                       });
//                                                                                       Navigator.pop(context);
//                                                                                     },
//                                                                                     child: Container(
//                                                                                       padding: const EdgeInsets.only(top: 10, bottom: 10),
//                                                                                       color: Colors.white,
//                                                                                       child: Row(
//                                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                                         children: [
//                                                                                           Row(
//                                                                                             children: [
//                                                                                               Image.network(countries[i]['flag']),
//                                                                                               SizedBox(
//                                                                                                 width: media.width * 0.02,
//                                                                                               ),
//                                                                                               SizedBox(
//                                                                                                   width: media.width * 0.4,
//                                                                                                   child: Text(
//                                                                                                     countries[i]['name'],
//                                                                                                     style: GoogleFonts.roboto(fontSize: media.width * sixteen),
//                                                                                                   )),
//                                                                                             ],
//                                                                                           ),
//                                                                                           Text(
//                                                                                             countries[i]['dial_code'],
//                                                                                             style: GoogleFonts.roboto(fontSize: media.width * sixteen),
//                                                                                           )
//                                                                                         ],
//                                                                                       ),
//                                                                                     ))
//                                                                                 : Container(),
//                                                                       ));
//                                                                 })
//                                                                 .values
//                                                                 .toList(),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             }),
//                                           );
//                                         });}
  Widget chooseAnotherPayment(Size media) {
    // TODO (abdelaziz): Custom to show pay cash or wallet
    return Column(
      children: [
        InkWell(
          onTap: () async {
            print("pay cash");

            final result = await PaymobMan.payWithOtherOption(isCash: true);
            if (result == 'success') {
              await getUserDetails();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Invoice()),
                  (route) => false);
            } else if (result == 'logout') {
              return navigateLogout();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                result,
              )));
              return Navigator.pop(context, false);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  choosenLanguage == "en" ? "Cash" : "نقدي",
                  style: GoogleFonts.rubik(
                    fontSize: media.width * sixteen,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const Expanded(child: SizedBox()),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () async {
            final result = await PaymobMan.payWithOtherOption(isWallet: true);
            if (result == 'success') {
              await getUserDetails();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Invoice()),
                  (route) => false);
            } else if (result == 'logout') {
              return navigateLogout();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                result,
              )));
              return Navigator.pop(context, false);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  choosenLanguage == "en" ? "Wallet" : "محفظة",
                  style: GoogleFonts.rubik(
                    fontSize: media.width * sixteen,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const Expanded(child: SizedBox()),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        )
      ],
    );
  }

  navigateLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

  bool lockExecute = false;

  WebView _buildWebView() {
    return WebView(
      initialUrl: paymentUrl,
      javascriptMode: JavascriptMode.unrestricted,
      userAgent: 'Flutter;Webview',
      navigationDelegate: (navigation) {
        if (navigation.url.contains("mwaslat-paymob-x2tv3mj2ma-nw.a.run.app")) {
          final uri = Uri.parse(navigation.url);
          final success = uri.queryParameters["success"];
          final pending = uri.queryParameters["pending"];
          if (success == 'true' || pending == 'true') {
            onPaymentSuccess();
          } else {
            onPaymentFailed();
          }
        }
        return NavigationDecision.navigate;
      },
    );
  }

  Widget _buildCards(Size media) {
    return Column(
      children: [
        ...cards.map((e) => _buildSingleCard(e, media)).toList(),
        InkWell(
          onTap: () {
            startPayRoutine();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  "Add new card ",
                  style: GoogleFonts.rubik(
                    fontSize: media.width * sixteen,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const Expanded(child: SizedBox()),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        if (isPayFailed)
          const SizedBox(
            height: 10,
          ),
        if (isPayFailed)
          InkWell(
            onTap: () {
              setState(() {
                chooseAnother = true;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    choosenLanguage == 'en'
                        ? "Choose Another method"
                        : "اختر طريقة إضافية",
                    style: GoogleFonts.rubik(
                      fontSize: media.width * sixteen,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          )
      ],
    );
  }

  Widget _buildSingleCard(CardData card, Size media) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Slidable(
            key: Key(card.token),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await PaymobMan.deleteCard(card);
                    cards = PaymobMan.getCards();
                    setState(() {});
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: InkWell(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final ordId = await PaymobMan.payWithSavedCard(
                      (widget.amount * 100).toString(), card.token);
                  if (ordId != null) {
                    onPaymentSuccess(ordId.toString(), true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Payment failed"),
                      ),
                    );

                    Navigator.pop(context, false);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        "${card.card_subtype}: ",
                        style: GoogleFonts.roboto(
                          fontSize: media.width * sixteen,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      Text(
                        card.masked_pan,
                        style: GoogleFonts.roboto(
                          fontSize: media.width * sixteen,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
