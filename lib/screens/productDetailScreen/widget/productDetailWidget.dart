import 'package:project/helper/generalWidgets/ratingImagesWidget.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/screens/productDetailScreen/widget/otherImagesViewWidget.dart';
import 'package:project/screens/productDetailScreen/widget/productDetailImportantInformationWidget.dart';
import 'package:project/screens/productDetailScreen/widget/productDetailSimilarProductsWidget.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class ProductDetailWidget extends StatefulWidget {
  final BuildContext context;
  final ProductData product;

  ProductDetailWidget(
      {super.key, required this.context, required this.product});

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  late QuillEditorController quillEditorController;

  @override
  void initState() {
    quillEditorController = QuillEditorController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Single Container for Product Image Section
        Container(
          margin: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
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
          child: Padding(
            padding: EdgeInsetsDirectional.all(12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    OtherImagesViewWidget(context, Axis.vertical, constraints),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          fullScreenProductImageScreen,
                          arguments: [
                            context.read<ProductDetailProvider>().currentImage,
                            context.read<ProductDetailProvider>().images,
                          ],
                        );
                      },
                      child: Consumer<SelectedVariantItemProvider>(
                        builder: (context, selectedVariantItemProvider, child) {
                          return Container(
                            margin: EdgeInsetsDirectional.only(start: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: setNetworkImg(
                                boxFit: BoxFit.cover,
                                image: context
                                    .read<ProductDetailProvider>()
                                    .images[context
                                    .read<ProductDetailProvider>()
                                    .currentImage],
                                height: (context
                                    .read<ProductDetailProvider>()
                                    .productData
                                    .images
                                    .length >
                                    1)
                                    ? ((constraints.maxWidth * 0.8) - 10)
                                    : constraints.maxWidth - 20,
                                width: (context
                                    .read<ProductDetailProvider>()
                                    .productData
                                    .images
                                    .length >
                                    1)
                                    ? ((constraints.maxWidth * 0.8) - 10)
                                    : constraints.maxWidth - 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Product Info Card with improved spacing
        Container(
          margin: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
          padding: EdgeInsets.all(12),
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
          child: Padding(
            padding: EdgeInsetsDirectional.all(16), // Reduced padding
            child: Consumer<SelectedVariantItemProvider>(
              builder: (context, selectedVariantItemProvider, _) {
                return Consumer<RatingListProvider>(
                  builder: (context, ratingProvider, _) {
                    final hasReviews = ratingProvider.totalData > 0;
                    final averageRating = ratingProvider.productRatingData.averageRating;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Make column compact
                      children: [
                        // Product Name
                        CustomTextLabel(
                          text: widget.product.name,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 20, // Slightly smaller
                            fontWeight: FontWeight.w700,
                            color: ColorsRes.mainTextColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        getSizedBox(height: 18), // Reduced spacing

                        // Price and Rating Row - Dynamic based on reviews
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Price Section - Compact
                            Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 10, vertical: 5), // Reduced padding
                              decoration: BoxDecoration(
                                color: ColorsRes.appColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6), // Smaller radius
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextLabel(
                                    text: double.parse(widget
                                        .product
                                        .variants[selectedVariantItemProvider
                                        .getSelectedIndex()]
                                        .discountedPrice) !=
                                        0
                                        ? widget
                                        .product
                                        .variants[selectedVariantItemProvider
                                        .getSelectedIndex()]
                                        .discountedPrice
                                        .currency
                                        : widget
                                        .product
                                        .variants[selectedVariantItemProvider
                                        .getSelectedIndex()]
                                        .price
                                        .currency,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16, // Slightly smaller
                                        color: ColorsRes.appColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  if (double.parse(widget
                                      .product.variants[selectedVariantItemProvider
                                      .getSelectedIndex()].discountedPrice) !=
                                      0) ...[
                                    getSizedBox(width: 6), // Reduced spacing
                                    CustomTextLabel(
                                      text: widget.product.variants[selectedVariantItemProvider
                                          .getSelectedIndex()].price.currency,
                                      style: TextStyle(
                                          fontSize: 13, // Smaller
                                          color: ColorsRes.grey,
                                          decoration: TextDecoration.lineThrough,
                                          decorationThickness: 2),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Conditional spacing and rating
                            if (hasReviews) ...[
                              Spacer(),
                              // Rating Container - Compact
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 8, vertical: 4), // Reduced padding
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.amber.withOpacity(0.3),
                                    width: 1.2, // Slightly thinner
                                  ),
                                  borderRadius: BorderRadius.circular(6), // Smaller radius
                                ),
                                child: ProductListRatingBuilderWidget(
                                  averageRating: averageRating.toString().toDouble,
                                  totalRatings: ratingProvider.totalData.toString().toInt,
                                  size: 18, // Smaller stars
                                  spacing: 1.5, // Less spacing
                                  fontSize: 12, // Smaller text
                                ),
                              ),
                            ],
                          ],
                        ),
                        getSizedBox(height: 12), // Reduced spacing

                        // Add to Cart Button
                        ProductDetailAddToCartButtonWidget(
                          context: context,
                          product: widget.product,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
        getSizedBox(height: 4),
        // Important Information Widget with reduced spacing
        ProductDetailImportantInformationWidget(context, widget.product),
        getSizedBox(height: 4),

        // Specifications Card
        Container(
          margin: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
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
                      Icons.info_outline,
                      color: ColorsRes.appColor,
                      size: 20,
                    ),
                  ),
                  getSizedBox(width: 12),
                  CustomTextLabel(
                    jsonKey: "product_specifications",
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
                  // padding: EdgeInsetsDirectional.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      getSpecificationItem(
                        titleJson: "fssai_lic_no",
                        value: widget.product.fssaiLicNo.toString(),
                        voidCallback: () {},
                        isClickable: false,
                      ),
                      getSpecificationItem(
                        titleJson: "category",
                        value: widget.product.categoryName.toString(),
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "category",
                              widget.product.categoryId.toString(),
                              widget.product.categoryName.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "seller_name",
                        value: widget.product.sellerName,
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "seller",
                              widget.product.sellerId.toString(),
                              widget.product.sellerName.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "brand",
                        value: widget.product.brandName,
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "brand",
                              widget.product.brandId.toString(),
                              widget.product.brandName.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "made_in",
                        value: widget.product.madeIn,
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "country",
                              widget.product.madeInId.toString(),
                              widget.product.madeIn.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "manufacturer",
                        value: widget.product.manufacturer,
                        voidCallback: () {},
                        isClickable: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Product Overview Card
        Container(
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
              tilePadding: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 0),
              childrenPadding: EdgeInsetsDirectional.zero,
              initiallyExpanded: true,
              maintainState: true,
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsetsDirectional.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  getSizedBox(width: 12),
                  CustomTextLabel(
                    jsonKey: "product_overview",
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
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 4),
                  padding: EdgeInsetsDirectional.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QuillHtmlEditor(
                    text: widget.product.description,
                    hintText:
                    getTranslatedValue(context, "description_goes_here"),
                    isEnabled: true,
                    ensureVisible: true,
                    minHeight: 10,
                    autoFocus: false,
                    textStyle: TextStyle(color: ColorsRes.mainTextColor),
                    hintTextStyle:
                    TextStyle(color: ColorsRes.subTitleMainTextColor),
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.transparent,
                    loadingBuilder: (context) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorsRes.appColor,
                        ),
                      );
                    },
                    controller: quillEditorController,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Ratings and Reviews Card
        Consumer<RatingListProvider>(
          builder: (context, ratingListProvider, child) {
            if (ratingListProvider.ratings.length > 0) {
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
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.star_outline,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                        getSizedBox(width: 12),
                        CustomTextLabel(
                          jsonKey: "ratings_and_reviews",
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
                        margin: EdgeInsetsDirectional.symmetric(horizontal: 25, vertical: 0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            getOverallRatingSummary(
                                context: context,
                                productRatingData:
                                ratingListProvider.productRatingData,
                                totalRatings:
                                ratingListProvider.totalData.toString()),
                            if (ratingListProvider.totalImages > 0)
                              getSizedBox(height: 20),
                            if (ratingListProvider.totalImages > 0)
                              CustomTextLabel(
                                text:
                                "${getTranslatedValue(context, "customer_photos")}(${ratingListProvider.totalImages})",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                            if (ratingListProvider.totalImages > 0)
                              getSizedBox(height: 12),
                            if (ratingListProvider.totalImages > 0)
                              RatingImagesWidget(
                                images: ratingListProvider.images,
                                from: "productDetails",
                                productId: widget.product.id,
                                totalImages: ratingListProvider.totalImages,
                              ),
                            getSizedBox(height: 20),
                            CustomTextLabel(
                              jsonKey: "customer_reviews",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorsRes.mainTextColor,
                              ),
                            ),
                            getSizedBox(height: 12),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              children: List.generate(
                                ratingListProvider.ratings.length,
                                    (index) {
                                  ProductRatingList rating =
                                  ratingListProvider.ratings[index];
                                  return Container(
                                    margin: EdgeInsetsDirectional.only(bottom: 12),
                                    padding: EdgeInsetsDirectional.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: ColorsRes.grey.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: getRatingReviewItem(rating: rating),
                                  );
                                },
                              ),
                            ),
                            if (ratingListProvider.totalData > 5)
                              Container(
                                width: double.infinity,
                                margin: EdgeInsetsDirectional.only(top: 12),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ratingAndReviewScreen,
                                        arguments: widget.product.id.toString());
                                  },
                                  child: Container(
                                    padding: EdgeInsetsDirectional.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: ColorsRes.appColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: ColorsRes.appColor.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CustomTextLabel(
                                          text:
                                          "${getTranslatedValue(context, "view_all_reviews_title")} ${ratingListProvider.totalData.toString().toInt} ${getTranslatedValue(context, "reviews")}",
                                          style: TextStyle(
                                            color: ColorsRes.appColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        getSizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: ColorsRes.appColor,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),

        // Similar Products
        ChangeNotifierProvider<ProductListProvider>(
          create: (context) => ProductListProvider(),
          child: ProductDetailSimilarProductsWidget(
            tags: context
                .read<ProductDetailProvider>()
                .productDetail
                .data
                .tagNames,
            slug: context.read<ProductDetailProvider>().productDetail.data.slug,
          ),
        ),
        getSizedBox(
          height:
          context.watch<ProductDetailProvider>().expanded == true ? 60 : 10,
        ),
      ],
    );
  }
}

Widget getSpecificationItem({
  required String titleJson,
  required String value,
  required VoidCallback voidCallback,
  required bool isClickable,
}) {
  if (value != "null" && value != "") {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 8),
      padding: EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: CustomTextLabel(
              jsonKey: titleJson,
              softWrap: true,
              style: TextStyle(
                color: ColorsRes.subTitleMainTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          getSizedBox(width: 12),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: voidCallback,
              child: CustomTextLabel(
                text: value,
                softWrap: true,
                style: TextStyle(
                  color: isClickable
                      ? ColorsRes.appColor
                      : ColorsRes.mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    return SizedBox.shrink();
  }
}