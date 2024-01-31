import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezlapen_v2/bloc/app_bloc.dart';
import 'package:tezlapen_v2/l10n/l10n.dart';
import 'package:tezlapen_v2/src/ChangeProduct/change_product_password_screen.dart';
import 'package:tezlapen_v2/src/product_screen.dart';
import 'package:tezlapen_v2/src/stripe/payment_page.dart';
import 'package:vrouter/vrouter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return VRouter(
      mode: VRouterMode.history,
      theme: ThemeData(
        //textTheme: TextTheme(
        //bodySmall: TextStyle(color: Colors.blue),
        // ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 35, 35, 35),
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: [
        VGuard(
          beforeEnter: (vRedirector) async {
            BlocProvider.of<AppBloc>(context).add(NewUserEvent());
          },
          stackedRoutes: [
            VWidget(path: '/', widget: const ProductScreen()),
          ],
        ),
        VGuard(
          stackedRoutes: [
            VWidget(path: '/payment/:sessionId', widget: const PaymentPage()),
          ],
        ),
        VGuard(
          beforeEnter: (vRedirector) async {
            final auth = FirebaseAuth.instance;
            final user = auth.currentUser;

            if (user == null) {
              vRedirector.to('/login');
            }
          },
          stackedRoutes: [
            VWidget(path: '/profile', widget: const ProfileScreen()),
          ],
        ),
        VGuard(
          // beforeEnter: (vRedirector) async {
          //   final auth = FirebaseAuth.instance;
          //   final user = auth.currentUser;

          //   if (user == null) {
          //     vRedirector.to('/login');
          //   }
          // },
          stackedRoutes: [
            VWidget(
              path: '/my-product',
              widget: const ChangeProductPasswordScreen(),
            ),
          ],
        ),
        VGuard(
          beforeEnter: (vRedirector) async {
            final auth = FirebaseAuth.instance;
            final user = auth.currentUser;

            // if (user != null) {
            //   vRedirector.to('/my-product');
            // }
          },
          stackedRoutes: [
            VWidget(
              path: '/login',
              widget: SignInScreen(
                providers: [EmailAuthProvider()],
                actions: [
                  AuthStateChangeAction<SignedIn>((context, state) {
                    context.vRouter.to('/my-product');
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
