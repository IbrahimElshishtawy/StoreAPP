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
import 'package:store/features/seller/domain/repositories/seller_repository.dart';
import 'package:store/features/seller/data/repositories/seller_repository_impl.dart';
import 'package:store/features/seller/data/datasources/seller_remote_data_source.dart';
import 'package:store/features/seller/domain/usecases/get_seller_stats.dart';
import 'package:store/features/seller/domain/usecases/upload_product.dart';
import 'package:store/features/seller/domain/usecases/create_ad.dart';
import 'package:store/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:store/features/payment/domain/repositories/payment_repository.dart';
import 'package:store/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:store/features/payment/data/datasources/stripe_service.dart';
import 'package:store/features/payment/data/datasources/paypal_service.dart';
import 'package:store/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:store/features/chat/domain/repositories/chat_repository.dart';
import 'package:store/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:store/features/chat/data/datasources/chat_remote_data_source.dart';

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
  sl.registerFactory(() => SellerBloc(
    getSellerStats: sl(),
    uploadProduct: sl(),
    createAd: sl(),
  ));
  sl.registerLazySingleton(() => GetSellerStats(sl()));
  sl.registerLazySingleton(() => UploadProduct(sl()));
  sl.registerLazySingleton(() => CreateAd(sl()));
  sl.registerLazySingleton<SellerRepository>(() => SellerRepositoryImpl(sl()));
  sl.registerLazySingleton<SellerRemoteDataSource>(() => SellerRemoteDataSourceImpl(sl()));

  // Features - Payment
  sl.registerFactory(() => PaymentBloc(sl()));
  sl.registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => StripeService());
  sl.registerLazySingleton(() => PayPalService());

  // Features - Chat
  sl.registerFactory(() => ChatBloc(sl()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(sl(), sl()));
}
