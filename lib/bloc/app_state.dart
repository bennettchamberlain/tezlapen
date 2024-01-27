part of 'app_bloc.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class NewUserSignedInState extends AppState {

  NewUserSignedInState(this.userID, this.affiliateLinksOn);
  final String userID;
  bool affiliateLinksOn = false;
}
