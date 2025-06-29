import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/helper/utils/generalImports.dart';

enum AuthProviders { phone, google, apple, emailPassword }

class LoginAccountScreen extends StatefulWidget {
  final String? from;

  const LoginAccountScreen({Key? key, this.from}) : super(key: key);

  @override
  State<LoginAccountScreen> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<LoginAccountScreen> {
  CountryCode? selectedCountryCode;

  // TODO REMOVE DEMO NUMBER FROM HERE
  TextEditingController editMobileTextEditingController =
  TextEditingController(text: "");
  final TextEditingController editEmailTextEditingController =
  TextEditingController();
  final TextEditingController editPasswordTextEditingController =
  TextEditingController();
  final TextEditingController editPhonePasswordTextEditingController =
  TextEditingController();
  final pinController = TextEditingController();
  String otpVerificationId = "";
  int? forceResendingToken;
  bool showMobileNumberWidget = Constant.authTypePhoneLogin == "1",
      showOtpWidget = false,
      isLoading = false;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ["profile", "email"]);

  AuthProviders authProvider = Constant.authTypePhoneLogin == "1"
      ? AuthProviders.phone
      : Constant.authTypeEmailLogin == "1"
      ? AuthProviders.emailPassword
      : Constant.authTypeGoogleLogin == "1"
      ? AuthProviders.google
      : AuthProviders.apple;

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final maxContentWidth = isTablet ? 500.0 : screenWidth;

