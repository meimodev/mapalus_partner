import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';
import 'package:mapalus_partner/app/modules/modules.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Obx(
        () => LoadingWrapper(
          loading: controller.loading.value,
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
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  onDestinationSelected: controller.onPressedNavigationButton,
                  indicatorColor: BaseColor.primary3,
                  selectedIndex: controller.currentPageIndex.value,
                  destinations: const <Widget>[
                    NavigationDestination(
                      icon: Icon(
                        Icons.apps_rounded,
                      ),
                      label: 'Dashboard',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.receipt_rounded),
                      label: 'Orders',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.inventory_2_rounded),
                      label: 'Products',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
