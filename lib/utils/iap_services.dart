// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import 'app_keys.dart';

// const String kConsumableId = 'consumable_product';
// const String kUpgradeId = 'non_consumable';

const List<String> androidList = <String>[
  monthPlanAndroid,
  weekPlanAndroid,
  yearPlanAndroid,
];

const List<String> iosList = <String>[
  monthPlanIOS,
  weekPlanIOS,
  yearPlanIOS,
];

class IapService {
  final InAppPurchase inAppPurchase = InAppPurchase.instance;

  final List<String> productIds = [];
  List<PurchaseDetails> purchases = <PurchaseDetails>[];
  List<ProductDetails> availableProducts = <ProductDetails>[
    ProductDetails(
        id: '1',
        title: 'title',
        description: 'description',
        price: '9.99',
        rawPrice: 9.99,
        currencyCode: 'USD',
        currencySymbol: "US"),
    ProductDetails(
        id: '2',
        title: 'title',
        description: 'description',
        price: '2.99',
        rawPrice: 2.99,
        currencyCode: 'USD',
        currencySymbol: "US"),
    ProductDetails(
        id: '3',
        title: 'title',
        description: 'description',
        price: '99.99',
        rawPrice: 99.99,
        currencyCode: 'USD',
        currencySymbol: "US"),
  ];

  bool purchasePending = false;
  bool autoConsume = true;

  /// in app purchase
  Future<List<ProductDetails>> initStoreInfo({
    bool? isAvailable,
    required List<String> id,
    List<String>? noFoundId,
  }) async {
    isAvailable = await inAppPurchase.isAvailable();
    print("isAvailable");
    if (!isAvailable) {
      return [];
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          InAppPurchase.instance
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    try {
      final ProductDetailsResponse productDetailsResponse =
          await inAppPurchase.queryProductDetails(id.toSet());

      if (productDetailsResponse.productDetails.isNotEmpty) {
        availableProducts = productDetailsResponse.productDetails;
        for (var element in availableProducts) {
          log('availableProducts is:  ${element.id} --> ${element.title} : ${element.description}');
        }
      }
      if (productDetailsResponse.notFoundIDs.isNotEmpty) {
        noFoundId = productDetailsResponse.notFoundIDs;
      }
      if (productDetailsResponse.error != null) {}
    } on InAppPurchaseException catch (e) {
      log('Error in InAppPurchase --> ${e.message}');
    }
    print("--->availableProducts ${availableProducts.length}");
    availableProducts.forEach((element) {
      print(
          "--->availableProducts Id: ${element.id + "Title:  " + element.title}");
    });
    return availableProducts;
  }

  listenToPurchaseUpdated(
      {List<PurchaseDetails>? purchaseDetailsList,
      Function? updatePlan}) async {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList!) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          log("PurchaseStatus purchased-----> ${purchaseDetails.status}");
          // addPurchase(context);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchaseDetails);
        }
        if (purchaseDetails.status == PurchaseStatus.canceled) {}
      }
    }
  }

  addPurchase(context) async {
    DateTime selectedDate = DateTime.now();
    selectedDate =
        DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
    print("---->selectedDate $selectedDate");
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
