import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:tezlapen_v2/app_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<NewUserEvent>((event, emit) async {
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        final appRepo = AppRepository();

        try {
          final uidExists = await appRepo.doesUIDExistInCollection(
            userCredential.user?.uid ?? 'null value',
          );

          if (uidExists) {
            print(
              'UID exists in the collection. Customer has bought a TezlaPen',
            );
            emit(
              NewUserSignedInState(
                userCredential.user?.uid ?? 'Null value',
                true,
              ),
            );
          } else {
            print('UID does not exist in the collection.');
            emit(
              NewUserSignedInState(
                userCredential.user?.uid ?? 'Null value',
                false,
              ),
            );
          }
        } catch (error) {
          print('Error checking UID existence: $error');
          // Handle the error
        }
      } catch (e) {
        print('Error signing in anonymously: $e');
      }
    });

    on<CheckUserStatus>((event, emit) async {
      if (FirebaseAuth.instance.currentUser == null) {
        return;
      } else {
        final status = await AppRepository()
            .doesUIDExistInCollection(FirebaseAuth.instance.currentUser!.uid);
        status ? emit(AffiliateOn()) : emit(AffiliateOff());
      }
    });
  }
}
