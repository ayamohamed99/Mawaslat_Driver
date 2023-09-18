import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/review_page.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  State<Invoice> createState() => _InvoiceState();
}

int payby = 0;

class _InvoiceState extends State<Invoice> {
  @override
  void initState() {
    if (driverReq['is_paid'] == 0) {
      payby = 0;
    }
    ispop = true;
    amount.text = driverReq['requestBill']['data']['total_amount'].toString();

    print(
        'print data ${driverReq['requestBill']['data']} data amount ${driverReq['request_eta_amount']}');
    super.initState();
  }

  //paied cash
  TextEditingController amount = TextEditingController();
  // TextEditingController phonenumber = TextEditingController();
  dynamic amountTOPay = driverReq['requestBill']['data']['total_amount'];
  String dropdownValue = 'user';
  bool error = false;
  String errortext = '';
  bool ispop = false;
  bool _isLoading = false;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(value: "user", child: Text("User")),
    ];
    return menuItems;
  }

  navigateLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              return Container(
                  padding: ispop == true && driverReq['payment_opt'] == '1'
                      ? EdgeInsets.zero
                      : EdgeInsets.fromLTRB(
                          media.width * 0.05,
                          MediaQuery.of(context).padding.top +
                              media.width * 0.05,
                          media.width * 0.05,
                          media.width * 0.05),
                  height: media.height * 1,
                  width: media.width * 1,
                  color: page,
                  //invoice data
                  child: (driverReq.isNotEmpty)
                      ? Stack(
                          children: [
                            Padding(
                              padding: ispop == true &&
                                      driverReq['payment_opt'] == '1'
                                  ? const EdgeInsets.all(16)
                                  : EdgeInsets.zero,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            languages[choosenLanguage]
                                                ['text_tripsummary'],
                                            style: GoogleFonts.tajawal(
                                                fontSize: media.width * sixteen,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: media.height * 0.04,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: media.width * 0.13,
                                                width: media.width * 0.13,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            driverReq['userDetail']
                                                                    ['data'][
                                                                'profile_picture']),
                                                        fit: BoxFit.contain)),
                                              ),
                                              SizedBox(
                                                width: media.width * 0.05,
                                              ),
                                              Text(
                                                driverReq['userDetail']['data']
                                                    ['name'],
                                                style: GoogleFonts.tajawal(
                                                  fontSize:
                                                      media.width * eighteen,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: media.height * 0.05,
                                          ),
                                          SizedBox(
                                            width: media.width * 0.72,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          languages[
                                                                  choosenLanguage]
                                                              [
                                                              'text_reference'],
                                                          style: GoogleFonts.tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              color: const Color(
                                                                  0xff898989)),
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Text(
                                                          driverReq[
                                                              'request_number'],
                                                          style: GoogleFonts
                                                              .tajawal(
                                                                  fontSize: media
                                                                          .width *
                                                                      fourteen,
                                                                  color:
                                                                      textColor),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          languages[
                                                                  choosenLanguage]
                                                              ['text_rideType'],
                                                          style: GoogleFonts.tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              color: const Color(
                                                                  0xff898989)),
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Text(
                                                          (driverReq['is_rental'] ==
                                                                  false)
                                                              ? languages[
                                                                      choosenLanguage]
                                                                  [
                                                                  'text_regular']
                                                              : languages[
                                                                      choosenLanguage]
                                                                  [
                                                                  'text_rental'],
                                                          style: GoogleFonts
                                                              .tajawal(
                                                                  fontSize: media
                                                                          .width *
                                                                      fourteen,
                                                                  color:
                                                                      textColor),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: media.height * 0.02,
                                                ),
                                                Container(
                                                  height: 2,
                                                  color:
                                                      const Color(0xffAAAAAA),
                                                ),
                                                SizedBox(
                                                  height: media.height * 0.02,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          languages[
                                                                  choosenLanguage]
                                                              ['text_distance'],
                                                          style: GoogleFonts.tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              color: const Color(
                                                                  0xff898989)),
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Text(
                                                          driverReq[
                                                                  'total_distance'] +
                                                              ' ' +
                                                              driverReq['unit'],
                                                          style: GoogleFonts
                                                              .tajawal(
                                                                  fontSize: media
                                                                          .width *
                                                                      fourteen,
                                                                  color:
                                                                      textColor),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          languages[
                                                                  choosenLanguage]
                                                              ['text_duration'],
                                                          style: GoogleFonts.tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              color: const Color(
                                                                  0xff898989)),
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Text(
                                                          '${driverReq['total_time']} mins',
                                                          style: GoogleFonts
                                                              .tajawal(
                                                                  fontSize: media
                                                                          .width *
                                                                      fourteen,
                                                                  color:
                                                                      textColor),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: media.height * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.info),
                                              SizedBox(
                                                width: media.width * 0.04,
                                              ),
                                              Text(
                                                languages[choosenLanguage]
                                                    ['text_tripfare'],
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * fourteen,
                                                    color: textColor),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: media.height * 0.05,
                                          ),
                                          (driverReq['is_rental'] == true)
                                              ? Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          media.width * 0.05),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        languages[
                                                                choosenLanguage]
                                                            ['text_ride_type'],
                                                        style:
                                                            GoogleFonts.tajawal(
                                                                fontSize: media
                                                                        .width *
                                                                    fourteen,
                                                                color:
                                                                    textColor),
                                                      ),
                                                      Text(
                                                        driverReq[
                                                            'rental_package_name'],
                                                        style:
                                                            GoogleFonts.tajawal(
                                                                fontSize: media
                                                                        .width *
                                                                    fourteen,
                                                                color:
                                                                    textColor),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languages[choosenLanguage]
                                                    ['text_baseprice'],
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                              Text(
                                                driverReq['requestBill']['data']
                                                        [
                                                        'requested_currency_symbol'] +
                                                    ' ' +
                                                    driverReq['requestBill']
                                                                ['data']
                                                            ['total_amount']
                                                        .toString(),
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: media.height * 0.02,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languages[choosenLanguage]
                                                    ['text_distprice'],
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                              Text(
                                                driverReq['requestBill']['data']
                                                        [
                                                        'requested_currency_symbol'] +
                                                    ' ' +
                                                    driverReq['requestBill']
                                                                ['data']
                                                            ['distance_price']
                                                        .toString(),
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: media.height * 0.02,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languages[choosenLanguage]
                                                    ['text_timeprice'],
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                              Text(
                                                driverReq['requestBill']['data']
                                                        [
                                                        'requested_currency_symbol'] +
                                                    ' ' +
                                                    driverReq['requestBill']
                                                                ['data']
                                                            ['time_price']
                                                        .toString(),
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: media.height * 0.02,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languages[choosenLanguage]
                                                        ['text_waiting_price'] +
                                                    ' (' +
                                                    driverReq['requestBill']
                                                            ['data'][
                                                        'requested_currency_symbol'] +
                                                    ' ' +
                                                    driverReq['requestBill']
                                                                ['data'][
                                                            'waiting_charge_per_min']
                                                        .toString() +
                                                    ' x ' +
                                                    driverReq['requestBill']
                                                                ['data'][
                                                            'calculated_waiting_time']
                                                        .toString() +
                                                    ' mins' +
                                                    ')',
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                              Text(
                                                driverReq['requestBill']['data']
                                                        [
                                                        'requested_currency_symbol'] +
                                                    ' ' +
                                                    driverReq['requestBill']
                                                                ['data']
                                                            ['waiting_charge']
                                                        .toString(),
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                            ],
                                          ),
                                          (driverReq['requestBill']['data']
                                                      ['cancellation_fee'] !=
                                                  0)
                                              ? SizedBox(
                                                  height: media.height * 0.02,
                                                )
                                              : Container(),
                                          (driverReq['requestBill']['data']
                                                      ['cancellation_fee'] !=
                                                  0)
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      languages[choosenLanguage]
                                                          ['text_cancelfee'],
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              color: textColor),
                                                    ),
                                                    Text(
                                                      driverReq['requestBill']
                                                                  ['data'][
                                                              'requested_currency_symbol'] +
                                                          ' ' +
                                                          driverReq['requestBill']
                                                                      ['data'][
                                                                  'cancellation_fee']
                                                              .toString(),
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              color: textColor),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          (driverReq['requestBill']['data']
                                                      ['airport_surge_fee'] !=
                                                  0)
                                              ? SizedBox(
                                                  height: media.height * 0.02,
                                                )
                                              : Container(),
                                          (driverReq['requestBill']['data']
                                                      ['airport_surge_fee'] !=
                                                  0)
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      languages[choosenLanguage]
                                                          ['text_surge_fee'],
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              color: textColor),
                                                    ),
                                                    Text(
                                                      driverReq['requestBill']
                                                                  ['data'][
                                                              'requested_currency_symbol'] +
                                                          ' ' +
                                                          driverReq['requestBill']
                                                                      ['data'][
                                                                  'airport_surge_fee']
                                                              .toString(),
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              color: textColor),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: media.height * 0.02,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languages[choosenLanguage]
                                                    ['text_convfee'],
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                              Text(
                                                driverReq['requestBill']['data']
                                                        [
                                                        'requested_currency_symbol'] +
                                                    ' ' +
                                                    driverReq['requestBill']
                                                                ['data']
                                                            ['admin_commision']
                                                        .toString(),
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                            ],
                                          ),
                                          (driverReq['requestBill']['data']
                                                      ['promo_discount'] !=
                                                  null)
                                              ? SizedBox(
                                                  height: media.height * 0.02,
                                                )
                                              : Container(),
                                          (driverReq['requestBill']['data']
                                                      ['promo_discount'] !=
                                                  null)
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      languages[choosenLanguage]
                                                          ['text_discount'],
                                                      style: GoogleFonts
                                                          .tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                    Text(
                                                      driverReq['requestBill']
                                                                  ['data'][
                                                              'requested_currency_symbol'] +
                                                          ' ' +
                                                          driverReq['requestBill']
                                                                      ['data'][
                                                                  'promo_discount']
                                                              .toString(),
                                                      style: GoogleFonts
                                                          .tajawal(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: media.height * 0.02,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languages[choosenLanguage]
                                                    ['text_taxes'],
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                              Text(
                                                driverReq['requestBill']['data']
                                                        [
                                                        'requested_currency_symbol'] +
                                                    ' ' +
                                                    driverReq['requestBill']
                                                                ['data']
                                                            ['service_tax']
                                                        .toString(),
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: media.height * 0.02,
                                          ),
                                          Container(
                                            height: 1.5,
                                            color: const Color(0xffE0E0E0),
                                          ),
                                          SizedBox(
                                            height: media.height * 0.02,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languages[choosenLanguage]
                                                    ['text_totalfare'],
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                              Text(
                                                driverReq['requestBill']['data']
                                                        [
                                                        'requested_currency_symbol'] +
                                                    ' ' +
                                                    driverReq['requestBill']
                                                                ['data']
                                                            ['total_amount']
                                                        .toString(),
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: media.height * 0.02,
                                          ),
                                          Container(
                                            height: 1.5,
                                            color: const Color(0xffE0E0E0),
                                          ),
                                          SizedBox(
                                            height: media.height * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                (driverReq['payment_opt'] ==
                                                        '1')
                                                    ? languages[choosenLanguage]
                                                        ['text_cash']
                                                    : (driverReq[
                                                                'payment_opt'] ==
                                                            '2')
                                                        ? languages[
                                                                choosenLanguage]
                                                            ['text_wallet']
                                                        : languages[
                                                                choosenLanguage]
                                                            ['text_card'],
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * sixteen,
                                                    color: buttonColor),
                                              ),
                                              Text(
                                                driverReq['requestBill']['data']
                                                        [
                                                        'requested_currency_symbol'] +
                                                    ' ' +
                                                    driverReq['requestBill']
                                                                ['data']
                                                            ['total_amount']
                                                        .toString(),
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * twentysix,
                                                    color: textColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  (driverReq['payment_opt'] == '0' &&
                                          driverReq['is_paid'] == 0)
                                      ? Container(
                                          height: media.width * 0.12,
                                          width: media.width * 0.9,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: borderLines),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                languages[choosenLanguage]
                                                    ['text_waitingforpayment'],
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * fourteen,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.05,
                                              ),
                                              SizedBox(
                                                  height: media.width * 0.05,
                                                  width: media.width * 0.05,
                                                  child:
                                                      const CircularProgressIndicator())
                                            ],
                                          ),
                                        )
                                      // ? Row(
                                      //     children: [
                                      //       Expanded(
                                      //         child: Button(
                                      //           onTap: () {},
                                      //           text: languages[choosenLanguage]
                                      //               ['text_cash'],
                                      //         ),
                                      //       ),
                                      //       const SizedBox(width: 10),
                                      //       Expanded(
                                      //         child: Container(
                                      //           height: media.width * 0.12,
                                      //           // width: media.width * 0.9,
                                      //           decoration: BoxDecoration(
                                      //               borderRadius:
                                      //                   BorderRadius.circular(12),
                                      //               color: borderLines),
                                      //           child: Row(
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment.center,
                                      //             children: [
                                      //               Text(
                                      //                 languages[choosenLanguage]
                                      //                     ['text_waitingforpayment'],
                                      //                 style: GoogleFonts.tajawal(
                                      //                     fontSize:
                                      //                         media.width * fourteen,
                                      //                     fontWeight: FontWeight.w600),
                                      //                 textAlign: TextAlign.center,
                                      //                 maxLines: 1,
                                      //               ),
                                      //               SizedBox(
                                      //                 width: media.width * 0.01,
                                      //               ),
                                      //               SizedBox(
                                      //                   height: media.width * 0.05,
                                      //                   width: media.width * 0.05,
                                      //                   child:
                                      //                       const CircularProgressIndicator())
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       )
                                      //     ],
                                      //   )
                                      : Button(
                                          onTap: () {
                                            speak(
                                                '${languages[choosenLanguage]['way_to_pay']} ${(driverReq['payment_opt'] == '1') ? languages[choosenLanguage]['text_cash'] : (driverReq['payment_opt'] == '2') ? languages[choosenLanguage]['text_wallet'] : languages[choosenLanguage]['text_card']}');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Review(),
                                              ),
                                            );
                                          },
                                          text: languages[choosenLanguage]
                                              ['text_confirm'],
                                        )
                                ],
                              ),
                            ),
                            if (ispop == true &&
                                driverReq['payment_opt'] == '1')
                              Positioned(
                                top: 0,
                                child: Container(
                                  height: media.height * 1,
                                  width: media.width * 1,
                                  color: Colors.transparent.withOpacity(0.6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(
                                              media.width * 0.05),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: page),
                                          width: media.width * 0.8,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: page,
                                                  ),
                                                  dropdownColor: page,
                                                  value: dropdownValue,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      dropdownValue = newValue!;
                                                    });
                                                  },
                                                  items: dropdownItems),
                                              InputField(
                                                  text:
                                                      '${amountTOPay.toStringAsFixed(2)}',
                                                  textController: amount,
                                                  inputType:
                                                      TextInputType.number),
                                              // InputField(
                                              //     text: languages[choosenLanguage]
                                              //         ['text_phone_number'],
                                              //     textController: phonenumber,
                                              //     inputType: TextInputType.number),
                                              TextFormField(
                                                // maxLength: countries[phcode]
                                                //     ['dial_max_length'],
                                                enabled: false,
                                                style: GoogleFonts.tajawal(
                                                    fontSize:
                                                        media.width * sixteen,
                                                    color: textColor,
                                                    letterSpacing: 1),
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      driverReq['userDetail']
                                                              ['data']['mobile']
                                                          .toString()
                                                          .replaceAll(
                                                              '+20', ''),
                                                  counterText: '',
                                                  hintStyle:
                                                      GoogleFonts.tajawal(
                                                          fontSize: media
                                                                  .width *
                                                              sixteen,
                                                          color: textColor
                                                              .withOpacity(
                                                                  0.7)),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                    color:
                                                        inputfocusedUnderline,
                                                    width: 1.2,
                                                    style: BorderStyle.solid,
                                                  )),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                    color: inputUnderline,
                                                    width: 1.2,
                                                    style: BorderStyle.solid,
                                                  )),
                                                ),
                                              ),
                                              SizedBox(
                                                height: media.width * 0.05,
                                              ),
                                              error == true
                                                  ? Text(
                                                      errortext,
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                height: media.width * 0.05,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Button(
                                                      width: media.width * 0.2,
                                                      height:
                                                          media.width * 0.09,
                                                      onTap: () async {
                                                        setState(() {
                                                          _isLoading = true;
                                                        });
                                                        if (driverReq['userDetail']
                                                                            [
                                                                            'data']
                                                                        [
                                                                        'mobile']
                                                                    .toString()
                                                                    .replaceAll(
                                                                        '+20',
                                                                        '') ==
                                                                '' ||
                                                            amount.text == '') {
                                                          setState(() {
                                                            error = true;
                                                            errortext = languages[
                                                                    choosenLanguage]
                                                                [
                                                                'text_fill_fileds'];
                                                            _isLoading = false;
                                                          });
                                                        } else {
                                                          var result = await sharewalletfun(
                                                              amount: (amount
                                                                          .text
                                                                          .toDouble() -
                                                                      amountTOPay
                                                                          .toDouble())
                                                                  .toString(),
                                                              mobile: driverReq[
                                                                              'userDetail']
                                                                          [
                                                                          'data']
                                                                      ['mobile']
                                                                  .toString()
                                                                  .replaceAll(
                                                                      '+20',
                                                                      ''),
                                                              role:
                                                                  dropdownValue);
                                                          if (result ==
                                                              'success') {
                                                            // navigate();
                                                            setState(() {
                                                              ispop = false;
                                                              dropdownValue =
                                                                  'user';
                                                              error = false;
                                                              errortext = '';
                                                              // phonenumber.text = '';
                                                              amount.text = '';
                                                            });
                                                          } else if (result ==
                                                              'logout') {
                                                            navigateLogout();
                                                          } else {
                                                            setState(() {
                                                              error = true;
                                                              errortext = result
                                                                  .toString();
                                                              _isLoading =
                                                                  false;
                                                            });
                                                          }
                                                        }
                                                      },
                                                      text: languages[
                                                              choosenLanguage]
                                                          ['text_confirm']),
                                                ],
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        )
                      : Container());
            }),
      ),
    );
  }
}
