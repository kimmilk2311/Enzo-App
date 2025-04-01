import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final String? leadingIcon;
  final String? trailingIcon;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onTrailingPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.leadingIcon,
    this.trailingIcon,
    this.onLeadingPressed,
    this.onTrailingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      title: Text(
        title,
        style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColors.blackFont),
      ),
      leading: leadingIcon != null
          ? IconButton(
        onPressed: onLeadingPressed,
        icon: SvgPicture.asset(leadingIcon!),
      )
          : null,
      actions: trailingIcon != null
          ? [
        IconButton(
          onPressed: onTrailingPressed,
          icon: SvgPicture.asset(trailingIcon!),
        )
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
