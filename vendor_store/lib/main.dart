import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store/controllers/vendor_auth_controller.dart';
import 'package:vendor_store/provider/vendor_provider.dart';
import 'package:vendor_store/views/screens/authentication/login_page.dart';
import 'package:vendor_store/views/screens/authentication/main_vendor_page.dart';

void main() {
  runApp( const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    Future<void> checkTokenAndSetUser(WidgetRef ref, context) async {
     await VendorAuthController().getUserData(context, ref);
     ref.watch(vendorProvider);
    }




    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Material(
        child: FutureBuilder(future: checkTokenAndSetUser(ref,context), builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final vendor = ref.watch(vendorProvider);
          return vendor!.token.isNotEmpty?const MainVendorPage():const LoginPage();
        }), 
      ),
    );
  }
}