import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/smart_management.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:multi_store/provider/user_provider.dart';
import 'package:multi_store/resource/lang/translate_service.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_theme.dart';
import 'package:multi_store/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app_bindings.dart';
import 'common/constants.dart';

// Ham khoi tao truoc khi chay ung dung
Future<void> main() async {
  await init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const ProviderScope(child: App(initialRoute: PageName.splashPage)));
}

// Ham khoi tao cac cau hinh can thiet
Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
}

// Cai dat HttpOverrides de bo qua chung chi SSL
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..maxConnectionsPerHost = 6
      ..connectionTimeout = const Duration(minutes: 1)
      ..idleTimeout = const Duration(minutes: 1)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}

// Widget goc cua ung dung
class App extends ConsumerWidget {
  final String initialRoute;

  const App({super.key, required this.initialRoute});

  // Kiem tra token va thiet lap nguoi dung neu co
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    String? userJson = preferences.getString('user');

    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    }else{
      ref.read(userProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: _checkTokenAndSetUser(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Hien thi man hinh loading khi dang kiem tra token
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Hien thi ung dung khi da hoan thanh kiem tra token
        return ScreenUtilInit(
          designSize: const Size(411, 823),
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          rebuildFactor: RebuildFactors.orientation,
          fontSizeResolver: FontSizeResolvers.height,
          builder: (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.rightToLeftWithFade,
            getPages: AppPages.routes,
            initialBinding: AppBindings(),
            smartManagement: SmartManagement.keepFactory,
            title: Constants.appName,
            locale: TranslationService.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            fallbackLocale: TranslationService.fallbackLocale,
            translations: TranslationService(),
            initialRoute: initialRoute,
            theme: AppTheme.light,
            darkTheme: AppTheme.light,
          ),
        );
      },
    );
  }
}
