import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart'
    hide Badge;
import 'package:mapalus_partner/app/modules/modules.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller.pageViewController,
              onPageChanged: controller.onPageViewChanged,
              children: const [
                DashboardScreen(),
                OrdersScreen(),
                ProductsScreen(),
              ],
            ),
          ),
          Obx(
            () => NavigationBar(
              onDestinationSelected: controller.onPressedNavigationButton,
              indicatorColor: BaseColor.primary3,
              selectedIndex: controller.currentPageIndex.value,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Badge(
                    child: Icon(Icons.notifications_sharp),
                  ),
                  label: 'Orders',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('2'),
                    child: Icon(Icons.messenger_sharp),
                  ),
                  label: 'Products',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
