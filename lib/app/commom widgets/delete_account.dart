import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  DeleteAccountDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
         /* boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.5),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),*/
      //    ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Delete Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Are you sure you want to permanently delete your account?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 10,),
            Container(height: 1,
                width: double.infinity,
                color: Colors.white,
                ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(height: 50,color: Colors.white,width: 1,),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Get.back(); // Close dialog first
                    onConfirm(); // Then call confirm action
                  },
                  child: Text("Delete",style: TextStyle(color: Colors.redAccent),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
