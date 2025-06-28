import 'package:project/helper/utils/generalImports.dart';

class HomeMainScreenProvider extends ChangeNotifier {
  int currentPage = 0;

  List<ScrollController> scrollController = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController()
  ];

  //total pageListing
  List<Widget> pages = [];

  setPages() {
    pages = [
      ChangeNotifierProvider<ProductListProvider>(
        create: (context) {
          return ProductListProvider();
        },
        child: HomeScreen(
          scrollController: scrollController[0],
        ),
      ),
      CategoryListScreen(
        scrollController: scrollController[1],
      ),
      WishListScreen(
        scrollController: scrollController[2],
      ),
      ProfileScreen(
        scrollController: scrollController[3],
      )
    ];
  }

  //change current screen based on bottom menu selection
  Future selectBottomMenu(int index) async {
    try {
      if (index == currentPage && scrollController[currentPage].offset > 0) {
        // Change this to a quick jump instead of animation
        scrollController[currentPage].jumpTo(0); // ← Instant jump (no animation)
      }
      currentPage = index;
    } catch (_) {}
    notifyListeners();
  }


  getCurrentPage() {
    return currentPage;
  }

  getPages() {
    return pages;
  }
}
