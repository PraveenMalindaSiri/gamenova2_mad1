import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/order_item.dart';
import 'package:gamenova2_mad1/core/service/payment_service.dart';
import 'package:gamenova2_mad1/views/pages/main_nav.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
import 'package:vibration/vibration.dart';

class OrderDetails extends StatefulWidget {
  final String token;
  final int id;
  const OrderDetails({super.key, required this.token, required this.id});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<OrderItem> orders = [];
  bool _isLoading = true;

  Future<void> getItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await PaymentService.orders(widget.token, widget.id);

      setState(() {
        orders = items;
      });
    } on TimeoutException {
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Network timeout',
        message: 'Please check your connection and try again.',
        type: NoticeType.warning,
      );
    } catch (e) {
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Loading Games failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 600);
    }
  }

  Widget buildItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    item.product.type,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.quantity.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (item.digitalcode != null)
                  Text(
                    item.digitalcode!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getItems();
    _vibrate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  Text("New Order's details"),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 500,
                            child: buildItem(orders[index]),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) =>
                          const Padding(padding: EdgeInsets.all(5)),
                      itemCount: orders.length,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) =>
                              const MainNavScreen(selectPageIndex: 0),
                        ),
                        (route) => false,
                      );
                    },
                    label: Text("Go to Home"),
                    icon: Icon(Icons.keyboard_return),
                  ),
                ],
              ),
            ),
    );
  }
}
