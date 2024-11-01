import 'package:app_web/views/sidebarscreens/buyers_screen.dart';
import 'package:app_web/views/sidebarscreens/category_screen.dart';
import 'package:app_web/views/sidebarscreens/orders_screen.dart';
import 'package:app_web/views/sidebarscreens/product_screens.dart';
import 'package:app_web/views/sidebarscreens/upload_banner_screen.dart';
import 'package:app_web/views/sidebarscreens/vendors_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = const VendorsScreen();

  void screenSelector(item) {
    switch (item.route) {
      case BuyersScreen.id:
        setState(() {
          _selectedScreen = const BuyersScreen();
        });
        break;
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = const CategoryScreen();
        });
      case OrdersScreen.id:
        setState(() {
          _selectedScreen = const OrdersScreen();
        });
      case ProductScreens.id:
        setState(() {
          _selectedScreen = const ProductScreens();
        });
      case UploadBannerScreen.id:
        setState(() {
          _selectedScreen = const UploadBannerScreen();
        });
      case VendorsScreen.id:
        setState(() {
          _selectedScreen = const VendorsScreen();
        });
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Management",
          style: TextStyle(
            letterSpacing: 4,
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: _selectedScreen,
      sideBar: SideBar(
        header: Container(
          height: 50,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: const Center(
            child: Text(
              "Multi vendor Admin",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: Colors.black,
          child: const Center(child: Text("Footer",style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.7,
                fontWeight: FontWeight.bold,
              ),)),
        ),
        items: const [
          AdminMenuItem(
              title: "Vendor",
              route: VendorsScreen.id,
              icon: CupertinoIcons.person_3),
          AdminMenuItem(
              title: "Buyers",
              route: BuyersScreen.id,
              icon: CupertinoIcons.person),
          AdminMenuItem(
              title: "Orders",
              route: OrdersScreen.id,
              icon: CupertinoIcons.shopping_cart),
          AdminMenuItem(
              title: "Categories",
              route: CategoryScreen.id,
              icon: Icons.category),
          AdminMenuItem(
              title: "Upload Banners",
              route: UploadBannerScreen.id,
              icon: Icons.upload),
          AdminMenuItem(
              title: "Products", route: ProductScreens.id, icon: Icons.store)
        ],
        onSelected: (item) {
          screenSelector(item);
        },
        selectedRoute: VendorsScreen.id,
      ),
    );
  }
}
