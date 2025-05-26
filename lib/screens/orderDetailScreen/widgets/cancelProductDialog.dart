import 'package:project/helper/utils/generalImports.dart';

class CancelProductDialog extends StatelessWidget {
  final Order order;
  final String orderItemId;

  CancelProductDialog(
      {Key? key, required this.order, required this.orderItemId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldReasonController = TextEditingController();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        } else {
          if (context
                  .read<UpdateOrderStatusProvider>()
                  .getUpdateOrderStatus() ==
              UpdateOrderStatus.inProgress) {
            Navigator.pop(context, true);
          } else {
            return;
          }
        }
      },
      child: AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: CustomTextLabel(
          jsonKey: "sure_to_cancel_product",
        ),
        content: TextField(
          controller: textFieldReasonController,
          autofocus: true,
          focusNode: FocusNode(),
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: ColorsRes.subTitleMainTextColor),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: getTranslatedValue(context, "enter_reason"),
            hintStyle: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
            ),
          ),
          style: TextStyle(
            color: ColorsRes.mainTextColor,
          ),
        ),
        actions: [
          Consumer<UpdateOrderStatusProvider>(builder: (context, provider, _) {
            if (provider.getUpdateOrderStatus() ==
                UpdateOrderStatus.inProgress) {
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: CustomTextLabel(
                    jsonKey: "no",
                    style: TextStyle(color: ColorsRes.mainTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (textFieldReasonController.text.isNotEmpty) {
                      context
                          .read<UpdateOrderStatusProvider>()
                          .updateStatus(
                            order: order,
                            orderItemId: orderItemId,
                            status: Constant.orderStatusCode[6],
                            context: context,
                            reason: textFieldReasonController.text,
                            from: "cancel",
                          )
                          .then((value) {
                        Navigator.pop(context, value);
                      });
                    } else {
                      showMessage(
                          context,
                          getTranslatedValue(context, "reason_required"),
                          MessageType.warning);
                    }
                  },
                  child: CustomTextLabel(
                    jsonKey: "yes",
                    style: TextStyle(color: ColorsRes.appColor),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

Widget CancelProductButton(
    {required OrderItem orderItem,
    required VoidCallback voidCallback,
    required BuildContext context,
    required Order order}) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (context) =>
              ChangeNotifierProvider<UpdateOrderStatusProvider>(
                create: (context) => UpdateOrderStatusProvider(),
                child: CancelProductDialog(
                  order: order,
                  orderItemId: orderItem.id.toString(),
                ),
              )).then(
        (value) {
          //If we get true as value means we need to update this product's status to 7
          if (value) {
            voidCallback();
          }
        },
      );
    },
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
      child: CustomTextLabel(
        jsonKey: "cancel",
        softWrap: true,
        style: TextStyle(color: ColorsRes.appColor),
      ),
    ),
  );
}