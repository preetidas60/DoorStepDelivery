import 'package:project/helper/utils/generalImports.dart';

class ProductListRatingBuilderWidget extends StatelessWidget {
  final double averageRating;
  final int totalRatings;
  final double? size;
  final double? spacing;
  final double? fontSize;

  ProductListRatingBuilderWidget({
    super.key,
    required this.averageRating,
    required this.totalRatings,
    this.size,
    this.spacing,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    if (totalRatings == 0) {
      return SizedBox.shrink();
    } else {
      // Ensure rating is within valid range
      double validRating = averageRating.clamp(0.0, 5.0);

      return Padding(
        padding: EdgeInsetsDirectional.only(start: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  5,
                      (index) {
                    return defaultImg(
                      image: "rate_icon",
                      iconColor: (validRating > index)
                          ? ColorsRes.activeRatingColor
                          : ColorsRes.deActiveRatingColor,
                      height: size,
                      width: size,
                      padding: EdgeInsetsDirectional.only(end: index < 4 ? (spacing ?? 0) : 0),
                    );
                  },
                ),
                getSizedBox(width: 5),
                CustomTextLabel(
                  text: "(${validRating.toStringAsFixed(1)})",
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                    fontSize: fontSize ?? 13,
                  ),
                ),
                getSizedBox(width: 5),
              ],
            ),
          ],
        ),
      );
    }
  }
}