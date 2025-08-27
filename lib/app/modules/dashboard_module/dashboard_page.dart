import 'dart:async';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../routes/app_pages.dart';
import '../../utils/secure_storage.dart';
import 'dashboard_controller.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  Timer? _reloadTimer;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();

    // // Reload banner ad every 15 seconds
    // _reloadTimer = Timer.periodic(const Duration(seconds: 90), (timer) {
    //   _reloadBannerAd();
    // });
  }

  void _loadBannerAd() {
    const adUnitId = 'ca-app-pub-2993075772757451/4387758911'; // replace with test/real ID

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
          print('✅ Banner ad loaded successfully with ID: $adUnitId');
        },
        onAdFailedToLoad: (ad, error) {
          print('❌ Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
    print('⏳ Loading banner ad with unit ID: $adUnitId');
  }

  void _reloadBannerAd() {
    print("♻️ Reloading banner ad...");
    _bannerAd?.dispose(); // dispose old ad
    setState(() {
      _isLoaded = false;
    });
    _loadBannerAd();
  }

  @override
  void dispose() {
    _reloadTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null) {
      return Container(
        width: double.infinity,
        height: _bannerAd!.size.height.toDouble(),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    // Placeholder until ad is loaded
    return const SizedBox.shrink();
  }
}

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});
  final controller = Get.put(DashboardController());

  Future<bool> _onWillPop() async {
    // Only show dialog if on first tab (index == 0)
    if (controller.currentIndex.value == 0) {
      final shouldExit = await showDialog<bool>(
        context: Get.context!,
        builder: (context) {
          return ExitDialogScreen(isExitDialog: true);
        },
      );
      return shouldExit ?? false;
    } else {
      controller.changeTabIndex(0);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.screens[controller.currentIndex.value]),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BannerAdWidget(),
          Obx(
            () => BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTabIndex,
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: Colors.grey[400],
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedLabelStyle: AppFonts.rubik.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: AppFonts.rubik.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              iconSize: 28,
              items: const [
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/images/apps.png'), size: 32),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/images/add.png'), size: 32),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/images/explore.png'), size: 32),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/images/card.png'), size: 32),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/images/account.png'), size: 32),
                  label: "",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExitDialogScreen extends StatelessWidget {
  // final storage = FlutterSecureStorage();
  final bool isExitDialog; // Add a parameter to determine the dialog type

  ExitDialogScreen({required this.isExitDialog});
  @override
  Widget build(BuildContext context) {
    String message = isExitDialog == true ? "Are you sure want to exit?" : "Are you sure want to log out?";
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(offset: Offset(0, 3), spreadRadius: 0.5, color: AppColors.primaryColor),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 50,
                          child: TextButton(
                            onPressed: () async {
                              logOut(context);
                              Navigator.of(context).pop(true);
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            color: Colors.white,
                            width: 1,
                            height: 42,
                          ),
                        ),
                        Positioned(
                          right: 50,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(
                              "NO",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logOut(BuildContext context) async {
    final deviceToken = await SecureStorage().readSecureData("deviceToken");
    print("Device Token===> $deviceToken");
    await SecureStorage().deleteAllData();

    if (deviceToken != null && deviceToken.isNotEmpty) {
      await SecureStorage().writeSecureData("deviceToken", deviceToken);
    }

    if (isExitDialog) {
      SystemNavigator.pop();
    } else {
      Get.offAllNamed(Routes.CREATE_ACOOUNT);
    }
  }
}
