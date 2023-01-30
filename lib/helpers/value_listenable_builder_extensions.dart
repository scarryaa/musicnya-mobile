import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  const ValueListenableBuilder2({
    required this.first,
    required this.second,
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<A>(
        valueListenable: first,
        builder: (_, a, __) {
          return ValueListenableBuilder<B>(
            valueListenable: second,
            builder: (context, b, __) {
              return builder(context, a, b, child);
            },
          );
        },
      );
}

class ValueListenableBuilder3<A, B, C> extends StatelessWidget {
  const ValueListenableBuilder3({
    required this.first,
    required this.second,
    required this.third,
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, C c, Widget? child)
      builder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) => ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (_, b, __) => ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (_, c, __) {
                return builder(context, a, b, c, child);
              })));
}

class ValueListenableBuilder4<A, B, C, D> extends StatelessWidget {
  const ValueListenableBuilder4({
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final ValueListenable<D> fourth;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, C c, D d, Widget? child)
      builder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) => ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (_, b, __) => ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (_, c, __) => ValueListenableBuilder(
                  valueListenable: fourth,
                  builder: (_, d, __) =>
                      builder(context, a, b, c, d, child)))));
}

class ValueListenableBuilder5<A, B, C, D, E> extends StatelessWidget {
  const ValueListenableBuilder5({
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final ValueListenable<D> fourth;
  final ValueListenable<E> fifth;
  final Widget? child;
  final Widget Function(
      BuildContext context, A a, B b, C c, D d, E e, Widget? child) builder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) => ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (_, b, __) => ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (_, c, __) => ValueListenableBuilder(
                  valueListenable: fourth,
                  builder: (_, d, __) => ValueListenableBuilder(
                      valueListenable: fifth,
                      builder: (_, e, __) {
                        return builder(context, a, b, c, d, e, child);
                      })))));
}
