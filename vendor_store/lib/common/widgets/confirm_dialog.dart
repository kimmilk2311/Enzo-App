import 'package:flutter/material.dart';
import '../../../../resource/theme/app_colors.dart';
import '../../resource/theme/app_styles.dart';
import 'app_button.dart';

class ConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String content;

  const ConfirmDialog({
    super.key,
    required this.content,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content,
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Nút Hủy
              AppButton(
                text: "Hủy",
                onPressed: () {
                  if (onCancel != null) {
                    onCancel!();
                  }
                  Navigator.pop(context);
                },
                color: AppColors.greyLight,
                textColor: AppColors.white,
                width: 100,
                height: 40,
                fontSize: 14,
              ),
              // Nút Đồng ý
              AppButton(
                text: "Đồng ý",
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                },
                color: Colors.red,
                textColor: Colors.white,
                width: 100,
                height: 40,
                fontSize: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}