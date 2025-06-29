import 'package:project/helper/utils/generalImports.dart';

class ProductCartButton extends StatefulWidget {
  final int count;
  final String productId;
  final String sellerId;
  final String productVariantId;
  final bool isUnlimitedStock;
  final double maximumAllowedQuantity;
  final double availableStock;
  final String from;
  final bool isGrid;

  const ProductCartButton({
    Key? key,
    required this.count,
    required this.productId,
    required this.productVariantId,
    required this.isUnlimitedStock,
    required this.maximumAllowedQuantity,
    required this.availableStock,
    required this.isGrid,
    required this.from,
    required this.sellerId,
  }) : super(key: key);

  @override
  State<ProductCartButton> createState() => _ProductCartButtonState();
}

class _ProductCartButtonState
    extends State<ProductCartButton> /*with TickerProviderStateMixin*/ {
  late AnimationController animationController;
  late Animation animation;
  int currentState = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartListProvider>(
      builder: (context, cartListProvider, child) {
        return (int.parse(cartListProvider.getItemCartItemQuantity(
            widget.productId, widget.productVariantId)) ==
            0 &&
            widget.count != -1)
            ? GestureDetector(
          onTap: () async {
            if (Constant.session.isUserLoggedIn()) {
              cartListProvider.currentSelectedProduct = widget.productId;
              cartListProvider.currentSelectedVariant =
                  widget.productVariantId;

              Map<String, String> params = {};
              params[ApiAndParams.productId] = widget.productId;
              params[ApiAndParams.productVariantId] =
                  widget.productVariantId;
              params[ApiAndParams.qty] = (int.parse(
                  cartListProvider.getItemCartItemQuantity(
                      widget.productId,
                      widget.productVariantId)) +
                  1)
                  .toString();
              await cartListProvider
                  .addRemoveCartItem(
                context: context,
                params: params,
                isUnlimitedStock: widget.isUnlimitedStock,
                maximumAllowedQuantity: widget.maximumAllowedQuantity,
                availableStock: widget.availableStock,
                actionFor: "add",
                from: widget.from,
                sellerId: widget.sellerId,
              )
                  .then((value) {
                if (value is String) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: Theme.of(context).cardColor,
                      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 16),
                      actionsPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      content: CustomTextLabel(
                        jsonKey: "seller_miss_match_item_message",
                        softWrap: true,
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                      actions: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: CustomTextLabel(
                                  jsonKey: "cancel",
                                  softWrap: true,
                                  style: TextStyle(
                                    color: ColorsRes.subTitleMainTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  context
                                      .read<CartListProvider>()
                                      .clearCart(context: context)
                                      .then((value) async {
                                    cartListProvider.currentSelectedProduct =
                                        widget.productId;
                                    cartListProvider.currentSelectedVariant =
                                        widget.productVariantId;

                                    Map<String, String> params = {};
                                    params[ApiAndParams.productId] =
                                        widget.productId;
                                    params[ApiAndParams.productVariantId] =
                                        widget.productVariantId;
                                    params[ApiAndParams
                                        .qty] = (int.parse(cartListProvider
                                        .getItemCartItemQuantity(
                                        widget.productId,
                                        widget.productVariantId)) +
                                        1)
                                        .toString();
                                    await cartListProvider
                                        .addRemoveCartItem(
                                      context: context,
                                      params: params,
                                      isUnlimitedStock: widget.isUnlimitedStock,
                                      maximumAllowedQuantity:
                                      widget.maximumAllowedQuantity,
                                      availableStock: widget.availableStock,
                                      actionFor: "add",
                                      from: widget.from,
                                      sellerId: widget.sellerId,
                                    )
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: ColorsRes.appColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: CustomTextLabel(
                                  jsonKey: "ok",
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              });
            } else {
              // if (Constant.guestCartOptionIsOn == "1") {
              cartListProvider.currentSelectedProduct = widget.productId;
              cartListProvider.currentSelectedVariant =
                  widget.productVariantId;

              Map<String, String> params = {};
              params[ApiAndParams.productId] = widget.productId;
              params[ApiAndParams.productVariantId] =
                  widget.productVariantId;
              params[ApiAndParams.qty] = (int.parse(
                  cartListProvider.getItemCartItemQuantity(
                      widget.productId,
                      widget.productVariantId)) +
                  1)
                  .toString();
              await cartListProvider
                  .addRemoveGuestCartItem(
                context: context,
                params: params,
                isUnlimitedStock: widget.isUnlimitedStock,
                maximumAllowedQuantity: widget.maximumAllowedQuantity,
                availableStock: widget.availableStock,
                actionFor: "add",
                from: widget.from,
                sellerId: widget.sellerId,
              )
                  .then((value) {
                if (value is String) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: Theme.of(context).cardColor,
                      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 16),
                      actionsPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      content: CustomTextLabel(
                        jsonKey: "seller_miss_match_item_message",
                        softWrap: true,
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                      actions: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: CustomTextLabel(
                                  jsonKey: "cancel",
                                  softWrap: true,
                                  style: TextStyle(
                                    color: ColorsRes.subTitleMainTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  context
                                      .read<CartListProvider>()
                                      .clearCart(context: context)
                                      .then((value) async {
                                    cartListProvider.currentSelectedProduct =
                                        widget.productId;
                                    cartListProvider.currentSelectedVariant =
                                        widget.productVariantId;

                                    Map<String, String> params = {};
                                    params[ApiAndParams.productId] =
                                        widget.productId;
                                    params[ApiAndParams.productVariantId] =
                                        widget.productVariantId;
                                    params[ApiAndParams
                                        .qty] = (int.parse(cartListProvider
                                        .getItemCartItemQuantity(
                                        widget.productId,
                                        widget.productVariantId)) +
                                        1)
                                        .toString();
                                    await cartListProvider
                                        .addRemoveCartItem(
                                      context: context,
                                      params: params,
                                      isUnlimitedStock: widget.isUnlimitedStock,
                                      maximumAllowedQuantity:
                                      widget.maximumAllowedQuantity,
                                      availableStock: widget.availableStock,
                                      actionFor: "add",
                                      from: widget.from,
                                      sellerId: widget.sellerId,
                                    )
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: ColorsRes.appColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: CustomTextLabel(
                                  jsonKey: "ok",
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              });
              // } else {
              //   loginUserAccount(context, "cart");
              // }
            }
          },
          child: Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: ColorsRes.appColor.withOpacity(0.3),
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ColorsRes.appColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 38,
            width: context.width * 0.28,
            child: (cartListProvider.cartListState ==
                CartListState.loading &&
                cartListProvider.currentSelectedProduct ==
                    widget.productId &&
                cartListProvider.currentSelectedVariant ==
                    widget.productVariantId)
                ? Container(
              alignment: AlignmentDirectional.center,
              child: Container(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: ColorsRes.appColor,
                  strokeWidth: 2,
                ),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: ColorsRes.appColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 14,
                    color: ColorsRes.appColor,
                  ),
                ),
                SizedBox(width: 6),
                CustomTextLabel(
                  jsonKey: "add_to_cart",
                  style: TextStyle(
                    color: ColorsRes.appColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        )
            : (int.parse(cartListProvider.getItemCartItemQuantity(
            widget.productId, widget.productVariantId)) !=
            0 &&
            widget.count != -1)
            ? Container(
          height: 38,
          width: context.width * 0.28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorsRes.appColor, ColorsRes.appColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: ColorsRes.appColor.withOpacity(0.25),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(3),
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: GestureDetector(
                    onTap: () async {
                      cartListProvider.currentSelectedProduct =
                          widget.productId;
                      cartListProvider.currentSelectedVariant =
                          widget.productVariantId;

                      Map<String, String> params = {};
                      params[ApiAndParams.productId] =
                          widget.productId;
                      params[ApiAndParams.productVariantId] =
                          widget.productVariantId;
                      params[ApiAndParams.qty] = (int.parse(
                          cartListProvider
                              .getItemCartItemQuantity(
                              widget.productId,
                              widget.productVariantId)) -
                          1)
                          .toString();

                      if (Constant.session.isUserLoggedIn()) {
                        await cartListProvider.addRemoveCartItem(
                          context: context,
                          params: params,
                          isUnlimitedStock: widget.isUnlimitedStock,
                          maximumAllowedQuantity:
                          widget.maximumAllowedQuantity,
                          availableStock: widget.availableStock,
                          from: widget.from,
                          sellerId: widget.sellerId,
                          actionFor: "add",
                        );
                      } else {
                        // if (Constant.guestCartOptionIsOn == "1") {
                        await cartListProvider.addRemoveGuestCartItem(
                          context: context,
                          params: params,
                          isUnlimitedStock: widget.isUnlimitedStock,
                          maximumAllowedQuantity:
                          widget.maximumAllowedQuantity,
                          availableStock: widget.availableStock,
                          from: widget.from,
                          actionFor: "add",
                          sellerId: widget.sellerId,
                        );
                        // } else {
                        //   loginUserAccount(context, "cart");
                        // }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        int.parse(cartListProvider.getItemCartItemQuantity(
                            widget.productId, widget.productVariantId)) == 1
                            ? Icons.delete_outline
                            : Icons.remove,
                        size: 16,
                        color: ColorsRes.appColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: (cartListProvider.cartListState ==
                    CartListState.loading &&
                    cartListProvider.currentSelectedProduct ==
                        widget.productId &&
                    cartListProvider.currentSelectedVariant ==
                        widget.productVariantId)
                    ? Container(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).cardColor,
                      strokeWidth: 2,
                    ),
                  ),
                )
                    : Container(
                  alignment: AlignmentDirectional.center,
                  width: 35,
                  height: 35,
                  child: CustomTextLabel(
                    text: cartListProvider
                        .getItemCartItemQuantity(
                        widget.productId,
                        widget.productVariantId),
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: GestureDetector(
                    onTap: () async {
                      cartListProvider.currentSelectedProduct =
                          widget.productId;
                      cartListProvider.currentSelectedVariant =
                          widget.productVariantId;
                      Map<String, String> params = {};
                      params[ApiAndParams.productId] =
                          widget.productId;
                      params[ApiAndParams.productVariantId] =
                          widget.productVariantId;
                      params[ApiAndParams.qty] = (int.parse(
                          cartListProvider
                              .getItemCartItemQuantity(
                              widget.productId,
                              widget.productVariantId)) +
                          1)
                          .toString();

                      if (Constant.session.isUserLoggedIn()) {
                        await cartListProvider.addRemoveCartItem(
                          context: context,
                          params: params,
                          isUnlimitedStock: widget.isUnlimitedStock,
                          maximumAllowedQuantity:
                          widget.maximumAllowedQuantity,
                          availableStock: widget.availableStock,
                          from: widget.from,
                          sellerId: widget.sellerId,
                          actionFor: "add",
                        );
                      } else {
                        // if (Constant.guestCartOptionIsOn == "1") {
                        await cartListProvider.addRemoveGuestCartItem(
                          context: context,
                          params: params,
                          isUnlimitedStock: widget.isUnlimitedStock,
                          maximumAllowedQuantity:
                          widget.maximumAllowedQuantity,
                          availableStock: widget.availableStock,
                          from: widget.from,
                          actionFor: "add",
                          sellerId: widget.sellerId,
                        );
                        // } else {
                        //   loginUserAccount(context, "cart");
                        // }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: ColorsRes.appColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
            : Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          height: 38,
          child: CustomTextLabel(
            jsonKey: "out_of_stock",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.red,
              letterSpacing: 0.3,
            ),
          ),
        );
      },
    );
  }
}