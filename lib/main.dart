import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_ecom_app/consts/theme_data.dart';
import 'package:shop_ecom_app/firebase_options.dart';
import 'package:shop_ecom_app/providers/cart_provider.dart';
import 'package:shop_ecom_app/providers/order_provider.dart';
import 'package:shop_ecom_app/providers/products_provider.dart';
import 'package:shop_ecom_app/providers/theme_provider.dart';
import 'package:shop_ecom_app/providers/user_provider.dart';
import 'package:shop_ecom_app/providers/viewed_recently_provider.dart';
import 'package:shop_ecom_app/providers/wishlist_provider.dart';
import 'package:shop_ecom_app/root_screen.dart';
import 'package:shop_ecom_app/screens/auth/forgot_password.dart';
import 'package:shop_ecom_app/screens/auth/login.dart';
import 'package:shop_ecom_app/screens/auth/register.dart';
import 'package:shop_ecom_app/screens/inner_screens/orders/orders_screen.dart';
import 'package:shop_ecom_app/screens/inner_screens/product_details.dart';
import 'package:shop_ecom_app/screens/inner_screens/viewed_recently.dart';
import 'package:shop_ecom_app/screens/inner_screens/wishlist.dart';
import 'package:shop_ecom_app/screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  static const routeName = '/LoginScreen';
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SelectableText(snapshot.error.toString()),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return ThemeProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ProductsProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return CartProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return WishlistProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ViewedProdProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return UserProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return OrderProvider();
              }),
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Shop Local ',
                theme: Styles.themeData(
                    isDarkTheme: themeProvider.getIsDarkTheme,
                    context: context),
                home: const RootScreen(),
                //home: const LoginScreen(),
                //home: const RegisterScreen(),
                routes: {
                  RootScreen.routName: (context) => const RootScreen(),
                  ProductDetailsScreen.routName: (context) =>
                      const ProductDetailsScreen(),
                  WishlistScreen.routName: (context) => const WishlistScreen(),
                  ViewedRecentlyScreen.routeName: (context) =>
                      const ViewedRecentlyScreen(),
                  RegisterScreen.routeName: (context) => const RegisterScreen(),
                  LoginScreen.routName: (context) => const LoginScreen(),
                  OrdersScreenFree.routName: (context) =>
                      const OrdersScreenFree(),
                  ForgotPasswordScreen.routName: (context) =>
                      const ForgotPasswordScreen(),
                  SearchScreen.routName: (context) => const SearchScreen(),
                },
              );
            }),
          );
        });
  }
}
