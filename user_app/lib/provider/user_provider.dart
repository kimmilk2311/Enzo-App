import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/user_model.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider()
      : super(
          User(
            id: '',
            fullName: '',
            email: '',
            phone: '',
            image: '',
            address: '',
            token: '',
          ),
        );

  User? get user => state;

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  void signOut() {
    state = null;
  }

  // Ham tao lai nguoi dung
  void recreateUserState({
    required String address,
  }) {
    if (this.state != null) {
      this.state = User(
        id: this.state!.id,
        fullName: this.state!.fullName,
        email: this.state!.email,
        phone: this.state!.phone,
        image: this.state!.image,
        address: address,
        token: this.state!.token,
      );
    }
  }
}

final userProvider = StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());
