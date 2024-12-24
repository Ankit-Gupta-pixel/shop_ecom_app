import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ecom_app/consts/app_constants.dart';
import 'package:shop_ecom_app/providers/products_provider.dart';
import 'package:shop_ecom_app/sevices/assets_manager.dart';
import 'package:shop_ecom_app/widgets/app_name_text.dart';
import 'package:shop_ecom_app/widgets/title_text.dart';

import '../widgets/products/ctg_rounded_widget.dart';
import '../widgets/products/latest_arrival.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
     final productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      // backgroundColor: AppColors.lightScaffoldColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetsManager.shoppingCart,
          ),
        ),
        title: const AppNameTextWidget(
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15.0,
              ),
              SizedBox(
                height: size.height * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Swiper(
                    autoplay: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        AppConstants.bannersImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: AppConstants.bannersImages.length,
                    pagination: const SwiperPagination(
                      //alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.teal,
                      ),
                    ),
                    //control: const SwiperControl(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
               Visibility(
                visible: productsProvider.getProducts.isNotEmpty,
                child:  const TitlesTextWidget(
                  label: "New Products",
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Visibility(
                  visible: productsProvider.getProducts.isNotEmpty,
                child: SizedBox(
                  height: size.height * 0.2,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productsProvider.getProducts.length < 10
                          ? productsProvider.getProducts.length
                          : 10,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: productsProvider.getProducts[index],
                          child: const LatestArrivalProductsWidget());
                      }),
                ),
              ),
              const TitlesTextWidget(
                label: "Categories",
              ),
              const SizedBox(
                height: 10.0,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children:
                    List.generate(AppConstants.categoriesList.length, (index) {
                  return CategoryRoundedWidget(
                    image: AppConstants.categoriesList[index].image,
                    name: AppConstants.categoriesList[index].name,
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
