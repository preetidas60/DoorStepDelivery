import 'package:project/helper/generalWidgets/bottomSheetChangePasswordContainer.dart';
import 'package:project/helper/utils/generalImports.dart';

class ProfileScreen extends StatefulWidget {
  final ScrollController scrollController;

  const ProfileScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List personalDataMenu = [];
  List settingsMenu = [];
  List otherInformationMenu = [];
  List deleteMenuItem = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => setProfileMenuList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          getTranslatedValue(context, "profile"),
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, _) {
          setProfileMenuList();
          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView(
              controller: widget.scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                ProfileHeader(),
                const SizedBox(height: 10),
                QuickUseWidget(),
                const SizedBox(height: 0),
                _buildSection(
                  title: getTranslatedValue(context, "personal_data"),
                  items: personalDataMenu,
                ),
                _buildSection(
                  title: getTranslatedValue(context, "settings"),
                  items: settingsMenu,
                  bottomPadding: 0, // Remove bottom padding for settings
                ),
                _buildSection(
                  title: getTranslatedValue(context, "other_information"),
                  items: otherInformationMenu,
                  topPadding: 0, // Remove top padding for other information
                ),
                if (deleteMenuItem.isNotEmpty)
                  _buildSection(
                    items: deleteMenuItem,
                    fontColor: ColorsRes.appColorRed,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  setProfileMenuList() {
    personalDataMenu = [];
    settingsMenu = [];
    otherInformationMenu = [];
    deleteMenuItem = [];

    personalDataMenu = [
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "wallet_history_icon",
          "label": "my_wallet",
          "value": Consumer<SessionManager>(
            builder: (context, sessionManager, child) {
              return CustomTextLabel(
                text:
                    "${sessionManager.getData(SessionManager.keyWalletBalance)}"
                        .currency,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  color: ColorsRes.mainTextColor,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          "clickFunction": (context) {
            Navigator.pushNamed(context, walletHistoryListScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "notification_icon",
          "label": "notification",
          "clickFunction": (context) {
            Navigator.pushNamed(context, notificationListScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "transaction_icon",
          "label": "transaction_history",
          "clickFunction": (context) {
            Navigator.pushNamed(context, transactionListScreen);
          },
          "isResetLabel": false
        },
    ];

    settingsMenu = [
      if (Constant.session.isUserLoggedIn() &&
          (Constant.session.getData(SessionManager.keyLoginType) == "phone" ||
              Constant.session.getData(SessionManager.keyLoginType) == "email"))
        {
          "icon": "password_icon",
          "label": "change_password",
          "clickFunction": (context) {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
              backgroundColor: Theme.of(context).cardColor,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    BottomSheetChangePasswordContainer(),
                  ],
                );
              },
            );
          },
          "isResetLabel": false
        },
      {
        "icon": "theme_icon",
        "label": "change_theme",
        "clickFunction": (context) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
            backgroundColor: Theme.of(context).cardColor,
            builder: (BuildContext context) {
              return Wrap(
                children: [
                  BottomSheetThemeListContainer(),
                ],
              );
            },
          );
        },
        "isResetLabel": true,
      },
      // if (context.read<LanguageProvider>().languages.length > 1)
      //   {
      //     "icon": "translate_icon",
      //     "label": "change_language",
      //     "clickFunction": (context) {
      //       showModalBottomSheet<void>(
      //         context: context,
      //         isScrollControlled: true,
      //         shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
      //         backgroundColor: Theme.of(context).cardColor,
      //         builder: (BuildContext context) {
      //           return Wrap(
      //             children: [
      //               BottomSheetLanguageListContainer(),
      //             ],
      //           );
      //         },
      //       );
      //     },
      //     "isResetLabel": true,
      //   },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "settings",
          "label": "notifications_settings",
          "clickFunction": (context) {
            Navigator.pushNamed(
                context, notificationsAndMailSettingsScreenScreen);
          },
          "isResetLabel": false
        },
    ];

    otherInformationMenu = [
/*      if (isUserLogin)
        {
          "icon": "refer_friend_icon",
          "label": "refer_and_earn",
          "clickFunction": ReferAndEarn(),
          "isResetLabel": false
        },*/
      {
        "icon": "contact_icon",
        "label": "contact_us",
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              "contact_us",
            ),
          );
        }
      },
      {
        "icon": "about_icon",
        "label": "about_us",
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              "about_us",
            ),
          );
        },
        "isResetLabel": false
      },
      {
        "icon": "rate_us_icon",
        "label": "rate_us",
        "clickFunction": (BuildContext context) {
          launchUrl(
              Uri.parse(Platform.isAndroid
                  ? Constant.playStoreUrl
                  : Constant.appStoreUrl),
              mode: LaunchMode.externalApplication);
        },
      },
      {
        "icon": "share_icon",
        "label": "share_app",
        "clickFunction": (BuildContext context) {
          String shareAppMessage = getTranslatedValue(
            context,
            "share_app_message",
          );
          if (Platform.isAndroid) {
            shareAppMessage = "$shareAppMessage${Constant.playStoreUrl}";
          } else if (Platform.isIOS) {
            shareAppMessage = "$shareAppMessage${Constant.appStoreUrl}";
          }
          Share.share(shareAppMessage, subject: "Share app");
        },
      },
      {
        "icon": "faq_icon",
        "label": "faq",
        "clickFunction": (context) {
          Navigator.pushNamed(context, faqListScreen);
        }
      },
      {
        "icon": "terms_icon",
        "label": "terms_and_conditions",
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                "terms_and_conditions",
              ));
        }
      },
      {
        "icon": "privacy_icon",
        "label": "policies",
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                "policies",
              ));
        }
      },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "logout_icon",
          "label": "logout",
          "clickFunction": Constant.session.logoutUser,
          "isResetLabel": false
        },
    ];

    deleteMenuItem = [
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "delete_user_account_icon",
          "label": "delete_user_account",
          "clickFunction": Constant.session.deleteUserAccount,
          "isResetLabel": false
        },
    ];
  }


  Widget _buildMenuItem({
    required BuildContext context,
    required String icon,
    required String label,
    Widget? value,
    Color? fontColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      minLeadingWidth: 0,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ColorsRes.appColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Center(
          child: defaultImg(
            image: icon,
            iconColor: fontColor ?? ColorsRes.appColor,
            height: 20,
            width: 20,
          ),
        ),
      ),
      title: Text(
        getTranslatedValue(context, label),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: fontColor ?? ColorsRes.mainTextColor,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) value,
          if (value != null) SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            color: fontColor ?? ColorsRes.mainTextColor.withOpacity(0.6),
          ),
        ],
      ),
    );
  }


  Widget _buildSection({
    String title = "",
    required List<dynamic> items,
    Color? fontColor,
    double topPadding = 8, // Add top padding parameter
    double bottomPadding = 24, // Add bottom padding parameter
  }) {
    if (items.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding, // Use top padding
        bottom: bottomPadding, // Use bottom padding
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorsRes.mainTextColor,
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 60,
                endIndent: 20,
                color: ColorsRes.mainTextColor.withOpacity(0.1),
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildMenuItem(
                  context: context,
                  icon: item['icon'],
                  label: item['label'],
                  value: item['value'],
                  fontColor: fontColor,
                  onTap: () => item['clickFunction'](context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
