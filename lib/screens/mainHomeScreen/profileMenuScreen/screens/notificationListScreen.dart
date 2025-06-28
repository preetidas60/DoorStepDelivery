import 'package:project/helper/utils/generalImports.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<NotificationProvider>().hasMoreData) {
          context
              .read<NotificationProvider>()
              .getNotificationProvider(params: {}, context: context);
        }
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    Future.delayed(Duration.zero).then((value) {
      context
          .read<NotificationProvider>()
          .getNotificationProvider(params: {}, context: context);
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    Constant.resetTempFilters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: "notification",
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: setRefreshIndicator(
        refreshCallback: () {
          context.read<CartListProvider>().getAllCartItems(context: context);
          context.read<NotificationProvider>().notifications.clear();
          context.read<NotificationProvider>().offset = 0;
          return context
              .read<NotificationProvider>()
              .getNotificationProvider(params: {}, context: context);
        },
        child: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.zero,
          child: notificationItemsWidget(),
        ),
      ),
    );
  }

  // Custom empty notification state widget
  Widget _buildEmptyNotificationState() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Notification Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: ColorsRes.appColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 50,
              color: ColorsRes.appColor.withOpacity(0.6),
            ),
          ),
          getSizedBox(height: Constant.size30),
          // No Notifications Text
          CustomTextLabel(
            text: "No Notifications",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ColorsRes.mainTextColor,
            ),
          ),
          getSizedBox(height: Constant.size10),
          // Description Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.size30),
            child: CustomTextLabel(
              text: "You don't have any notifications yet.\nWe'll notify you when something arrives!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: ColorsRes.mainTextColor.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  notificationItemsWidget() {
    return Consumer<NotificationProvider>(
        builder: (context, notificationProvider, _) {
          List<NotificationListData> notifications =
              notificationProvider.notifications;
          if (notificationProvider.itemsState == NotificationState.initial) {
            return getNotificationListShimmer();
          } else if (notificationProvider.itemsState == NotificationState.loading) {
            return getNotificationListShimmer();
          } else if (notificationProvider.itemsState == NotificationState.loaded ||
              notificationProvider.itemsState == NotificationState.loadingMore) {
            // Check if notifications list is empty
            if (notifications.isEmpty) {
              return _buildEmptyNotificationState();
            }
            return Column(
              children: List.generate(notifications.length, (index) {
                NotificationListData notification = notifications[index];
                return GestureDetector(
                  onTap: () async {
                    if (notification.type == "category") {
                      Navigator.pushNamed(context, productListScreen, arguments: [
                        "category",
                        notification.typeId.toString(),
                        ""
                      ]);
                    } else if (notification.type == "product") {
                      Navigator.pushNamed(context, productDetailScreen,
                          arguments: [notification.typeId.toString(), "", null]);
                    } else if (notification.type == "url") {
                      if (await canLaunchUrl(
                        Uri.parse(notification.linkUrl),
                      )) {
                        await launchUrl(Uri.parse(notification.linkUrl),
                            mode: LaunchMode.externalApplication);
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Constant.size5, horizontal: Constant.size5),
                    margin: EdgeInsets.symmetric(
                        vertical: Constant.size5, horizontal: Constant.size10),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: Row(
                      children: [
                        notification.imageUrl != ""
                            ? ClipRRect(
                          borderRadius: Constant.borderRadius10,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: setNetworkImg(
                            height: 60,
                            width: 60,
                            boxFit: BoxFit.cover,
                            image: notification.imageUrl,
                          ),
                        )
                            : Container(
                          height: 60,
                          width: 60,
                          decoration: DesignConfig.boxGradient(10),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Constant.size10,
                                horizontal: Constant.size10),
                            child: defaultImg(
                              height: 20,
                              width: 20,
                              image: "notification_icon",
                              iconColor: ColorsRes.mainIconColor,
                            ),
                          ),
                        ),
                        getSizedBox(
                          width: Constant.size20,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextLabel(
                                text: notification.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                              getSizedBox(
                                height: Constant.size10,
                              ),
                              CustomTextLabel(
                                text: notification.message,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                              Container(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: notification.type == "category"
                                    ? CustomTextLabel(
                                  jsonKey: "go_to_category",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: ColorsRes.appColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                                    : notification.type == "product"
                                    ? CustomTextLabel(
                                  jsonKey: "go_to_product",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: ColorsRes.appColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                                    : Container(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          } else if (notificationProvider.itemsState == NotificationState.error) {
            // Use custom empty state instead of DefaultBlankItemMessageScreen
            return _buildEmptyNotificationState();
          } else {
            return Container();
          }
        });
  }

  getNotificationListShimmer() {
    return Column(
      children: List.generate(
        20,
            (index) => notificationItemShimmer(),
      ),
    );
  }

  notificationItemShimmer() {
    return CustomShimmer(
      margin: EdgeInsets.symmetric(
          vertical: Constant.size5, horizontal: Constant.size10),
      height: 70,
      width: context.width,
    );
  }
}