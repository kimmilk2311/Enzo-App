import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store/provider/vendor_provider.dart';
import 'package:vendor_store/resource/asset/app_images.dart';
import 'package:vendor_store/resource/theme/app_styles.dart';
import 'package:vendor_store/resource/theme/app_colors.dart';

class VendorProfileHeader extends ConsumerWidget {
  const VendorProfileHeader({super.key});

  ImageProvider _buildUserImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage(AppImages.imgDefaultAvatar);
    } else if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(vendorProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Ảnh nền
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.28,
          child: Image.asset(
            AppImages.imgBrProfile,
            fit: BoxFit.cover,
          ),
        ),

        // Icon tin nhắn
        Positioned(
          top: 40,
          right: 20,
          child: SvgPicture.asset(
            AppImages.icMessWhite,
            width: 30,
            height: 30,
          ),
        ),

        // Avatar + Tên + Mô tả
        Positioned(
          top: MediaQuery.of(context).size.height * 0.18,
          left: 0,
          right: 0,
          child: Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: _buildUserImage(user?.storeImage),
              ),
              const SizedBox(height: 10),
              Text(
                user?.fullName ?? 'Tên cửa hàng',
                style: AppStyles.STYLE_20_BOLD.copyWith(color: AppColors.blackFont),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  user?.storeDescription ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyles.STYLE_14.copyWith(color: AppColors.greyDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
