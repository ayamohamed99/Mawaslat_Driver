// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';

class PaymobMan {
  static late Box<Map> _box;

  static Future<void> init() async {
    Hive.init((await getApplicationSupportDirectory()).path);
    _box = await Hive.openBox<Map>("paymob_cards");
  }

  static const _apiKey =
      "ZXlKMGVYQWlPaUpLVjFRaUxDSmhiR2NpT2lKSVV6VXhNaUo5LmV5SnVZVzFsSWpvaWFXNXBkR2xoYkNJc0ltTnNZWE56SWpvaVRXVnlZMmhoYm5RaUxDSndjbTltYVd4bFgzQnJJam94TXpnM09EZDkuZVhLaG9rajJkSThzMmFtdUFINjR5bnNmV2l0SjM5ZzlVYnFMUjN2TUEtZjVGLVdyTldwY1ZfYlRxWTdtMDd0alFXbVhkQVNoVVdfVnF6dnB1NUsyTnc=";
  static const _integrationId = _prodInt;
  // static const _testInt = "1572966";
  static const _prodInt = "4042253";
  static const _iframeId = "311445";

  static Future<void> saveCardDetails(String orderId) async {
    final res = await FirebaseFirestore.instance
        .collection("cards_tokens")
        .doc(orderId)
        .get();
    if (res.exists) {
      final model = CardData.fromMap(res.data()!);
      await _box.put(model.token, model.toMap());
    }
  }

  static Future<String> payWithOtherOption({
    bool isCash = false,
    bool isWallet = false,
    bool isCard = false,
  }) async {
    String result = "";
    print("req headers: ${{
            'Authorization': 'Bearer ${bearerToken[0].token}',
            'Content-Type': 'application/json'
          }}");
    print("req body: ${{
            'trip_id': userRequestData['id'],
            'payment_id': isCash
                ? 1
                : isWallet
                    ? 2
                    : isCard
                        ? 0
                        : 3
          }}");
    try {
      var response = await http.post(
          Uri.parse('${url}api/v1/payment/ChangePaymentGateway'),
          headers: {
            'Authorization': 'Bearer ${bearerToken[0].token}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'trip_id': userRequestData['id'],
            'payment_id': isCash
                ? 1
                : isWallet
                    ? 2
                    : isCard
                        ? 0
                        : 3
          }));
      if (response.statusCode == 200) {
        result = 'success';
      } else if (response.statusCode == 401) {
        result = 'logout';
      } else {
        debugPrint(response.body);
        print(jsonDecode(response.body));
        result = 'failure';
      }
    } catch (e) {
      if (e is SocketException) {
        internet = false;
        result = 'no internet';
      }
    }
    print("result: $result");
    return result;
  }

  static Future<void> deleteCard(CardData card) async {
    await _box.delete(card.token);
  }

  static Future<void> putCard(CardData card) async {
    await _box.put(card.token, card.toMap());
  }

  static List<CardData> getCards() {
    return _box.values.map((e) => CardData.fromMap(e)).toList();
  }

  static Future<Map<String, String>?> payWithCard(String amountCent) async {
    final authToken = await _authApi();
    if (authToken == null) return null;
    final orderId = await _registerOrder(authToken, amountCent);
    if (orderId == null) return null;
    final paymentToken = await _createPayment(authToken, amountCent, orderId);
    if (paymentToken == null) return null;
    final payUrl = _EndPoints.iframeUrl(_iframeId, paymentToken);
    _saveFBStep({
      "authToken": authToken,
      "orderId": orderId,
      "paymentToken": paymentToken,
      "payUrl": payUrl,
    });

    return {
      "payment_token": paymentToken,
      "pay_url": payUrl,
      "order_id": orderId.toString(),
    };
  }

  static _saveFBStep(Map<String, dynamic> map) async {
    await FirebaseFirestore.instance
        .collection("debug")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(map);
  }

  static Future<int?> payWithSavedCard(
    String amountCent,
    String cardToken,
  ) async {
    final authToken = await _authApi();
    if (authToken == null) return null;
    final orderId = await _registerOrder(authToken, amountCent);
    if (orderId == null) return null;
    final paymentToken = await _createPayment(authToken, amountCent, orderId);
    if (paymentToken == null) return null;
    final res = await _chargeCard(paymentToken, cardToken);
    _saveFBStep({
      "authToken": authToken,
      "orderId": orderId,
      "paymentToken": paymentToken,
      "res": res,
    });

    if (!res) return null;
    return orderId;
  }

  static Future<bool> _chargeCard(
    String paymentToken,
    String cardToken,
  ) async {
    final res = await http.post(
      Uri.parse(_EndPoints.chargeCard),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "source": {
          "identifier": cardToken,
          "subtype": "TOKEN",
        },
        "payment_token": paymentToken,
      }),
    );
    if (res.statusCode == 200) {
      final success = jsonDecode(res.body)["success"];
      final pending = jsonDecode(res.body)["pending"];
      if (success == "true" || pending == "true") return true;
    }
    return false;
  }

  static Future<String?> _authApi() async {
    final res = await http.post(
      Uri.parse(_EndPoints.auth),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "api_key": _apiKey,
      }),
    );
    if (res.statusCode == 201) {
      return jsonDecode(res.body)["token"];
    }
    return null;
  }

  static Future<int?> _registerOrder(
      String authToken, String amountCent) async {
    final res = await http.post(
      Uri.parse(_EndPoints.regOrder),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "auth_token": authToken,
        "delivery_needed": "false",
        "amount_cents": amountCent,
        "currency": "EGP",
      }),
    );
    if (res.statusCode == 201) {
      return jsonDecode(res.body)["id"];
    }
    return null;
  }

  static Future<String?> _createPayment(
    String authToken,
    String amountCent,
    int orderId,
  ) async {
    // {id: 26, name: test, last_name: null, username: null, email: test@test.com, mobile: +201062100565, profile_picture: https://mwaslat.app/public/assets/images/default-profile-picture.jpeg, active: 1, email_confirmed: 0, mobile_confirmed: 1, last_known_ip: 197.63.241.9, last_login_at: 2023-07-20 10:53:18, rating: 5, no_of_ratings: 1, refferal_code: KkBcV6, currency_code: EGP, currency_symbol: EGP, country_code: EG, mqtt_ip: 54.172.163.200, show_rental_ride: false, show_ride_later_feature: true, notifications_count: 0, contact_us_mobile1: +201021201201, contact_us_mobile2: +201001868638, contact_us_link: https://mwaslat.app/public/, show_wallet_feature_on_mobile_app: 1, show_bank_info_feature_on_mobile_app: 1, referral_comission_string: Refer a friend and earnEGP100, user_can_make_a_ride_after_x_miniutes: 30, maximum_time_for_find_drivers_for_regular_ride: 300, maximum_time_for_find_drivers_for_bitting_ride: 300, enable_country_restrict_on_map: 0, show_ride_without_destination: 0, sos: {data: [{id: d8b5b734-9232
    final res = await http.post(
      Uri.parse(_EndPoints.creatPayment),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "auth_token": authToken,
        "amount_cents": amountCent,
        "expiration": 3600,
        "order_id": orderId.toString(),
        "currency": "EGP",
        "integration_id": _integrationId,
        "lock_order_when_paid": "false",
        "billing_data": {
          "apartment": "NA",
          "email": userDetails["email"],
          "floor": "NA",
          "first_name": userDetails["name"],
          "street": "NA",
          "building": "NA",
          "phone_number": userDetails["mobile"],
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "last_name": userDetails["last_name"] ?? userDetails["name"],
          "state": "NA"
        },
      }),
    );

    if (res.statusCode == 201) {
      return jsonDecode(res.body)["token"];
    }
    return null;
  }
}

