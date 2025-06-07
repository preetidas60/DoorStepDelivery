import 'package:project/helper/utils/generalImports.dart';

class SocialMediaLoginButtonWidget extends StatelessWidget {
  final String text;
  final String logo;
  final VoidCallback onPressed;
  final Color? logoColor;

  const SocialMediaLoginButtonWidget({
    super.key,
    required this.text,
    required this.logo,
    required this.onPressed,
    this.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.001,
            blurRadius: 30,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0, // Remove default elevationR
          shadowColor: Colors.transparent, // Remove default shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            // Removed the side parameter to eliminate the border
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            defaultImg(
              image: logo,
              height: 24,
              width: 24,
              iconColor: logoColor,
              boxFit: BoxFit.fitWidth,
            ),
            getSizedBox(width: 10),
            CustomTextLabel(
              jsonKey: text,
              style: TextStyle(
                color: ColorsRes.mainTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}