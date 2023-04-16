import 'dart:async';
import 'dart:io';

import 'package:chat_gpt/screens/premium_pages/premium_screen_controller.dart';
import 'package:chat_gpt/theme/theme_services.dart';
import 'package:chat_gpt/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../constant/app_color.dart';
import '../../constant/app_icon.dart';
import '../../modals/premium_modal.dart';
import '../../utils/iap_services.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final premiumController = Get.put(PremiumScreenController());

  List<PremiumModal> premiumList = [
    PremiumModal(
        month: '1',
        price: 'premiumPrice1'.tr,
        monthType: 'month'.tr,
        perMonth: '9.99',
        priceWeek: 'perMonth'.tr,
        offer: 'offer1'.tr),
    PremiumModal(
        month: '1',
        price: 'premiumPrice2'.tr,
        monthType: 'week'.tr,
        perMonth: '2.99',
        priceWeek: 'perWeek'.tr,
        offer: 'offer2'.tr),
    PremiumModal(
        month: '12',
        price: 'premiumPrice3'.tr,
        monthType: 'month'.tr,
        perMonth: '99.99',
        priceWeek: 'perYear'.tr,
        offer: 'offer3'.tr),
  ];

  bool isAvailable = false;
  List<String> noFoundId = [];
  String? uid;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List productsList = [
    // ProductDetails(id: '1', title: 'title', description: 'description', price: '799.00', rawPrice: 799.00, currencyCode: 'INR',currencySymbol: "₹"),
    // ProductDetails(id: '2', title: 'title', description: 'description', price: '399.00', rawPrice: 399.00, currencyCode: 'INR',currencySymbol: "₹"),
    // ProductDetails(id: '3', title: 'title', description: 'description', price: '4999.00', rawPrice: 4999.00, currencyCode: 'INR',currencySymbol: "₹"),
  ];

  int selectedIndex = 1;

  @override
  void initState() {
    _subscription = InAppPurchase.instance.purchaseStream.listen(
        (List<PurchaseDetails> purchaseDetailsList) {
      IapService()
          .listenToPurchaseUpdated(purchaseDetailsList: purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {});

    initialStore();
    super.initState();
  }

  initialStore() async {
    productsList = await IapService().initStoreInfo(
        isAvailable: isAvailable,
        id: Platform.isAndroid ? androidList : iosList,
        noFoundId: noFoundId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: context.theme.backgroundColor,
          // titleSpacing: 40,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.close, color: context.textTheme.headline1!.color),
          ),
          centerTitle: true,
          title: appBarTitle(context).marginOnly(left: 0),
          actions: [
            CupertinoButton(
              onPressed: () {},
              child: Text("restore".tr, style: const TextStyle(fontSize: 12)),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            10.0.addHSpace(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(7)),
              child: Column(
                children: [
                  10.0.addHSpace(),
                  Text(
                    "premiumAdvanced".tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  5.0.addHSpace(),
                  const Divider(
                    color: Color(0xff2F2F2F),
                  ),
                  5.0.addHSpace(),
                  advancedListTile(context, title: "premiumSub1".tr),

                  10.0.addHSpace(),
                  advancedListTile(context, title: 'premiumSub2'.tr),

                  10.0.addHSpace(),
                  advancedListTile(context, title: 'premiumSub3'.tr),

                  10.0.addHSpace(),
                  advancedListTile(context, title: 'premiumSub4'.tr),

                  // 10.0.addHSpace(),
                  // advancedListTile(context, title: 'premiumSub5'.tr),

                  10.0.addHSpace(),
                ],
              ).marginSymmetric(horizontal: 20),
            ).marginSymmetric(horizontal: 20),
            30.0.addHSpace(),
            Obx(() {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                    premiumList.length,
                    (index) => Expanded(
                          child: GestureDetector(
                              onTap: () {
                                premiumController.onChangeIndex(index);
                              },
                              child: premiumController.selectedI.value == index
                                  ? Container(
                                      height: 275,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff4EA37E),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        children: [
                                          5.0.addHSpace(),
                                          Text(
                                            premiumList[index].offer,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ).marginOnly(top: 5),
                                          10.0.addHSpace(),
                                          Container(
                                            height: 220,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: const Color(0xff1A2620),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                15.0.addHSpace(),
                                                Text(
                                                  premiumList[index].month,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 25),
                                                ),
                                                10.0.addHSpace(),
                                                Text(
                                                  premiumList[index].monthType,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 25),
                                                ),
                                                20.0.addHSpace(),
                                                Text(
                                                  premiumList[index].price,
                                                  style: const TextStyle(
                                                      color: Color(0xff787C7A),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12),
                                                ),
                                                10.0.addHSpace(),
                                                const Divider(
                                                  color: Color(0xff4EA37E),
                                                  thickness: 2,
                                                ),
                                                10.0.addHSpace(),
                                                Text(
                                                  premiumList[index].perMonth,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 17),
                                                ),
                                                Text(
                                                  premiumList[index].priceWeek,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ).marginOnly(left: 2, right: 2)
                                        ],
                                      ),
                                    ).marginOnly(left: 5, right: 5)
                                  : Container(
                                      height: 220,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: context.theme.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: const Color(0xff787C7A),
                                              width: 2)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          15.0.addHSpace(),
                                          Text(
                                            premiumList[index].month,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 25),
                                          ),
                                          10.0.addHSpace(),
                                          Text(
                                            premiumList[index].monthType,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 25),
                                          ),
                                          20.0.addHSpace(),
                                          Text(
                                            premiumList[index].price,
                                            style: const TextStyle(
                                                color: Color(0xff787C7A),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                          10.0.addHSpace(),
                                          const Divider(
                                            color: Color(0xff787C7A),
                                            thickness: 2,
                                          ),
                                          10.0.addHSpace(),
                                          Text(
                                            premiumList[index].perMonth,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17),
                                          ),
                                          Text(
                                            premiumList[index].priceWeek,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ).marginOnly(left: 5, right: 5)),
                        )),
              );
            }),
            20.0.addHSpace(),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                onPressed: () async {
                  PurchaseParam purchaseParam;
                  var purchaseDetails;
                  purchaseParam = PurchaseParam(
                    productDetails:
                        productsList[premiumController.selectedI.value],
                    applicationUserName: null,
                  );
                  await InAppPurchase.instance
                      .buyConsumable(purchaseParam: purchaseParam);

                  DateTime date = DateTime.now();
                  DateTime yearLater =
                      DateTime(date.year + 1, date.month, date.day);
                  DateTime monthLater =
                      DateTime(date.year, date.month + 1, date.day);
                  DateTime weekLater =
                      DateTime(date.year, date.month, date.day + 7);

                  // String year = "${yearLater.year}/${yearLater.month}/${yearLater.day}";
                  // String month = "${weekLater.toString().year}/${monthLater.month}/${monthLater.day}";
                  // String week = "${weekLater.year}/${weekLater.month}/${weekLater.day}";
                  premiumController.storeDate(yearLater.toString());
                  if (purchaseDetails.status == PurchaseStatus.purchased) {
                    if (premiumController.selectedI.value == 0) {
                      premiumController.storeDate(monthLater.toString());
                    }
                    if (premiumController.selectedI.value == 1) {
                      premiumController.storeDate(weekLater.toString());
                    }
                    if (premiumController.selectedI.value == 2) {
                      premiumController.storeDate(yearLater.toString());
                    }
                  }
                },
                color: const Color(0xff51A982),
                borderRadius: BorderRadius.circular(5),
                child: Text("startTrail".tr),
              ),
            ).marginOnly(left: 20, right: 20),
            20.0.addHSpace(),
          ],
        ),
      ),
    );
  }

  Widget advancedListTile(BuildContext context, {required String title}) {
    return Row(
      children: [
        AppIcon.checkBoxIcon(),
        10.0.addWSpace(),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }
}
