import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop_ecom_app/models/user_model.dart';
import 'package:shop_ecom_app/providers/user_provider.dart';
import 'package:shop_ecom_app/screens/auth/login.dart';
import 'package:shop_ecom_app/screens/inner_screens/orders/orders_screen.dart';
import 'package:shop_ecom_app/screens/inner_screens/viewed_recently.dart';
import 'package:shop_ecom_app/screens/inner_screens/wishlist.dart';
import 'package:shop_ecom_app/screens/loading_manager.dart';
import 'package:shop_ecom_app/sevices/assets_manager.dart';
import 'package:shop_ecom_app/sevices/my_app_functions.dart';
import 'package:shop_ecom_app/widgets/subtitle_text.dart';
import 'package:shop_ecom_app/widgets/title_text.dart';

import '../providers/theme_provider.dart';
//import '../sevices/my_app_functions.dart';
import '../widgets/app_name_text.dart';

class ProfileScreen extends StatefulWidget {
  static const routName = "/ProfileScreen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = true;
  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetsManager.shoppingCart,
          ),
        ),
        title: const AppNameTextWidget(
          fontSize: 24,
        ),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: user == null ? true : false,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TitlesTextWidget(
                      label: "Login To Get Access To Your Profile"),
                ),
              ),
              userModel == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.background,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  userModel!.userImage,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitlesTextWidget(label: userModel!.userName),
                              const SizedBox(
                                height: 2,
                              ),
                              SubtitleTextWidget(
                                label: userModel!.userEmail,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      thickness: 1,
                    ),
                    const TitlesTextWidget(label: "General"),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: userModel == null ? false : true,
                      child: CustomListTile(
                        text: "Orders",
                        imagesPath: AssetsManager.orderSvg,
                        function: () {
                          Navigator.pushNamed(
                            context,
                            OrdersScreenFree.routName,
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: userModel == null ? false : true,
                      child: CustomListTile(
                        text: "Wish List",
                        imagesPath: AssetsManager.wishlistSvg,
                        function: () {
                          Navigator.pushNamed(context, WishlistScreen.routName);
                        },
                      ),
                    ),
                    CustomListTile(
                      text: "Viewed products",
                      imagesPath: AssetsManager.shoppingCart,
                      function: () {
                        Navigator.pushNamed(
                            context, ViewedRecentlyScreen.routeName);
                      },
                    ),
                    CustomListTile(
                      text: "Address",
                      imagesPath: AssetsManager.addressMap,
                      function: () {},
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const TitlesTextWidget(label: "Settings"),
                    const SizedBox(
                      height: 10,
                    ),
                    SwitchListTile(
                      secondary: Image.asset(
                        AssetsManager.theme,
                        height: 40,
                      ),
                      title: Text(themeProvider.getIsDarkTheme
                          ? "Dark Mode"
                          : "Light Mode"),
                      value: themeProvider.getIsDarkTheme,
                      onChanged: (value) {
                        themeProvider.setDarkTheme(themeValue: value);
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      //backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0))),
                  icon: Icon(user == null ? Icons.login : Icons.logout),
                  label: Text(user == null ? "Login" : "Logout"),
                  onPressed: () async {
                    if (user == null) {
                      Navigator.pushNamed(context, LoginScreen.routName);
                    } else {
                      await MyAppFunctions.showErrorOrWarningDialog(
                        context: context,
                        subtitle: "Are you sure you want to signout",
                        fct: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routName);
                        },
                        isError: false,
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagesPath,
    required this.text,
    required this.function,
  });
  final String imagesPath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: SubtitleTextWidget(label: text),
      leading: Image.asset(
        imagesPath,
        height: 39,
      ),
      trailing: const Icon(IconlyLight.arrowRight),
    );
  }
}
