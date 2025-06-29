import 'package:flutter/material.dart';
import 'package:project/helper/generalWidgets/customTextLabel.dart';
import 'package:project/helper/styles/colorsRes.dart';

import '../utils/generalMethods.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final double max; // Value between 0.0 to 1.0 (e.g., 0.2 = 20% of text shown)
  final Color color;

  const ExpandableText({
    Key? key,
    required this.text,
    required this.max,
    required this.color,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final reviewTextStyle = TextStyle(
      fontWeight: FontWeight.w400, // Bold review text
      fontSize: 14,
      color: widget.color,
        wordSpacing: 1.5
    );

    final readMoreStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.grey.shade500, // Light grey
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.start,
        maxLines: isOpen ? null : 2,
        overflow: TextOverflow.fade,
        text: TextSpan(
          children: [
            TextSpan(
              text: isOpen
                  ? widget.text
                  : widget.text.length >
                  (widget.text.length * widget.max).toInt()
                  ? widget.text.substring(
                  0, (widget.text.length * widget.max).toInt()) +
                  "..."
                  : widget.text,
              style: reviewTextStyle,
            ),
            WidgetSpan(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    isOpen
                        ? getTranslatedValue(context, "read_less")
                        : getTranslatedValue(context, "read_more"),
                    style: readMoreStyle,
                  ),
                ),
              ),
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
            ),
          ],
        ),
      ),
    );
  }
}
