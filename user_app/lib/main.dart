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
import 'package:multi_store/controller/auth_controller.dart';
import 'package:multi_store/provider/user_provider.dart';
import 'package:multi_store/resource/lang/translate_service.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_theme.dart';
import 'package:multi_store/routes/app_routes.dart';
import 'package:multi_store/ui/authentication/login/screen/login_page.dart';
import 'package:multi_store/ui/main/screen/main_page.dart';
import 'package:multi_store/ui/started/screen/started_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app_bindings.dart';
import 'common/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(ProviderScope(child: App(initialRoute: PageName.splashPage)));
}

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

class App extends ConsumerWidget {
  final String initialRoute;

  const App({super.key, required this.initialRoute});

  Future<void> _checkTokenAndSetUser(WidgetRef ref, BuildContext context) async {
    await AuthController().getUserData(context, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        fallbackLocale: TranslationService.fallbackLocale,
        translations: TranslationService(),
        initialRoute: initialRoute,
        theme: AppTheme.light,
        darkTheme: AppTheme.light,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Material(
          child: FutureBuilder(
            future: _checkTokenAndSetUser(ref, context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final user = ref.watch(userProvider);
              return user?.token.isNotEmpty == true ? const MainPage() : const StartedPage();
            },
          ),
        ),
      ),
    );
  }
}