    // Calculate responsive values
    final topImageHeight = screenHeight * 0.25; // 25% of screen height
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final contentTopMargin = topImageHeight + (screenHeight * 0.02); // Image height + 2% margin

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: [
          // Top image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: screenHeight * 0.025), // 2.5% of screen height
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: defaultImg(
                image: "grocery4.png",
                height: topImageHeight * 0.8, // 80% of allocated image space
                width: screenWidth * 0.6, // 60% of screen width
                boxFit: BoxFit.contain,
                iconColor: ColorsRes.mainTextColor,
              ),
            ),
          ),

          // Skip button on top of the image
          PositionedDirectional(
            top: screenHeight * 0.04, // 4% from top
            end: horizontalPadding * 0.5,
            child: skipLoginText(),
          ),

          // Content below the image
          PositionedDirectional(
            top: contentTopMargin,
            start: 0,
            end: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: maxContentWidth,
                child: loginWidgets(),
              ),
            ),
          ),

          // Loading overlay
          if (isLoading && authProvider != AuthProviders.phone)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(77),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorsRes.appColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget proceedBtn() {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = screenHeight * 0.065; // 6.5% of screen height

    return (isLoading && authProvider == AuthProviders.phone)
        ? Container(
      height: buttonHeight,
      alignment: AlignmentDirectional.center,
      child: CircularProgressIndicator(),
    )
        : gradientBtnWidget(
      context,
      10,
      title: getTranslatedValue(
        context,
        "login",
      ).toUpperCase(),
      callback: () {
        if (authProvider == AuthProviders.phone) {
          loginWithPhoneNumber();
        } else if (authProvider == AuthProviders.emailPassword) {
          loginWithEmailIdPassword();
        }
      },
    );
  }

  Widget skipLoginText() {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.035; // 3.5% of screen width

    return GestureDetector(
      onTap: () async {
        if (isLoading == false) {
          Constant.session
              .setBoolData(SessionManager.keySkipLogin, true, false);
          await getRedirection();
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.025, // 2.5% of screen width
          vertical: screenWidth * 0.0125, // 1.25% of screen width
        ),
        child: CustomTextLabel(
          jsonKey: "skip_login",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: ColorsRes.mainTextColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Widget loginWidgets() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final verticalSpacing = screenHeight * 0.025; // 2.5% of screen height
    final titleFontSize = screenWidth * 0.075; // 7.5% of screen width (responsive title)

    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.76,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: verticalSpacing * 0.8),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: horizontalPadding,
                end: horizontalPadding,
                top: verticalSpacing * 0.8,
              ),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: titleFontSize,
                      color: ColorsRes.mainTextColor,
                    ),
                  ),
                  text: "${getTranslatedValue(
                    context,
                    "welcome",
                  )} ",
                  children: <TextSpan>[
                    TextSpan(
                      text: "\nDoorStep Delivery!",
                      style: GoogleFonts.lora(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        fontSize: titleFontSize,
                        color: ColorsRes.appColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (Constant.authTypePhoneLogin == "1" ||
                Constant.authTypeEmailLogin == "1") ...[
              SizedBox(height: verticalSpacing * 1.2),
              AnimatedOpacity(
                opacity: showMobileNumberWidget ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Visibility(
                  visible: showMobileNumberWidget,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                      start: horizontalPadding,
                      end: horizontalPadding,
                    ),
                    child: mobilePasswordWidget(),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: !showMobileNumberWidget ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Visibility(
                  visible: !showMobileNumberWidget,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                      start: horizontalPadding,
                      end: horizontalPadding,
                    ),
                    child: emailPasswordWidget(),
                  ),
                ),
              ),
              SizedBox(height: verticalSpacing * 0.8),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: horizontalPadding,
                  end: horizontalPadding,
                ),
                child: proceedBtn(),
              ),
              SizedBox(height: verticalSpacing * 0.8),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    editProfileScreen,
                    arguments: [
                      !showMobileNumberWidget
                          ? "email_register"
                          : "mobile_register",
                      {
                        ApiAndParams.type: "email",
                        ApiAndParams.fcmToken: Constant.session
                            .getData(SessionManager.keyFCMToken),
                      }
                    ],
                  );
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: horizontalPadding,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextLabel(
                        jsonKey: "dont_have_an_account",
                        style: TextStyle(
                          color: ColorsRes.subTitleMainTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.035, // Responsive font size
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.0125), // Responsive spacing
                      CustomTextLabel(
                        jsonKey: "wants_to_register",
                        style: TextStyle(
                          color: ColorsRes.appColor,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.035, // Responsive font size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: verticalSpacing * 1.2),
              if (Platform.isIOS && Constant.authTypeAppleLogin == "1" ||
                  Constant.authTypeGoogleLogin == "1")
                buildDottedDivider(context),
              SizedBox(height: verticalSpacing * 1.2),
            ],
            if (Platform.isIOS && Constant.authTypeAppleLogin == "1") ...[
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: horizontalPadding,
                  end: horizontalPadding,
                ),
                child: SocialMediaLoginButtonWidget(
                  text: "continue_with_apple",
                  logo: "apple_logo",
                  logoColor: ColorsRes.mainTextColor,
                  onPressed: () async {
                    authProvider = AuthProviders.apple;
                    await signInWithApple(
                      context: context,
                      firebaseAuth: firebaseAuth,
                      googleSignIn: googleSignIn,
                    ).then(
                          (value) {
                        setState(() {
                          isLoading = true;
                        });
                        if (value is UserCredential) {
                          setState(() {
                            isLoading = false;
                          });
                          backendApiProcess(value.user);
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          showMessage(
                              context, value.toString(), MessageType.error);
                        }
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: verticalSpacing * 0.4),
            ],
            if (Constant.authTypeGoogleLogin == "1")
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: horizontalPadding,
                  end: horizontalPadding,
                ),
                child: SocialMediaLoginButtonWidget(
                  text: "continue_with_google",
                  logo: "google_logo",
                  onPressed: () async {
                    authProvider = AuthProviders.google;
                    signOut(
                        googleSignIn: googleSignIn,
                        authProvider: authProvider,
                        firebaseAuth: firebaseAuth)
                        .then(
                          (value) async {
                        await signInWithGoogle(
                          context: context,
                          firebaseAuth: firebaseAuth,
                          googleSignIn: googleSignIn,
                        ).then(
                              (value) {
                            if (value is UserCredential) {
                              backendApiProcess(value.user);
                            } else {
                              showMessage(
                                  context, value.toString(), MessageType.error);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            if (Constant.authTypeEmailLogin == "1" &&
                Constant.authTypePhoneLogin == "1") ...[
              if (showMobileNumberWidget)
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: horizontalPadding,
                    end: horizontalPadding,
                  ),
                  child: SocialMediaLoginButtonWidget(
                    text: "continue_with_email",
                    logo: "email_logo",
                    logoColor: ColorsRes.appColor,
                    onPressed: () async {
                      authProvider = AuthProviders.emailPassword;
                      showMobileNumberWidget = false;
                      setState(() {});
                    },
                  ),
                ),
              if (!showMobileNumberWidget)
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: horizontalPadding,
                    end: horizontalPadding,
                  ),
                  child: SocialMediaLoginButtonWidget(
                    text: "continue_with_phone",
                    logo: "phone_logo",
                    logoColor: ColorsRes.appColor,
                    onPressed: () async {
                      authProvider = AuthProviders.phone;
                      showMobileNumberWidget = true;
                      setState(() {});
                    },
                  ),
                ),
            ],
            SizedBox(height: verticalSpacing * 0.8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding * 1.5),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorsRes.subTitleMainTextColor,
                      fontSize: screenWidth * 0.032, // Responsive font size
                    ),
                    text: getTranslatedValue(context, "agreement_message_1") + " ",
                    children: <TextSpan>[
                      TextSpan(
                        text: getTranslatedValue(context, "terms_of_service"),
                        style: TextStyle(
                          color: ColorsRes.appColor,
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * 0.032, // Responsive font size
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                              context,
                              webViewScreen,
                              arguments: getTranslatedValue(context, "terms_and_conditions"),
                            );
                          },
                      ),
                      TextSpan(
                        text: " ${getTranslatedValue(context, "and")} ",
                        style: TextStyle(
                          color: ColorsRes.subTitleMainTextColor,
                          fontSize: screenWidth * 0.032, // Responsive font size
                        ),
                      ),
                      TextSpan(
                        text: getTranslatedValue(context, "privacy_policy"),
                        style: TextStyle(
                          color: ColorsRes.appColor,
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * 0.032, // Responsive font size
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                              context,
                              webViewScreen,
                              arguments: getTranslatedValue(context, "privacy_policy"),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: verticalSpacing * 0.8),
          ],
        ),
      ),
    );
  }

  mobilePasswordWidget() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final verticalSpacing = screenHeight * 0.025; // 2.5% of screen height

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          opacity: showMobileNumberWidget ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Visibility(
            visible: showMobileNumberWidget,
            child: Container(
              decoration: DesignConfig.boxDecoration(
                  Colors.transparent, 10,
                  bordercolor: ColorsRes.subTitleMainTextColor,
                  isboarder: true,
                  borderwidth: 1.0),
              child: Row(
                children: [
                  SizedBox(width: screenWidth * 0.0125), // Responsive spacing
                  IgnorePointer(
                    ignoring: isLoading,
                    child: CountryCodePicker(
                      onInit: (countryCode) {
                        selectedCountryCode = countryCode;
                      },
                      onChanged: (countryCode) {
                        selectedCountryCode = countryCode;
                      },
                      initialSelection: Constant.initialCountryCode,
                      textOverflow: TextOverflow.ellipsis,
                      backgroundColor: Theme.of(context).cardColor,
                      textStyle: TextStyle(
                        color: ColorsRes.mainTextColor,
                        fontSize: screenWidth * 0.038, // Responsive font size
                      ),
                      dialogBackgroundColor: Theme.of(context).cardColor,
                      dialogSize: Size(screenWidth, screenHeight),
                      barrierColor: ColorsRes.subTitleMainTextColor,
                      padding: EdgeInsets.zero,
                      searchDecoration: InputDecoration(
                        iconColor: ColorsRes.subTitleMainTextColor,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorsRes.subTitleMainTextColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorsRes.subTitleMainTextColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorsRes.subTitleMainTextColor),
                        ),
                        focusColor: Theme.of(context).scaffoldBackgroundColor,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: ColorsRes.subTitleMainTextColor,
                        ),
                      ),
                      searchStyle: TextStyle(
                        color: ColorsRes.subTitleMainTextColor,
                        fontSize: screenWidth * 0.038, // Responsive font size
                      ),
                      dialogTextStyle: TextStyle(
                        color: ColorsRes.mainTextColor,
                        fontSize: screenWidth * 0.038, // Responsive font size
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorsRes.grey,
                    size: screenWidth * 0.038, // Responsive icon size
                  ),
                  SizedBox(width: screenWidth * 0.025), // Responsive spacing
                  Expanded(
                    child: TextField(
                      controller: editMobileTextEditingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: TextStyle(
                        color: ColorsRes.mainTextColor,
                        fontSize: screenWidth * 0.038, // Responsive font size
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(
                          color: ColorsRes.grey.withValues(alpha: 0.8),
                          fontSize: screenWidth * 0.038, // Responsive font size
                        ),
                        hintText:
                        getTranslatedValue(context, "phone_number_hint"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        (context.read<AppSettingsProvider>().settingsData!.phoneAuthPassword ==
            "1")
            ? SizedBox(height: verticalSpacing * 0.8)
            : const SizedBox.shrink(),
        (context.read<AppSettingsProvider>().settingsData!.phoneAuthPassword ==
            "1")
            ? AnimatedOpacity(
          opacity: showMobileNumberWidget ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Visibility(
            visible: showMobileNumberWidget,
            child: Consumer<PasswordShowHideProvider>(
              builder: (context, provider, child) {
                return editBoxWidget(
                  context,
                  editPhonePasswordTextEditingController,
                  emptyValidation,
                  getTranslatedValue(
                    context,
                    "password",
                  ),
                  getTranslatedValue(
                    context,
                    "enter_valid_password",
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  leadingIcon: Icon(
                    Icons.password_rounded,
                    color: ColorsRes.grey,
                    size: screenWidth * 0.065, // Responsive icon size
                  ),
                  maxLines: 1,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  obscureText: provider.isPasswordShowing(),
                  tailIcon: GestureDetector(
                    onTap: () {
                      provider.togglePasswordVisibility();
                    },
                    child: defaultImg(
                      image: provider.isPasswordShowing() == true
                          ? "hide_password"
                          : "show_password",
                      iconColor: ColorsRes.grey,
                      width: screenWidth * 0.034, // Responsive width
                      height: screenWidth * 0.034, // Responsive height
                      padding: EdgeInsetsDirectional.all(screenWidth * 0.03), // Responsive padding
                    ),
                  ),
                  optionalTextInputAction: TextInputAction.done,
                  TextInputType.text,
                );
              },
            ),
          ),
        )
            : const SizedBox.shrink(),
        (context.read<AppSettingsProvider>().settingsData!.phoneAuthPassword ==
            "1")
            ? SizedBox(height: verticalSpacing * 0.4)
            : const SizedBox.shrink(),
        (context.read<AppSettingsProvider>().settingsData!.phoneAuthPassword ==
            "1")
            ? Align(
          alignment: AlignmentDirectional.centerEnd,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(forgotPasswordScreen,
                  arguments: [true, "user_exist"]);
            },
            child: CustomTextLabel(
              jsonKey: "forgot_password",
              style: TextStyle(
                color: ColorsRes.appColor,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.035, // Responsive font size
              ),
            ),
          ),
        )
            : const SizedBox.shrink(),
      ],
    );
  }

  emailPasswordWidget() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final verticalSpacing = screenHeight * 0.025; // 2.5% of screen height

    return Column(
      children: [
        editBoxWidget(
          context,
          editEmailTextEditingController,
          emailValidation,
          getTranslatedValue(
            context,
            "email",
          ),
          getTranslatedValue(
            context,
            "enter_valid_email",
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          leadingIcon: Icon(
            Icons.alternate_email_outlined,
            color: ColorsRes.grey,
            size: screenWidth * 0.065, // Responsive icon size
          ),
          maxLines: 1,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          TextInputType.emailAddress,
        ),
        SizedBox(height: verticalSpacing * 0.8),
        Consumer<PasswordShowHideProvider>(
          builder: (context, provider, child) {
            return editBoxWidget(
              context,
              editPasswordTextEditingController,
              emptyValidation,
              getTranslatedValue(
                context,
                "password",
              ),
              getTranslatedValue(
                context,
                "enter_valid_password",
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              leadingIcon: Icon(
                Icons.password_rounded,
                color: ColorsRes.grey,
                size: screenWidth * 0.065, // Responsive icon size
              ),
              maxLines: 1,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              obscureText: provider.isPasswordShowing(),
              tailIcon: GestureDetector(
                onTap: () {
                  provider.togglePasswordVisibility();
                },
                child: defaultImg(
                  image: provider.isPasswordShowing() == true
                      ? "hide_password"
                      : "show_password",
                  iconColor: ColorsRes.grey,
                  width: screenWidth * 0.034, // Responsive width
                  height: screenWidth * 0.034, // Responsive height
                  padding: EdgeInsetsDirectional.all(screenWidth * 0.03), // Responsive padding
                ),
              ),
              optionalTextInputAction: TextInputAction.done,
              TextInputType.text,
            );
          },
        ),
        SizedBox(height: verticalSpacing * 0.4),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(forgotPasswordScreen,
                  arguments: [false, "user_exist"]);
            },
            child: CustomTextLabel(
              jsonKey: "forgot_password",
              style: TextStyle(
                color: ColorsRes.appColor,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.035, // Responsive font size
              ),
            ),
          ),
        ),
        if (showOtpWidget) SizedBox(height: verticalSpacing * 0.4),
        if (showOtpWidget)
          AnimatedOpacity(
            opacity: showOtpWidget ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: Visibility(
              visible: showOtpWidget,
              child: Column(
                children: [
                  SizedBox(height: verticalSpacing * 0.6),
                  otpPinWidget(context: context, pinController: pinController)
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Rest of the methods remain the same as they contain business logic
  getRedirection() async {
    if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
        Constant.session.getBoolData(SessionManager.isUserLogin)) {
      Navigator.pushReplacementNamed(
        context,
        mainHomeScreen,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        mainHomeScreen,
            (route) => false,
      );
    }
  }

  Future<bool> fieldValidation() async {
    bool checkInternet = await checkInternetConnection();
    if (!checkInternet) {
      showMessage(
        context,
        getTranslatedValue(
          context,
          "check_internet",
        ),
        MessageType.warning,
      );
      return false;
    } else if (authProvider == AuthProviders.phone) {
      String? mobileValidate = await phoneValidation(
        editMobileTextEditingController.text,
      );
      if (mobileValidate == "") {
        showMessage(
          context,
          getTranslatedValue(
            context,
            "enter_valid_mobile",
          ),
          MessageType.warning,
        );
        return false;
      } else if (mobileValidate != null &&
          editMobileTextEditingController.text.length > 15) {
        showMessage(
          context,
          getTranslatedValue(
            context,
            "enter_valid_mobile",
          ),
          MessageType.warning,
        );
        return false;
      } else {
        return true;
      }
    } else if (authProvider == AuthProviders.emailPassword) {
      String? emailValidate = await emailValidation(
        editEmailTextEditingController.text,
      );

      String? passwordValidate = await emptyValidation(
        editPasswordTextEditingController.text,
      );

      if (emailValidate == "") {
        showMessage(
          context,
          getTranslatedValue(
            context,
            "enter_valid_email",
          ),
          MessageType.warning,
        );
        return false;
      } else if (passwordValidate == "") {
        showMessage(
          context,
          getTranslatedValue(
            context,
            "enter_valid_password",
          ),
          MessageType.warning,
        );
        return false;
      } else if (editPasswordTextEditingController.text.length <= 5) {
        showMessage(
          context,
          getTranslatedValue(
            context,
            "password_length_is_too_short",
          ),
          MessageType.warning,
        );
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  loginWithPhoneNumber() async {
    var validation = await fieldValidation();
    if (validation) {
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      firebaseLoginProcess();
    }
  }

  loginWithEmailIdPassword() async {
    var validation = (await fieldValidation());
    if (validation) {
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      backendApiProcess(null);
    }
  }

  firebaseLoginProcess() async {
    setState(() {});
    if (editMobileTextEditingController.text.isNotEmpty) {
      if (context.read<AppSettingsProvider>().settingsData!.phoneAuthPassword ==
          "1") {
        callLoginApi(null);
      } else {
        if (context
                .read<AppSettingsProvider>()
                .settingsData!
                .firebaseAuthentication ==
            "1") {
          await firebaseAuth.verifyPhoneNumber(
            timeout: Duration(minutes: 1, seconds: 30),
            phoneNumber:
                '${selectedCountryCode!.dialCode}${editMobileTextEditingController.text}',
            verificationCompleted: (PhoneAuthCredential credential) {},
            verificationFailed: (FirebaseAuthException e) {
              showMessage(
                context,
                e.message!,
                MessageType.warning,
              );

              setState(() {
                isLoading = false;
              });
            },
            codeSent: (String verificationId, int? resendToken) {
              forceResendingToken = resendToken;
              isLoading = false;
              setState(() {
                otpVerificationId = verificationId;

                List<dynamic> firebaseArguments = [
                  firebaseAuth,
                  otpVerificationId,
                  editMobileTextEditingController.text,
                  selectedCountryCode!,
                  widget.from ?? null
                ];
                Navigator.pushNamed(context, otpScreen,
                    arguments: firebaseArguments);
              });
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            forceResendingToken: forceResendingToken,
          );
        } else if (Constant.customSmsGatewayOtpBased == "1") {
          context.read<UserProfileProvider>().sendCustomOTPSmsProvider(
            context: context,
            params: {
              ApiAndParams.phone:
                  "$selectedCountryCode${editMobileTextEditingController.text}"
            },
          ).then(
            (value) {
              if (value == "1") {
                List<dynamic> firebaseArguments = [
                  firebaseAuth,
                  otpVerificationId,
                  editMobileTextEditingController.text,
                  selectedCountryCode!,
                  widget.from ?? null
                ];
                Navigator.pushNamed(context, otpScreen,
                    arguments: firebaseArguments);
              } else {
                setState(() {
                  isLoading = false;
                });
                showMessage(
                  context,
                  getTranslatedValue(
                    context,
                    "custom_send_sms_error_message",
                  ),
                  MessageType.warning,
                );
              }
            },
          );
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  backendApiProcess(User? user) async {
    if (showOtpWidget) {
      context
          .read<UserProfileProvider>()
          .verifyRegisteredEmailProvider(
              context: context,
              params: {
                ApiAndParams.email: editEmailTextEditingController.text,
                ApiAndParams.code: pinController.text,
              },
              from: "login")
          .then(
        (value) async {
          await callLoginApi(user);
        },
      );
    } else {
      await callLoginApi(user);
    }
  }

  Future callLoginApi(User? user) async {
    Map<String, String> params = {
      ApiAndParams.id: authProvider == AuthProviders.phone
          ? editMobileTextEditingController.text
          : authProvider == AuthProviders.emailPassword
              ? editEmailTextEditingController.text
              : user?.email.toString() ?? "",
      ApiAndParams.type: authProvider == AuthProviders.phone
          ? "phone"
          : authProvider == AuthProviders.google
              ? "google"
              : authProvider == AuthProviders.apple
                  ? "apple"
                  : authProvider == AuthProviders.emailPassword
                      ? "email"
                      : "",
      ApiAndParams.platform: Platform.isAndroid ? "android" : "ios",
      ApiAndParams.fcmToken:
          Constant.session.getData(SessionManager.keyFCMToken),
    };

    if (authProvider == AuthProviders.emailPassword) {
      params[ApiAndParams.password] =
          editPasswordTextEditingController.text.trim();
    }
    if (authProvider == AuthProviders.phone) {
      params[ApiAndParams.password] =
          editPhonePasswordTextEditingController.text.trim();
      params[ApiAndParams.phoneAuthType] = (context
                  .read<AppSettingsProvider>()
                  .settingsData!
                  .phoneAuthPassword ==
              "1")
          ? "phone_auth_password"
          : "phone_auth_otp";
    }

    await context
        .read<UserProfileProvider>()
        .loginApi(context: context, params: params)
        .then(
      (value) async {
        isLoading = false;
        setState(() {});
        if (value == 1) {
          if (widget.from == "add_to_cart") {
            addGuestCartBulkToCartWhileLogin(
              context: context,
              params: Constant.setGuestCartParams(
                cartList: context.read<CartListProvider>().cartList,
              ),
            ).then((value) {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          } else if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
            if (context.read<CartListProvider>().cartList.isNotEmpty) {
              addGuestCartBulkToCartWhileLogin(
                context: context,
                params: Constant.setGuestCartParams(
                  cartList: context.read<CartListProvider>().cartList,
                ),
              ).then(
                (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                  mainHomeScreen,
                  (Route<dynamic> route) => false,
                ),
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                mainHomeScreen,
                (Route<dynamic> route) => false,
              );
            }
          }
        } else if (value == 2) {
          showOtpWidget = true;
          setState(() {});
        } else if (value == 3) {
          Navigator.of(context).pushNamed(forgotPasswordScreen,
              arguments: [true, "user_exist_password_blank"]);
        } else if (value == 4) {
          showMessage(
            context,
            getTranslatedValue(
              context,
              "invalid_password",
            ),
            MessageType.warning,
          );
        } else if (value == 5) {
          showMessage(
            context,
            getTranslatedValue(
              context,
              "user_deactivated",
            ),
            MessageType.warning,
          );
        } else {
          setState(() {
            isLoading = false;
          });
          if (user != null) {
            Constant.session.setData(SessionManager.keyUserImage,
                firebaseAuth.currentUser!.photoURL.toString(), false);

            Navigator.of(context).pushNamed(
              editProfileScreen,
              arguments: [
                widget.from ?? "register",
                {
                  ApiAndParams.id: authProvider == AuthProviders.phone
                      ? editMobileTextEditingController.text
                      : user.email.toString(),
                  ApiAndParams.type: authProvider == AuthProviders.phone
                      ? "phone"
                      : authProvider == AuthProviders.google
                          ? "google"
                          : "apple",
                  ApiAndParams.name:
                      firebaseAuth.currentUser!.displayName ?? "",
                  ApiAndParams.email: firebaseAuth.currentUser!.email ?? "",
                  ApiAndParams.countryCode: "",
                  ApiAndParams.mobile:
                      firebaseAuth.currentUser!.phoneNumber ?? "",
                  ApiAndParams.platform: Platform.isAndroid ? "android" : "ios",
                  ApiAndParams.fcmToken:
                      Constant.session.getData(SessionManager.keyFCMToken),
                }
              ],
            );
          } else {
            if (value == 0) {
              showMessage(
                context,
                getTranslatedValue(
                  context,
                  "user_not_registered",
                ),
                MessageType.warning,
              );
            } else {
              showMessage(
                context,
                getTranslatedValue(
                  context,
                  "something_went_wrong",
                ),
                MessageType.warning,
              );
            }
          }
        }
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CountryCode?>(
        'selectedCountryCode', selectedCountryCode));
  }
}
