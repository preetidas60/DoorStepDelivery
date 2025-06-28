import 'package:project/helper/utils/generalImports.dart';

class CategoryListScreen extends StatefulWidget {
  final ScrollController scrollController;
  final String? categoryName;
  final String? categoryId;

  const CategoryListScreen(
      {Key? key,
        required this.scrollController,
        this.categoryName,
        this.categoryId})
      : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    if(scrollController.position.maxScrollExtent == scrollController.offset){
      if (mounted) {
        if (context.read<CategoryListProvider>().hasMoreData) {
          callApi(false);
        }
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await callApi(true);
    });
  }

  callApi(bool isReset) {
    if (isReset == true) {
      context.read<CategoryListProvider>().offset = 0;
      context.read<CategoryListProvider>().categories.clear();
    }
    return context
        .read<CategoryListProvider>()
        .getCategoryApiProvider(context: context, params: {
      ApiAndParams.categoryId:
      widget.categoryId == null ? "0" : widget.categoryId.toString()
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        centerTitle: true,
        title: CustomTextLabel(
          text: widget.categoryName == null
              ? getTranslatedValue(context, "categories")
              : widget.categoryName.toString(),
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        actions: [
          setNotificationIcon(context: context),
        ],
        showBackButton: false,
      ),
      body: setRefreshIndicator(
        refreshCallback: () async {
          context.read<CartListProvider>().getAllCartItems(context: context);
          await callApi(true);
        },
        child: Column(
          children: [
            getSearchWidget(context: context),
            Expanded(
              child: Container(
                margin: EdgeInsetsDirectional.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10)),
                child: ListView(
                  controller: scrollController,
                  children: [
                    categoryWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modified categoryList ui with rectangular containers in 3-column grid
  Widget categoryWidget() {
    return Consumer<CategoryListProvider>(
      builder: (context, categoryListProvider, _) {
        if (categoryListProvider.categoryState == CategoryState.loaded ||
            categoryListProvider.categoryState == CategoryState.loadingMore) {
          return GridView.builder(
            itemCount: categoryListProvider.categories.length,
            padding: EdgeInsets.symmetric(
                horizontal: Constant.size10, vertical: Constant.size10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              CategoryItem category = categoryListProvider.categories[index];

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    if (category.hasChild!) {
                      Navigator.pushNamed(context, categoryListScreen,
                          arguments: [
                            ScrollController(),
                            category.name,
                            category.id.toString()
                          ]);
                    } else {
                      Navigator.pushNamed(context, productListScreen, arguments: [
                        "category",
                        category.id.toString(),
                        category.name
                      ]);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(3, 0, 3, 5),
                    child: Column(
                      children: [
                        // Category Image
                        Expanded(
                          flex: 5,
                          child: category.imageUrl != null && category.imageUrl!.isNotEmpty
                              ? Image.network(
                            category.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.category,
                                size: 50,
                                color: Colors.grey,
                              );
                            },
                          )
                              : Icon(
                            Icons.category,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 0),
                        // Category Name - Centered vertically
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              category.name ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w200,
                                color: ColorsRes.mainTextColor,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.7,
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 10),
          );
        } else if (categoryListProvider.categoryState == CategoryState.loading) {
          return getCategoryShimmer(context: context, count: 9);
        } else {
          return NoInternetConnectionScreen(
            height: context.height * 0.5,
            message: categoryListProvider.message,
            callback: () {
              callApi(true);
            },
          );
        }
      },
    );
  }
}