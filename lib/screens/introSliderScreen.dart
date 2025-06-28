import 'package:project/helper/utils/generalImports.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({Key? key}) : super(key: key);

  @override
  IntroSliderScreenState createState() => IntroSliderScreenState();
}

class IntroSliderScreenState extends State<IntroSliderScreen> {
  int currentPosition = 0;
  PageController pageController = PageController();

  /// Intro slider list ...
  /// You can add or remove items from below list as well
  /// Add svg images into asset > svg folder and set name here without any extension and image should not contains space
  static List introSlider = [];

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness:
        Constant.session.getBoolData(SessionManager.isDarkTheme)
            ? Brightness.dark
            : Brightness.light,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    introSlider = [
      {
        "image":
        "intro_slider_1${Constant.session.getBoolData(SessionManager.isDarkTheme) ? "_dark" : ""}",
        "title": getTranslatedValue(context, "intro_title_1"),
        "description": getTranslatedValue(context, "intro_description_1"),
      },
      {
        "image":
        "intro_slider_2${Constant.session.getBoolData(SessionManager.isDarkTheme) ? "_dark" : ""}",
        "title": getTranslatedValue(context, "intro_title_2"),
        "description": getTranslatedValue(context, "intro_description_2"),
      },
      {
        "image":
        "intro_slider_3${Constant.session.getBoolData(SessionManager.isDarkTheme) ? "_dark" : ""}",
        "title": getTranslatedValue(context, "intro_title_3"),
        "description": getTranslatedValue(context, "intro_description_3"),
      },
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF9F5), // Very light pink
              Color(0xFFFFE8ED), // Light rose
              Color(0xFFFFF0F5), // Lavender blush
              Color(0xFFFFF8DC), // Cream
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header section with progress bar and navigation
              Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                child: Column(
                  children: [
                    // Progress bar - full width like image
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: progressBarWidget(),
                    ),
                    getSizedBox(height: screenHeight * 0.02),
                    // Navigation buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button
                          if (currentPosition > 0)
                            Container(
                              width: screenWidth * 0.11,
                              height: screenWidth * 0.11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: ColorsRes.mainTextColor,
                                  size: screenWidth * 0.05,
                                ),
                                onPressed: () {
                                  if (currentPosition > 0) {
                                    currentPosition--;
                                    pageController.animateToPage(
                                      currentPosition,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                    setState(() {});
                                  }
                                },
                              ),
                            )
                          else
                            SizedBox(width: screenWidth * 0.11),
                          // Skip button
                          if (currentPosition < introSlider.length - 1)
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, loginAccountScreen);
                              },
                              child: CustomTextLabel(
                                jsonKey: "skip",
                                style: TextStyle(
                                  color: ColorsRes.mainTextColor,
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else
                            SizedBox(width: screenWidth * 0.11),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main content area
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPosition = index;
                    });
                  },
                  itemCount: introSlider.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        // Image section - takes more space from top
                        Expanded(
                          flex: 6,
                          child: Container(
                            width: double.infinity,
                            child: Center(
                              child: Container(
                                width: screenWidth * 0.72,
                                height: screenWidth * 0.72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withValues(alpha: 0.95),
                                      Colors.white.withValues(alpha: 0.8),
                                    ],
                                    stops: [0.7, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFE9871E).withValues(alpha: 0.15),
                                      blurRadius: 30,
                                      offset: Offset(0, 15),
                                      spreadRadius: 5,
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      blurRadius: 15,
                                      offset: Offset(-5, -5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: ClipOval(
                                    child: Container(
                                      width: screenWidth * 0.6,
                                      height: screenWidth * 0.6,
                                      child: defaultImg(
                                        image: introSlider[index]["image"],
                                        height: screenWidth * 0.6,
                                        width: screenWidth * 0.6,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Text content section - more space for text
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                            child: Column(
                              children: [
                                getSizedBox(height: screenHeight * 0.03),
                                // Title
                                CustomTextLabel(
                                  text: introSlider[index]["title"],
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorsRes.mainTextColor,
                                    fontSize: screenWidth * 0.065,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                getSizedBox(height: screenHeight * 0.015),
                                // Description
                                CustomTextLabel(
                                  text: introSlider[index]["description"],
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorsRes.mainTextColor.withValues(alpha: 0.75),
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Bottom button exactly like image with gradient
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.03,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (currentPosition < introSlider.length - 1) {
                      currentPosition++;
                      pageController.animateToPage(
                        currentPosition,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      setState(() {});
                    } else {
                      Navigator.pushReplacementNamed(context, loginAccountScreen);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFF8A65), // Dark charcoal
                          Color(0xFFFF7043), // Almost black
                          Color(0xFFFF7043), // Pure black
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(screenHeight * 0.035),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Color(0xFF2D2D2D).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left spacing
                        SizedBox(width: screenWidth * 0.12),
                        // Center text
                        Expanded(
                          child: Center(
                            child: CustomTextLabel(
                              jsonKey: currentPosition == introSlider.length - 1
                                  ? "get_started"
                                  : "Continue",
                              style: TextStyle(
                                color: ColorsRes.appColorWhite,
                                fontSize: screenWidth * 0.044,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        // Right arrow in circle
                        Container(
                          width: screenWidth * 0.095,
                          height: screenWidth * 0.095,
                          margin: EdgeInsets.only(right: screenWidth * 0.025),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFFFF7043),
                              size: screenWidth * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Progress bar widget - full width like image
  progressBarWidget() {
    return Row(
      children: List.generate(
        introSlider.length,
            (index) {
          bool isActive = index <= currentPosition;
          return Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: 3,
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                  colors: [
                    ColorsRes.appColor,
                    ColorsRes.appColor.withValues(alpha: 0.8),
                  ],
                )
                    : null,
                color: isActive
                    ? null
                    : ColorsRes.subTitleMainTextColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          );
        },
      ),
    );
  }
}