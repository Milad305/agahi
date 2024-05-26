import 'package:agahi_app/api/api.dart';
import 'package:agahi_app/models/TransactionModel.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  var transactions_loading = false.obs;
  var transactions = <TransactionModel>[];

  void getTransactions() {
    transactions_loading(true);
    transactions.clear();
    ApiProvider().getTransactions().then(
      (value) {
        if (value.isOk) {
          var lst = value.body as List;
          lst.forEach((element) {
            transactions.add(TransactionModel.fromJson(element));
          });
          transactions.removeWhere((element) => element.status == 0);
        }
        transactions_loading(false);
      },
    ).onError(
      (error, stackTrace) {
        print(error);
        transactions_loading(false);
      },
    );
  }
}
