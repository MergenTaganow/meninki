import 'package:flutter/material.dart';
import 'package:meninki/features/auth/pages/login_methods_screen.dart';
import 'package:meninki/features/auth/pages/otp_screen.dart';
import 'package:meninki/features/auth/pages/register_screen.dart';
import 'package:meninki/features/categories/pages/brand_selecting_page.dart';
import 'package:meninki/features/reels/pages/reels_screen.dart';

import '../features/categories/pages/categories_selecting_page.dart';
import '../features/categories/pages/sub_category_selecting_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/product/pages/compositions_page.dart';
import '../features/product/pages/product_create_page.dart';
import '../features/product/pages/product_detail_page.dart';
import '../features/product/pages/product_parametres_page.dart';
import '../features/reels/pages/reel_create_page.dart';
import '../features/store/pages/my_store_detail.dart';
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

  //store
  static const String storeCreatePage = '/storeCreatePage';
  static const String myStoreDetail = '/myStoreDetail';

  //product
  static const String productCreate = '/productCreate';
  static const String categoriesSelectingPage = '/categoriesSelectingPage';
  static const String subCategoriesSelectingPage = '/subCategoriesSelectingPage';
  static const String brandSelectingPage = '/brandSelectingPage';
  static const String productDetailPage = '/productDetailPage';
  static const String productParametersPage = '/productParametersPage';
  static const String compositionsPage = '/compositionsPage';

  //reals
  static const String reelCreatePage = '/reelCratePage';

  static Route? onGenerateRoute(RouteSettings settings) {
    final Map? data = settings.arguments as Map?;
    switch (settings.name) {
      case loginMethodsScreen:
        return MaterialPageRoute(builder: (_) => LoginMethodsScreen());
      case reelScreen:
        return MaterialPageRoute(builder: (_) => ReelPage(reel: data?['reel']));
      case otpScreen:
        return MaterialPageRoute(builder: (_) => OtpScreen(data?['phoneNumber']));
      case registerScreen:
        return MaterialPageRoute(builder: (_) => RegisterScreen(data?['temporaryToken']));
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case storeCreatePage:
        return MaterialPageRoute(builder: (_) => StoreCreatePage());
      case myStoreDetail:
        return MaterialPageRoute(builder: (_) => MyStoreDetail());
      case productCreate:
        return MaterialPageRoute(builder: (_) => ProductCreatePage(data?["storeId"]));
      case categoriesSelectingPage:
        return MaterialPageRoute(builder: (_) => CategoriesSelectingPage());
      case subCategoriesSelectingPage:
        return MaterialPageRoute(builder: (_) => SubCategorySelectingPage(data?["categories"]));
      case brandSelectingPage:
        return MaterialPageRoute(builder: (_) => BrandSelectingPage());
      case compositionsPage:
        return MaterialPageRoute(builder: (_) => CompositionsPage(data?['product']));
      case productDetailPage:
        return MaterialPageRoute(builder: (_) => ProductDetailPage(data?['productId']));
      case productParametersPage:
        return MaterialPageRoute(builder: (_) => ProductParametresPage(data?['product']));
      case reelCreatePage:
        return MaterialPageRoute(builder: (_) => ReelCreatePage(data?['product']));
    }

    return null;
  }
}
