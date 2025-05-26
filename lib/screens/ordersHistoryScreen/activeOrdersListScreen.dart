import 'package:project/helper/utils/generalImports.dart';
import 'package:project/screens/ordersHistoryScreen/widgets/orderListShimmer.dart';

class ActiveOrderListScreen extends StatefulWidget {
  const ActiveOrderListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ActiveOrderListScreen> createState() => _ActiveOrderListScreenState();
}

class _ActiveOrderListScreenState extends State<ActiveOrderListScreen>
    with TickerProviderStateMixin {
  late ScrollController scrollController = ScrollController()
    ..addListener(scrollListener);

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ActiveOrdersProvider>().hasMoreData) {
          context
              .read<ActiveOrdersProvider>()
              .getOrders(params: {}, context: context);
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<ActiveOrdersProvider>().getOrders(
          params: {ApiAndParams.type: ApiAndParams.active}, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ActiveOrdersProvider>(
        builder: (_, activeOrdersProvider, __) {
          if (activeOrdersProvider.activeOrdersState ==
                  ActiveOrdersState.loaded ||
              activeOrdersProvider.activeOrdersState ==
                  ActiveOrdersState.loadingMore) {
            return setRefreshIndicator(
              refreshCallback: () async {
                context.read<ActiveOrdersProvider>().orders.clear();
                context.read<ActiveOrdersProvider>().offset = 0;
                await context.read<ActiveOrdersProvider>().getOrders(
                    params: {ApiAndParams.type: ApiAndParams.active},
                    context: context);
              },
              child: ListView(
                controller: scrollController,
                children: [
                  ...List.generate(
                    activeOrdersProvider.orders.length,
                    (index) {
                      Order order = activeOrdersProvider.orders[index];
                      return OrderItemContainer(
                        order: order,
                        from: "activeOrders",
                      );
                    },
                  ),
                  if (activeOrdersProvider.activeOrdersState ==
                      ActiveOrdersState.loadingMore)
                    OrderContainerShimmer(),
                ],
              ),
            );
          }
          if (activeOrdersProvider.activeOrdersState ==
              ActiveOrdersState.loading) {
            return OrderListShimmer();
          }
          if (activeOrdersProvider.activeOrdersState ==
              ActiveOrdersState.empty) {
            return Container(
              alignment: Alignment.center,
              height: context.height,
              width: context.width,
              child: DefaultBlankItemMessageScreen(
                image: "no_order_icon",
                title: "empty_previous_orders_message",
                description: "empty_previous_orders_description",
                buttonTitle: "go_back",
                callback: () {
                  Navigator.pop(context);
                },
              ),
            );
          }
          if (activeOrdersProvider.activeOrdersState ==
              ActiveOrdersState.error) {
            return Container(
              alignment: Alignment.center,
              height: context.height,
              width: context.width,
              child: DefaultBlankItemMessageScreen(
                height: context.height,
                image: "something_went_wrong",
                title: getTranslatedValue(
                    context, "something_went_wrong_message_title"),
                description: getTranslatedValue(
                    context, "something_went_wrong_message_description"),
                buttonTitle: getTranslatedValue(context, "try_again"),
                callback: () async {
                  await context.read<ActiveOrdersProvider>().getOrders(
                      params: {ApiAndParams.type: ApiAndParams.previous},
                      context: context);
                },
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
