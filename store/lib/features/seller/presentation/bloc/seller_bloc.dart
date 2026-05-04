import 'package:flutter_bloc/flutter_bloc.dart';
import 'seller_event.dart';
import 'seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  SellerBloc() : super(SellerInitial());
}
