import 'package:project/helper/utils/generalImports.dart';

Widget ProductDetailImportantInformationWidget(
    BuildContext context,
    ProductData product,
    ) {
  String productType = product.indicator.toString();
  String cancelableStatus = product.cancelableStatus.toString();
  String returnStatus = product.returnStatus.toString();

  return Container(
    margin: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 8),
        childrenPadding: EdgeInsetsDirectional.zero,
        initiallyExpanded: true,
        title: Row(
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(8),
              decoration: BoxDecoration(
                color: ColorsRes.appColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.policy_outlined,
                color: ColorsRes.appColor,
                size: 20,
              ),
            ),
            getSizedBox(width: 12),
            CustomTextLabel(
              text: "Important Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ],
        ),
        iconColor: ColorsRes.mainTextColor,
        collapsedIconColor: ColorsRes.mainTextColor,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 0),
            padding: EdgeInsetsDirectional.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product type indicator (Veg/Non-veg)
                if (productType != "null" && productType != "0") ...[
                  Row(
                    children: [
                      defaultImg(
                        height: 22,
                        width: 22,
                        image: productType == "1"
                            ? "product_veg_indicator"
                            : "product_non_veg_indicator",
                      ),
                      getSizedBox(width: 10),
                      CustomTextLabel(
                        jsonKey: productType == "1" ? "vegetarian" : "non_vegetarian",
                        style: TextStyle(
                          color: ColorsRes.subTitleMainTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  getSizedBox(height: Constant.size10),
                ],

                // Cancellation policy
                Row(
                  children: [
                    defaultImg(
                      height: 22,
                      width: 22,
                      image: cancelableStatus == "1"
                          ? "product_cancellable"
                          : "product_non_cancellable",
                    ),
                    getSizedBox(width: 10),
                    Expanded(
                      child: CustomTextLabel(
                        text: (cancelableStatus == "1")
                            ? "${getTranslatedValue(context, "product_is_cancellable_till")} ${Constant.getOrderActiveStatusLabelFromCode(product.tillStatus, context)}"
                            : getTranslatedValue(context, "non_cancellable"),
                        style: TextStyle(
                          color: ColorsRes.subTitleMainTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                getSizedBox(height: Constant.size10),

                // Return policy
                Row(
                  children: [
                    defaultImg(
                      height: 22,
                      width: 22,
                      image: returnStatus == "1"
                          ? "product_returnable"
                          : "product_non_returnable",
                    ),
                    getSizedBox(width: 10),
                    Expanded(
                      child: CustomTextLabel(
                        text: (returnStatus == "1")
                            ? "${getTranslatedValue(context, "product_is_returnable_till")} ${product.returnDays} ${getTranslatedValue(context, "days")}"
                            : getTranslatedValue(context, "non_returnable"),
                        style: TextStyle(
                          color: ColorsRes.subTitleMainTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}