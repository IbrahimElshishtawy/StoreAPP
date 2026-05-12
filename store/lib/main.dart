// ignore_for_file: unused_local_variable
import 'package:flutter/foundation.dart';
import 'package:store/core/seed/seed_fake_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/core/theme/theme_cubit.dart';
import 'package:store/models/customs_userid.dart';
import 'package:store/screen/cart_page_product.dart';
import 'package:store/screen/edit_profile_page.dart';
import 'package:store/screen/home_page.dart';
import 'package:store/screen/login_page.dart';
import 'package:store/screen/my_products_page.dart';
import 'package:store/screen/profile_page.dart';
import 'package:store/screen/rgister_page.dart';
import 'package:store/screen/splash_screen.dart';
import 'package:store/screen/upload_product_page.dart';
import 'package:store/presentation/pages/store_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/injection/injection_container.dart' as di;
import 'package:store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/seller/presentation/bloc/seller_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();

  if (kDebugMode) {
    await FakeUserSeeder.seedUsers();
  }

  runApp(const Store());
}

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider<CartBloc>(create: (_) => di.sl<CartBloc>()),
        BlocProvider<ProductBloc>(create: (_) => di.sl<ProductBloc>()),
        BlocProvider<SellerBloc>(create: (_) => di.sl<SellerBloc>()),
        BlocProvider<ThemeCubit>(create: (_) => di.sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Clinic Store',
            themeMode: themeMode,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            initialRoute: '/clinic_store',
            routes: {
              '/clinic_store': (context) => const StoreView(),
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/home': (context) => const HomePage(),
              '/upload': (context) => const UploadProductPage(),
              '/cart': (context) => const CartPage(),
              '/orders': (context) => const MyProductsPage(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/editProfile') {
                final user = settings.arguments as UserProfile;
                return MaterialPageRoute(
                  builder: (_) => EditProfilePage(user: user),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
