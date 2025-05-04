import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_store/controllers/vendor_auth_controller.dart';
import 'package:vendor_store/provider/vendor_provider.dart';

import '../../../common/widgets/confirm_dialog.dart';
import '../../../resource/asset/app_images.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_styles.dart';
import '../../../services/manage_http_response.dart';

class VendorProfilePage extends ConsumerStatefulWidget {
  const VendorProfilePage({super.key});

  @override
  ConsumerState<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends ConsumerState<VendorProfilePage> {
  final VendorAuthController _vendorAuthController = VendorAuthController();
  final ImagePicker picker = ImagePicker();

  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageNotifier.value = File(pickedFile.path);
    } else {
      showSnackBar(context, "Không lấy được ảnh");
    }
  }

  void showEditProfileDialog(BuildContext context) {
    final user = ref.read(vendorProvider);
    final TextEditingController _storeDescriptionController = TextEditingController();

    _storeDescriptionController.text =  user?.storeDescription?? "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              "Sủa thông tin",
              style: AppStyles.STYLE_20_BOLD.copyWith(color: AppColors.blackFont),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                    valueListenable: imageNotifier,
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: value != null
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage: FileImage(value),
                              )
                            : const CircleAvatar(
                                radius: 40,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    CupertinoIcons.photo,
                                    size: 30,
                                  ),
                                ),
                              ),
                      );
                    }),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Mô tả cửa hàng",
                    border: OutlineInputBorder(),
                  ),
                  controller: _storeDescriptionController,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Hủy",
                  style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.greyDark),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _vendorAuthController.updateVendorData(
                    context: context,
                    id: ref.read(vendorProvider)!.id,
                    ref: ref,
                    storeImage: imageNotifier.value,
                    storeDescription: _storeDescriptionController.text,
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Lưu",
                  style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ],
          );
        });
  }

  ImageProvider _buildUserImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return AssetImage(AppImages.imgDefaultAvatar);
    } else if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return FileImage(file);
      } else {
        return AssetImage(AppImages.imgDefaultAvatar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(vendorProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 350,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      AppImages.imgBrProfile,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 30,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        AppImages.icMessWhite,
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 140,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: _buildUserImage(user!.storeImage),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              showEditProfileDialog(context);
                            },
                            child: SvgPicture.asset(
                              AppImages.icEdit,
                              width: 30,
                              height: 30,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.art_track_rounded),
              title: Text(
                "Theo dõi đơn hàng",
                style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
              ),
            ),
            const SizedBox(height: 5),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.history),
              title: Text(
                "Lịch sử mua hàng",
                style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
              ),
            ),
            const SizedBox(height: 5),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.help_outline),
              title: Text(
                "Trợ giúp",
                style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
              ),
            ),
            const SizedBox(height: 5),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    content: "Bạn có chắc chắn muốn đăng xuất không?",
                    onConfirm: () async {
                      _vendorAuthController.signOutVendor(context: context);
                    },
                    onCancel: () {},
                  ),
                );
              },
              leading: const Icon(Icons.logout),
              title: Text(
                "Đăng xuất",
                style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
              ),
            ),
            const SizedBox(height: 5),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    content: "Bạn có chắc chắn muốn xóa tài khoản không?",
                    onConfirm: () async {},
                    onCancel: () {},
                  ),
                );
              },
              leading: const Icon(Icons.delete),
              title: Text(
                "Xóa tài khoản",
                style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
