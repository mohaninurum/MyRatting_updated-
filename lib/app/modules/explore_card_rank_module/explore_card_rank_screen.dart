import 'dart:convert';

import 'package:card/app/utils/appColors.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../response_model/top_rated_response/top_rated_response.dart';
import 'explore_card_rank_controller.dart';
class ExploreCardRankScreen extends StatelessWidget {
  ExploreCardRankScreen({super.key});
  final ExploreCardController controller = Get.put(ExploreCardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Top Ranked Cards",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
        if (controller.isCard.value) {
          return const Center(
            child: CupertinoActivityIndicator(radius: 16,
            color: AppColors.primaryColor,),
          );
        }

        if (controller.topList.isEmpty) {
          return const Center(
            child: Text(
              "No ranked cards found.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.topList.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DottedLine(
                  dashLength: 6,
                  lineThickness: 3,
                  direction: Axis.horizontal,
                  dashColor: AppColors.primaryColor,
                ),
              ),
              itemBuilder: (context, index) {
                final card = controller.topList[index];
                return _buildCard(card, index);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCard(TopData card, int index) {
    final String itemName = card.title ?? 'Unknown';
    const String baseUrl = 'http://myephysician.com/myratingsystem/uploads/icons/';

    String imagePath = '';

    String imageUrl = card.image ?? '';

    if (imageUrl.startsWith(baseUrl) && imageUrl.substring(baseUrl.length).trim().startsWith('[')) {
      try {
        String cleanedImage = imageUrl.substring(baseUrl.length).trim();

        List<dynamic> images = jsonDecode(cleanedImage);
        if (images.isNotEmpty && images[0] is String) {
          imagePath = baseUrl + images[0];
        }

        print('Decoded imagePath: $imagePath');
      } catch (e) {
        imagePath = '';
        print('Error decoding image: $e');
      }
    } else {
      imagePath = imageUrl;
      print('Using direct imagePath: $imagePath');
    }

    final double popularity = (double.tryParse(card.total_score ?? "0.0") ?? 0.0) / 10;
    final int rankNumber = index + 1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.redAccent.shade200,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              rankNumber.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imagePath.isNotEmpty ? imagePath : 'assets/images/monstera-8477880_640.jpg', // Fallback to placeholder image
              height: 80,
              width: 80,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/monstera-8477880_640.jpg', // Your local placeholder image
                  height: 80,
                  width: 80,
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: popularity.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




