import 'package:project/helper/utils/generalImports.dart';

class QuickUseWidget extends StatelessWidget {
  const QuickUseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Constant.session.isUserLoggedIn()
        ? Padding(
            padding: const EdgeInsetsDirectional.all(10),
            child: Row(
              children: [
                Expanded(
                  child: QuickActionButtonWidget(
                    icon: defaultImg(
                      image: "orders",
                      iconColor: ColorsRes.mainTextColor,
                      height: 23,
                      width: 23,
                    ),
                    label: "all_orders",
                    onClickAction: () {
                      Navigator.pushNamed(
                        context,
                        orderHistoryScreen,
                      );
                    },
                    padding: const EdgeInsetsDirectional.only(
                      end: 5,
                    ),
                    context: context,
                  ),
                ),
                Expanded(
                  child: QuickActionButtonWidget(
                    icon: defaultImg(
                      image: "home_map_icon",
                      iconColor: ColorsRes.mainTextColor,
                      height: 23,
                      width: 23,
                    ),
                    label: "address",
                    onClickAction: () => Navigator.pushNamed(
                      context,
                      addressListScreen,
                      arguments: "quick_widget",
                    ),
                    padding: const EdgeInsetsDirectional.only(
                      start: 5,
                      end: 5,
                    ),
                    context: context,
                  ),
                ),
                Expanded(
                  child: QuickActionButtonWidget(
                    icon: defaultImg(
                      image: "cart_icon",
                      iconColor: ColorsRes.mainTextColor,
                      height: 23,
                      width: 23,
                    ),
                    label: "cart",
                    onClickAction: () {
                      if (Constant.session.isUserLoggedIn()) {
                        Navigator.pushNamed(context, cartScreen);
                      } else {
                        // loginUserAccount(context, "cart");
                        Navigator.pushNamed(context, cartScreen);
                      }
                    },
                    padding: const EdgeInsetsDirectional.only(
                      start: 5,
                    ),
                    context: context,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
