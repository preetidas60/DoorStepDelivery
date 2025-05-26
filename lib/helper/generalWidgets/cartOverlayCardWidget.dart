import 'package:project/helper/utils/generalImports.dart';

class CartOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.all(10),
      padding: EdgeInsetsDirectional.only(
        top: 3,
        bottom: 3,
        start: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, cartScreen);
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getSizedBox(height: 4),
                    CustomTextLabel(
                      text: context
                          .watch<CartProvider>()
                          .subTotal
                          .toString()
                          .currency,
                      style: TextStyle(
                          fontSize: 14,
                          color: ColorsRes.mainTextColor,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                    CustomTextLabel(
                      text:
                          "${context.watch<CartProvider>().totalItemsCount} ${context.watch<CartProvider>().totalItemsCount > 1 ? getTranslatedValue(context, "items") : getTranslatedValue(context, "item")}",
                      style: TextStyle(
                          fontSize: 12,
                          color: ColorsRes.subTitleMainTextColor,
                          height: 1),
                    ),
                    getSizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, cartScreen);
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(
                  start: 10, end: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: ColorsRes.appColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: CustomTextLabel(
                jsonKey: 'view_cart',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorsRes.appColorWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Theme.of(context).cardColor,
                  surfaceTintColor: Colors.transparent,
                  title: CustomTextLabel(
                    jsonKey: "clear_cart_title",
                    softWrap: true,
                  ),
                  content: CustomTextLabel(
                    jsonKey: "clear_cart_message",
                    softWrap: true,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: CustomTextLabel(
                        jsonKey: "cancel",
                        softWrap: true,
                        style:
                            TextStyle(color: ColorsRes.subTitleMainTextColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<CartListProvider>()
                            .clearCart(context: context);
                        Navigator.pop(context);
                      },
                      child: CustomTextLabel(
                        jsonKey: "ok",
                        softWrap: true,
                        style: TextStyle(color: ColorsRes.appColor),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(
              Icons.close,
              color: ColorsRes.subTitleMainTextColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
