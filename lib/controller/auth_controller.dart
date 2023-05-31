import 'package:files_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/authentication/root.dart';
import '../screens/home/home.dart';
import 'file_controller.dart';

class AuthController extends GetxController {
  var displayName = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  var googleAcc = Rx<GoogleSignInAccount?>(null);
  var isSignedIn = false.obs;

  User? get userProfile => auth.currentUser;

  static AuthController get to => Get.find();

  @override
  void onInit() {
    if (userProfile != null) {
      displayName = userProfile!.displayName ?? '';
    }

    super.onInit();
  }

  void signUp(String name, String email, String password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        displayName = name;
        auth.currentUser!.updateDisplayName(name);
      });

      update();
      Get.offAll(() => Home());
    } on FirebaseAuthException catch (e) {
      String title = e.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = ('The account already exists for that email.');
      } else {
        message = e.message.toString();
      }

      Get.snackbar(title, message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    } catch (e) {
      Get.snackbar('Error occured!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    }
  }

  void signIn(String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => displayName = userProfile!.displayName!);

      update();
      Get.offAll(() => Home(),
          transition: Transition.fadeIn, duration: Duration.zero);
    } on FirebaseAuthException catch (e) {
      String title = e.code.replaceAll(RegExp('-'), ' ').capitalize!;

      String message = '';

      if (e.code == 'wrong-password') {
        message = 'Invalid Password. Please try again!';
      } else if (e.code == 'user-not-found') {
        message =
            ('The account does not exists for $email. Create your account by signing up.');
      } else {
        message = e.message.toString();
      }

      Get.snackbar(title, message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    } catch (e) {
      Get.snackbar(
        'Error occured!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Constants.Kbackground,
        colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack,
      );
    }
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();

      if (googleAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleAccount.authentication;
        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(googleCredential);
        final User? user = userCredential.user;

        if (user != null) {
          displayName = user.displayName ?? '';
          isSignedIn.value = true;
          String uid = user.uid;

          print("auth token $uid");
          update();
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error occurred!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Constants.Kbackground,
        colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack,
      );
    }
  }

  void resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.back();
    } on FirebaseAuthException catch (e) {
      String title = e.code.replaceAll(RegExp('-'), ' ').capitalize!;

      String message = '';

      if (e.code == 'user-not-found') {
        message =
            ('The account does not exists for $email. Create your account by signing up.');
      } else {
        message = e.message.toString();
      }

      Get.snackbar(title, message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    } catch (e) {
      Get.snackbar('Error occured!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    }
  }

  void signout() async {
    try {
      await auth.signOut();
      await _googleSignIn.signOut();
      displayName = '';
      isSignedIn.value = false;
      update();
      Get.offAll(() => Root());
    } catch (e) {
      Get.snackbar('Error occured!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    }
  }

  void goToFileController() {
    String userId =
        getCurrentUserId(); // Assuming you have a method to retrieve the userId
    Get.to(FileController(), arguments: userId);
  }

  String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }
}

extension StringExtension on String {
  String capitalizeString() {
    if (this.isEmpty) {
      return '';
    }
    return this[0].toUpperCase() + (this.length > 1 ? this.substring(1) : '');
  }
}
