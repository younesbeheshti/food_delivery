import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/data/repository/popular_product_repo.dart';
import 'package:food_delivery/models/cart_model.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';

class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo;

  PopularProductController({required this.popularProductRepo});

  List<dynamic> _popularProductList = [];

  List<dynamic> get popularProductList => _popularProductList;

  late CartController _cart;

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  int _quantity = 0;

  int get quantity => _quantity;

  int _inCardItems = 0;

  int get inCardItems => _inCardItems + _quantity;

  Future<void> getPopularProductList() async {
    Response response = await popularProductRepo.getPopularProductList();
    print('Status code : ${response.statusCode}');
    if (response.statusCode == 200) {
      _popularProductList = [];
      _popularProductList.addAll(Product.fromJson(response.body).products!);
      print(_popularProductList);
      _isLoaded = true;
      update();
    } else {
      print('nothing to show');
    }
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
    } else {
      _quantity = checkQuantity(_quantity - 1);
      print('decrement : ' + _quantity.toString());
    }
    update();
  }

  int checkQuantity(int quantity) {
    if (inCardItems + quantity < 0) {
      Get.snackbar(
        "Item count",
        "You can't reduce more!",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      if(_inCardItems > 0) {
        _quantity = -_inCardItems;
        return _quantity;
      }
      return 0;
    } else if (_inCardItems + quantity > 20) {
      Get.snackbar(
        "Item count",
        "You can't add more!",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct(ProductModel product,CartController cart) {
    _quantity = 0;
    _inCardItems = 0;
    _cart = cart;
    bool exist = false;
    exist = _cart.existInCart(product);
    print('exist or not ' + exist.toString());
    if(exist) {
      _inCardItems = _cart.getQuantity(product);
    }
    print('the quantity in the  cart is ' + _inCardItems.toString());
  }

  void addItems(ProductModel product) {
    // if (_quantity > 0) {
      _cart.addItem(product, _quantity);
      _quantity = 0;
      _inCardItems = _cart.getQuantity(product);
      _cart.items.forEach((key, value) {
        print('the id is ' + value.id.toString() + ' the quantity is ' + value.quantity.toString());
      });

      update();
    // }
  }

  int get totalItems {
    return _cart.totalItems;
  }

  List<CartModel> get getItems{
    return _cart.getItems;
  }

}
