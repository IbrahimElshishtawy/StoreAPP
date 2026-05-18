import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:store/core/network/dio_client.dart';
import 'package:store/core/util/two_factor_auth_service.dart';
import 'package:store/core/util/push_notification_service.dart';
import 'package:store/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:store/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:store/features/auth/domain/repositories/auth_repository.dart';
import 'package:store/features/auth/domain/usecases/auth_usecases.dart';
import 'package:store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:store/features/products/data/datasources/product_remote_data_source.dart';
import 'package:store/features/products/data/repositories/product_repository_impl.dart';
import 'package:store/features/products/domain/repositories/product_repository.dart';
import 'package:store/features/products/domain/usecases/product_usecases.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/seller/data/datasources/seller_remote_data_source.dart';
import 'package:store/features/seller/data/repositories/seller_repository_impl.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';
import 'package:store/features/seller/domain/usecases/seller_usecases.dart';
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
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  // Core
  sl.registerLazySingleton(() => DioClient(sl(), sl()));
  sl.registerLazySingleton(() => TwoFactorAuthService());
  sl.registerLazySingleton(() => PushNotificationService());
  sl.registerFactory(() => ThemeCubit());

  // Features - Auth
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
        twoFactorAuthService: sl(),
      ));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl(), sl()));

  // Features - Products
  sl.registerFactory(() => ProductBloc(
        getProductsUseCase: sl(),
        getProductsByCategoryUseCase: sl(),
      ));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsByCategoryUseCase(sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(sl()));

  // Features - Cart
  sl.registerFactory(() => CartBloc());

  // Features - Seller
  sl.registerFactory(() => SellerBloc(
        getSellerStatsUseCase: sl(),
        addProductUseCase: sl(),
        updateProductUseCase: sl(),
        deleteProductUseCase: sl(),
      ));
  sl.registerLazySingleton(() => GetSellerStatsUseCase(sl()));
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton<SellerRepository>(() => SellerRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<SellerRemoteDataSource>(() => SellerRemoteDataSourceImpl(firestore: sl(), storage: sl()));
}
