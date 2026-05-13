import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/core/network/dio_client.dart';
import 'package:store/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:store/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:store/features/auth/domain/repositories/auth_repository.dart';
import 'package:store/features/auth/domain/usecases/auth_usecases.dart';
import 'package:store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:store/features/products/data/datasources/product_remote_data_source.dart';
import 'package:store/features/products/data/repositories/product_repository_impl.dart';
import 'package:store/features/products/domain/repositories/product_repository.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/seller/presentation/bloc/seller_bloc.dart';
import 'package:store/core/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Core
  sl.registerLazySingleton(() => DioClient(sl(), sl()));

  // Features - Auth
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl(), sl(), sl()));

  // Features - Products
  sl.registerFactory(() => ProductBloc(sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(sl()));

  // Features - Cart
  sl.registerFactory(() => CartBloc());

  // Features - Seller
  sl.registerFactory(() => SellerBloc());

  // Core - Theme
  sl.registerFactory(() => ThemeCubit());
}
