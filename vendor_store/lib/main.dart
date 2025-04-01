import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_store/provider/vendor_provider.dart';
import 'package:vendor_store/views/screens/authentication/login_page.dart';
import 'package:vendor_store/views/screens/authentication/main_vendor_page.dart';
import 'package:vendor_store/views/screens/authentication/register_page.dart';

void main() {
  runApp( const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    Future<void> checkTokenAndSetUser(WidgetRef ref) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      String? vendorJson = preferences.getString('vendor');

      print("Token từ SharedPreferences: $token");
      print("Vendor JSON từ SharedPreferences: $vendorJson");

      if (token != null && vendorJson != null) {
        ref.read(vendorProvider.notifier).setVendor(vendorJson);
        print("Vendor sau khi thiết lập: ${ref.read(vendorProvider)}");
      } else {
        ref.read(vendorProvider.notifier).signOut();
      }
    }

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(future: checkTokenAndSetUser(ref), builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final vendor = ref.watch(vendorProvider);
        return vendor != null? const MainVendorPage(): const  LoginPage();
      }),
    );
  }
}

