import 'package:project/helper/utils/generalImports.dart';

class ProductListItemContainer extends StatefulWidget {
  final ProductListItem product;

  const ProductListItemContainer({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductListItemContainer> createState() => _State();
}

class _State extends State<ProductListItemContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductListItem product = widget.product;
    List<Variants> variants = product.variants!;
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          bottom: 8, start: 12, end: 12, top: 4),
      child: variants.length > 0
          ? GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, productDetailScreen,
              arguments: [product.id.toString(), product.name, product]);
        },
        child: ChangeNotifierProvider<SelectedVariantItemProvider>(
          create: (context) => SelectedVariantItemProvider(),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorsRes.subTitleMainTextColor.withValues(alpha: 0.1),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<SelectedVariantItemProvider>(
                      builder:
                          (context, selectedVariantItemProvider, child) {
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: 12, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: setNetworkImg(
                                  boxFit: BoxFit.cover,
                                  image: product.imageUrl.toString(),
                                  height: 90,
                                  width: 90,
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              bottom: 8,
                              start: 8,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    if (product.indicator.toString() == "1")
                                      defaultImg(
                                          height: 16,
                                          width: 16,
                                          image: "product_veg_indicator"),
                                    if (product.indicator.toString() == "2")
                                      defaultImg(
                                          height: 16,
                                          width: 16,
                                          image: "product_non_veg_indicator"),
                                  ],
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                double discountPercentage = 0.0;
                                if (product.variants!.first.discountedPrice
                                    .toString()
                                    .toDouble >
                                    0.0) {
                                  discountPercentage = product
                                      .variants!.first.price
                                      .toString()
                                      .toDouble
                                      .calculateDiscountPercentage(product
                                      .variants!.first.discountedPrice
                                      .toString()
                                      .toDouble);
                                }

                                if (discountPercentage > 0.0) {
                                  return PositionedDirectional(
                                    start: 8,
                                    top: 8,
                                    child: Container(
                                      padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 6,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.red.shade400, Colors.red.shade600],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withValues(alpha: 0.3),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: CustomTextLabel(
                                        text:
                                        "${discountPercentage.toStringAsFixed(0)}% ${getTranslatedValue(context, "off")}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: ColorsRes.appColorWhite,
                                          fontWeight: FontWeight.w600,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                          left: 8,
                          right: 42,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextLabel(
                              text: product.name.toString(),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: ColorsRes.mainTextColor,
                                height: 1.3,
                                letterSpacing: -0.2,
                              ),
                            ),
                            getSizedBox(height: 8),
                            ProductVariantDropDownMenuList(
                              variants: variants,
                              from: "product_list",
                              product: product,
                              isGrid: false,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                PositionedDirectional(
                  end: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ProductWishListIcon(
                      product: product,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          : SizedBox.shrink(),
    );
  }
}