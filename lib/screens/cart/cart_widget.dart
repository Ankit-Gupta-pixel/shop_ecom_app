import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop_ecom_app/models/cart_model.dart';
import 'package:shop_ecom_app/screens/cart/quantity_btm_sheet.dart';
import 'package:shop_ecom_app/widgets/products/heart_btn.dart';
import 'package:shop_ecom_app/widgets/subtitle_text.dart';
import 'package:shop_ecom_app/widgets/title_text.dart';

import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cartModel = Provider.of<CartModel>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productsProvider.findByProdId(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : FittedBox(
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: FancyShimmerImage(
                        imageUrl: getCurrProduct.productImage,
                        height: size.height * 0.2,
                        width: size.height * 0.2,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.6,
                                child: TitlesTextWidget(
                                  label: getCurrProduct.productTitle,
                                  maxLines: 2,
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      cartProvider.removeCartItemFromFirestore(
                                          cartId: cartModel.cartId,
                                          productId: getCurrProduct.productId,
                                          qty: cartModel.quantity,);
                                      // cartProvider.removeOneItem(
                                      //   productId: getCurrProduct.productId,
                                      // );
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.black,
                                    ),
                                  ),
                                  HeartButtonWidget(
                                    productId: getCurrProduct.productId,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubtitleTextWidget(
                                label: "${getCurrProduct.productPrice}₹",
                                color: Colors.brown,
                              ),
                              const Spacer(),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30))),
                                    context: context,
                                    builder: (context) {
                                      return QuantityBottomSheetWidget(
                                        cartModel: cartModel,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(IconlyLight.arrowDown),
                                label: Text("Qnt: ${cartModel.quantity}"),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}