import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

class ValueStreamBuilder<T> extends StatelessWidget {
  const ValueStreamBuilder({
    Key key,
    @required this.valueStream,
    @required this.builder,
  }) : super(key: key);

  final ValueStream<T> valueStream;
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: valueStream,
      initialData: valueStream.value,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // ignore: only_throw_errors
          throw snapshot.error;
        }
        return builder(context, snapshot.data);
      },
    );
  }
}

class ValueStreamBuilder2<T, U> extends StatelessWidget {
  const ValueStreamBuilder2({
    Key key,
    @required this.valueStream1,
    @required this.valueStream2,
    @required this.builder,
  }) : super(key: key);

  final ValueStream<T> valueStream1;
  final ValueStream<U> valueStream2;
  final Widget Function(BuildContext context, T value1, U value2) builder;

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      valueStream: valueStream1,
      builder: (context, value1) {
        return ValueStreamBuilder(
          valueStream: valueStream2,
          builder: (context, value2) {
            return builder(context, value1, value2);
          },
        );
      },
    );
  }
}

class ValueStreamBuilder3<T, U, V> extends StatelessWidget {
  const ValueStreamBuilder3({
    Key key,
    @required this.valueStream1,
    @required this.valueStream2,
    @required this.valueStream3,
    @required this.builder,
  }) : super(key: key);

  final ValueStream<T> valueStream1;
  final ValueStream<U> valueStream2;
  final ValueStream<V> valueStream3;
  final Widget Function(BuildContext context, T value1, U value2, V value3)
      builder;

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder2(
      valueStream1: valueStream1,
      valueStream2: valueStream2,
      builder: (context, value1, value2) {
        return ValueStreamBuilder(
          valueStream: valueStream3,
          builder: (context, value3) {
            return builder(context, value1, value2, value3);
          },
        );
      },
    );
  }
}
