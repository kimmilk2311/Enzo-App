import 'package:admin_panel_app_web/resource/asset/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class CustomSearch extends StatelessWidget {
  const CustomSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle:const TextStyle(color: Colors.grey,fontSize: 16,),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 16),

          prefixIcon: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                AppImages.icSearch,
                width: 10,
                height: 10,
              ),
            ),
            onTap: (){},
          ),
          fillColor: Colors.white70,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