class _EndPoints {
  static const auth = "https://accept.paymobsolutions.com/api/auth/tokens";
  static const regOrder =
      "https://accept.paymobsolutions.com/api/ecommerce/orders";
  static const creatPayment =
      "https://accept.paymobsolutions.com/api/acceptance/payment_keys";
  static String iframeUrl(iframeId, token) =>
      "https://accept.paymobsolutions.com/api/acceptance/iframes/$iframeId?payment_token=$token";
  static const chargeCard =
      "https://accept.paymob.com/api/acceptance/payments/pay";
}

class CardData {
  final int id;
  final String token;
  final String masked_pan;
  final int merchant_id;
  final String card_subtype;
  final String created_at;
  final String email;
  final String order_id;
  CardData({
    required this.id,
    required this.token,
    required this.masked_pan,
    required this.merchant_id,
    required this.card_subtype,
    required this.created_at,
    required this.email,
    required this.order_id,
  });

  CardData copyWith({
    int? id,
    String? token,
    String? masked_pan,
    int? merchant_id,
    String? card_subtype,
    String? created_at,
    String? email,
    String? order_id,
  }) {
    return CardData(
      id: id ?? this.id,
      token: token ?? this.token,
      masked_pan: masked_pan ?? this.masked_pan,
      merchant_id: merchant_id ?? this.merchant_id,
      card_subtype: card_subtype ?? this.card_subtype,
      created_at: created_at ?? this.created_at,
      email: email ?? this.email,
      order_id: order_id ?? this.order_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'token': token,
      'masked_pan': masked_pan,
      'merchant_id': merchant_id,
      'card_subtype': card_subtype,
      'created_at': created_at,
      'email': email,
      'order_id': order_id,
    };
  }

  factory CardData.fromMap(Map map) {
    return CardData(
      id: map['id'] as int,
      token: map['token'] as String,
      masked_pan: map['masked_pan'] as String,
      merchant_id: map['merchant_id'] as int,
      card_subtype: map['card_subtype'] as String,
      created_at: map['created_at'] as String,
      email: map['email'] as String,
      order_id: map['order_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardData.fromJson(String source) =>
      CardData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CardData(id: $id, token: $token, masked_pan: $masked_pan, merchant_id: $merchant_id, card_subtype: $card_subtype, created_at: $created_at, email: $email, order_id: $order_id)';
  }

  @override
  bool operator ==(covariant CardData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.token == token &&
        other.masked_pan == masked_pan &&
        other.merchant_id == merchant_id &&
        other.card_subtype == card_subtype &&
        other.created_at == created_at &&
        other.email == email &&
        other.order_id == order_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        token.hashCode ^
        masked_pan.hashCode ^
        merchant_id.hashCode ^
        card_subtype.hashCode ^
        created_at.hashCode ^
        email.hashCode ^
        order_id.hashCode;
  }
}
