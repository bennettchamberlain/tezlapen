import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezlapen_v2/bloc/app_bloc.dart';
import 'package:tezlapen_v2/bloc/product_bloc.dart';

import 'package:tezlapen_v2/firebase_options.dart';

import 'package:tezlapen_v2/bloc/video%20cubit/video_cubit.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Add cross-flavor configuration here

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (BuildContext context) => AppBloc(),
        ),
        BlocProvider<ProductBloc>(
          create: (BuildContext context) => ProductBloc(),
        ),
        BlocProvider<VideoCubit>(
            create: (BuildContext context) => VideoCubit()),
      ],
      child: await builder(),
    ),
  );
}
