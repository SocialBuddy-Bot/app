import 'package:flutter/widgets.dart';

typedef KeyGenerator<T> = Key Function(T arg);

class Keys {
  const Keys._();

  static const rootSplash = ValueKey('root-splash');

  // ignore_for_file: prefer_function_declarations_over_variables
  // static KeyGenerator<Coupon> couponCard = (coupon) {
  //   return ValueKey('coupon-card-${coupon.id}');
  // };

}
