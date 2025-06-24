import 'package:card/app/modules/repot_module/report_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../commom widgets/primary_button.dart';
import '../../utils/appColors.dart';
import '../../utils/appFonts.dart';
import '../../utils/strings.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});
  final ReportController controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          Strings.reason,
          style: AppFonts.rubik.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Obx(() {
        return controller.isLoader.value
            ? const Center(child: CupertinoActivityIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              Strings.whyAreYouReprtngThsCrd,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 5),
            Text(
              Strings.actionImpact,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: controller.reportList.length,
                itemBuilder: (context, index) {
                  final reportItem = controller.reportList[index];
                  final isSelected = controller.selectedIndex.value == index;

                  return ListTile(
                    onTap: () {
                      controller.selectReport(index);
                    },
                    leading: Icon(
                      Icons.flag,
                      color: isSelected ? AppColors.primaryColor : Colors.grey,
                    ),
                    title: Text(
                      reportItem.reason ?? '',
                      style: AppFonts.rubik.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? AppColors.primaryColor : Colors.black,
                      ),
                    ),
                    tileColor: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),


          ],
        );
      }),
      bottomNavigationBar:SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
            child: PrimaryButton(
              textColor: Colors.white,
              height: 52,
              btnColor: AppColors.primaryColor,
              onPressed: () {
                controller.reportApi();
              },
              isLoading: controller.isLoading.value,
              title: "Report",
              borderColor: AppColors.primaryColor,
              hasIcon: false,
            )),
      ),
    );
  }
}
