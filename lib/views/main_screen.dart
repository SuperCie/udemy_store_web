import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:store_app_web/views/side_bar_screen.dart/buyers_screen.dart';
import 'package:store_app_web/views/side_bar_screen.dart/categories_screen.dart';
import 'package:store_app_web/views/side_bar_screen.dart/orders_screen.dart';
import 'package:store_app_web/views/side_bar_screen.dart/products_screen.dart';
import 'package:store_app_web/views/side_bar_screen.dart/subcategory_screen.dart';
import 'package:store_app_web/views/side_bar_screen.dart/upbanner_screen.dart';
import 'package:store_app_web/views/side_bar_screen.dart/vendors_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = VendorsScreen();

  screenSelector(item) {
    switch (item.route) {
      case BuyersScreen.routeName:
        setState(() {
          _selectedScreen = BuyersScreen();
        });
        break;
      case VendorsScreen.routeName:
        setState(() {
          _selectedScreen = VendorsScreen();
        });
        break;
      case OrdersScreen.routeName:
        setState(() {
          _selectedScreen = OrdersScreen();
        });
        break;
      case CategoriesScreen.routeName:
        setState(() {
          _selectedScreen = CategoriesScreen();
        });
        break;
      case SubcategoryScreen.routeName:
        setState(() {
          _selectedScreen = SubcategoryScreen();
        });
        break;
      case UpbannerScreen.routeName:
        setState(() {
          _selectedScreen = UpbannerScreen();
        });
        break;
      case ProductsScreen.routeName:
        setState(() {
          _selectedScreen = ProductsScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Management Admin'),
      ),
      body: _selectedScreen,
      sideBar: SideBar(
        items: [
          AdminMenuItem(
            title: 'Suppliers',
            route: VendorsScreen.routeName,
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: 'Buyers',
            route: BuyersScreen.routeName,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: OrdersScreen.routeName,
            icon: CupertinoIcons.shopping_cart,
          ),
          AdminMenuItem(
            title: 'Categories',
            route: CategoriesScreen.routeName,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: 'Subcategory',
            route: SubcategoryScreen.routeName,
            icon: Icons.category_outlined,
          ),
          AdminMenuItem(
            title: 'Upload Banner',
            route: UpbannerScreen.routeName,
            icon: CupertinoIcons.add,
          ),
          AdminMenuItem(
            title: 'Products',
            route: ProductsScreen.routeName,
            icon: CupertinoIcons.list_bullet,
          ),
        ],
        selectedRoute: VendorsScreen.routeName,
        onSelected: (item) {
          screenSelector(item);
        },
      ),
    );
  }
}
