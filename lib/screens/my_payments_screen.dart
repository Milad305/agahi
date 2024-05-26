// ignore_for_file: must_be_immutable

import 'package:agahi_app/controller/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../widget/public_widget.dart';
import '../widget/widget.dart';

class PaymentsScreen extends StatelessWidget {
  PaymentsScreen({super.key});
  var paymentController = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    paymentController.getTransactions();
    return SafeArea(
        child: CustomScaffold(
            body: Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        CustomAppBar(
          bg_color: Cprimary,
          show_back: true,
          show_title: true,
          title: "پرداخت های من",
          title_icon: Icon(
            Icons.request_quote,
            color: Cwhite,
            size: 20,
          ),
        ),
        Expanded(child: Obx(
          () {
            if (paymentController.transactions_loading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: Cprimary,
                ),
              );
            } else {
              return paymentController.transactions.length <= 0
                  ? Container(
                      child: Center(
                        child: Text('پرداختی برای نمایش وجود ندارد'),
                      ),
                    )
                  : ListView.builder(
                      reverse: false,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      itemCount: paymentController.transactions.length,
                      itemBuilder: (context, index) {
                        var transaction = paymentController.transactions[index];

                        return Payments(
                          time:
                              "${transaction.get_created_at().hour.toString().padLeft(2, '0')}:${transaction.get_created_at().minute.toString().padLeft(2, '0')}",
                          agahi: "${transaction.description}",
                          icon: transaction.get_icon(),
                          date:
                              "${transaction.get_created_at().year}/${transaction.get_created_at().month}/${transaction.get_created_at().day}",
                          price: "${transaction.price} تومان",
                        );
                      },
                    );
            }
          },
        )),
      ]),
    )));
  }
}
