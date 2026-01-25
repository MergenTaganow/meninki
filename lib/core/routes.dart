import 'package:flutter/material.dart';
import 'package:meninki/features/adds/pages/add_create_page.dart';
import 'package:meninki/features/auth/pages/login_methods_screen.dart';
import 'package:meninki/features/auth/pages/otp_screen.dart';
import 'package:meninki/features/auth/pages/register_screen.dart';
import 'package:meninki/features/categories/pages/brand_selecting_page.dart';
import 'package:meninki/features/home/pages/settings_page.dart';
import 'package:meninki/features/product/pages/public_product_detail_page.dart';
import 'package:meninki/features/reels/pages/reels_screen.dart';

import '../features/adds/pages/add_detail_page.dart';
import '../features/categories/pages/categories_selecting_page.dart';
import '../features/categories/pages/sub_category_selecting_page.dart';
import '../features/home/pages/favorites_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/home/pages/my_adds_page.dart';
import '../features/product/pages/compositions_page.dart';
import '../features/product/pages/my_product_detail.dart';
import '../features/product/pages/product_create_page.dart';
import '../features/product/pages/product_parametres_page.dart';
import '../features/product/pages/product_search_filter_page.dart';
import '../features/province/pages/province_selecting_page.dart';
import '../features/reels/pages/reel_create_page.dart';
import '../features/reels/pages/reels_filter_page.dart';
import '../features/store/pages/market_banners_page.dart';
import '../features/store/pages/market_color_selecting_page.dart';
import '../features/store/pages/my_store_detail.dart';
import '../features/store/pages/public_store_detail_page.dart';
import '../features/store/pages/store_create_page.dart';

class Routes {
  static final GlobalKey<NavigatorState> mainNavKey = GlobalKey();

  //auth
  static const String loginMethodsScreen = '/login';
  static const String reelScreen = '/reelsScreen';
  static const String otpScreen = '/otpScreen';
  static const String registerScreen = '/registerScreen';

  //home
  static const String homePage = '/homePage';
  static const String favoritesPage = '/favoritesPage';
  static const String settingsPage = '/settingsPage';

  //store
  static const String storeCreatePage = '/storeCreatePage';
  static const String myStoreDetail = '/myStoreDetail';
  static const String publicStoreDetail = '/publicStoreDetail';
  static const String colorSchemeSelectingPage = '/colorSchemeSelectingPage';
  static const String marketBannersPage = '/marketBannersPage';

  //product
  static const String productCreate = '/productCreate';
  static const String categoriesSelectingPage = '/categoriesSelectingPage';
  static const String subCategoriesSelectingPage = '/subCategoriesSelectingPage';
  static const String brandSelectingPage = '/brandSelectingPage';
  static const String publicProductDetailPage = '/publicProductDetailPage';
  static const String myProductDetailPage = '/myProductDetailPage';
  static const String productParametersPage = '/productParametersPage';
  static const String compositionsPage = '/compositionsPage';
  static const String productSearchFilterPage = '/productSearchFilterPage';

  //reals
  static const String reelCreatePage = '/reelCratePage';
  static const String reelsFilterPage = '/reelsFilterPage';

  //province
  static const String provinceSelectingPage = '/provinceSelectingPage';

  //adds
  static const String addCreatePage = '/addCreatePage';
  static const String addDetailPage = '/addDetailPage';
  static const String myAddsPage = '/myAddsPage';

  static Route? onGenerateRoute(RouteSettings settings) {
    final Map? data = settings.arguments as Map?;
    switch (settings.name) {
      case loginMethodsScreen:
        return MaterialPageRoute(builder: (_) => LoginMethodsScreen());
      case reelScreen:
        return MaterialPageRoute(
          builder: (_) => ReelPage(reel: data?['reel'], reels: data?['reels']),
        );
      case otpScreen:
        return MaterialPageRoute(builder: (_) => OtpScreen(data?['phoneNumber']));
      case registerScreen:
        return MaterialPageRoute(builder: (_) => RegisterScreen(data?['temporaryToken']));
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case storeCreatePage:
        return MaterialPageRoute(builder: (_) => StoreCreatePage(market: data?['market']));
      case myStoreDetail:
        return MaterialPageRoute(builder: (_) => MyStoreDetail());
      case productCreate:
        return MaterialPageRoute(
          builder: (_) => ProductCreatePage(storeId: data?["storeId"], product: data?["product"]),
        );
      case categoriesSelectingPage:
        return MaterialPageRoute(
          builder:
              (_) => CategoriesSelectingPage(
                selectionKey: data?['selectionKey'],
                singleSelection: data?['singleSelection'],
                rootCategorySelection: data?['rootCategorySelection'] ?? false,
              ),
        );
      case subCategoriesSelectingPage:
        return MaterialPageRoute(
          builder:
              (_) => SubCategorySelectingPage(
                categories: data?["categories"],
                selectionKey: data?['selectionKey'],
                singleSelection: data?['singleSelection'],
              ),
        );
      case brandSelectingPage:
        return MaterialPageRoute(builder: (_) => BrandSelectingPage());
      case compositionsPage:
        return MaterialPageRoute(builder: (_) => CompositionsPage(data?['product']));
      case publicProductDetailPage:
        return MaterialPageRoute(builder: (_) => PublicProductDetailPage(data?['productId']));
      case myProductDetailPage:
        return MaterialPageRoute(builder: (_) => MyProductDetailPage(data?['productId']));
      case productParametersPage:
        return MaterialPageRoute(builder: (_) => ProductParametresPage(data?['product']));
      case provinceSelectingPage:
        return MaterialPageRoute(
          builder:
              (_) => ProvinceSelectingPage(
                singleSelection: data?['singleSelection'] ?? false,
                selectionKey: data?['selectionKey'],
              ),
        );
      case productSearchFilterPage:
        return MaterialPageRoute(
          builder: (_) => ProductSearchFilterPage(onFilter: data?['onFilter']),
        );
      case reelsFilterPage:
        return MaterialPageRoute(builder: (_) => ReelsFilterPage(onFilter: data?['onFilter']));
      case publicStoreDetail:
        return MaterialPageRoute(
          builder: (_) => PublicStoreDetail(navigatedTab: data?['navigatedTab']),
        );
      case addCreatePage:
        return MaterialPageRoute(builder: (_) => AddCreatePage());
      case myAddsPage:
        return MaterialPageRoute(builder: (_) => MyAddsPage());
      case favoritesPage:
        return MaterialPageRoute(builder: (_) => FavoritesPage());
      case addDetailPage:
        return MaterialPageRoute(builder: (_) => AddDetailPage(data?['add']));
      case reelCreatePage:
        return MaterialPageRoute(
          builder:
              (_) => ReelCreatePage(
                product: data?['product'],
                laterCreateReel: data?['laterCreateReel'],
              ),
        );
      case settingsPage:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case colorSchemeSelectingPage:
        return MaterialPageRoute(builder: (_) => MarketColorSelectingPage(data?['market']));
      case marketBannersPage:
        return MaterialPageRoute(builder: (_) => MarketBannersPage(market: data?['market']));
    }

    return null;
  }
}
