import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:files_app/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'auth_controller.dart';

class FileController extends GetxController {
  final storage = FirebaseStorage.instance;

  Rx<PlatformFile?> pickedFile = Rx<PlatformFile?>(null);
  final RxList<String> uploadedFiles = <String>[].obs;
  RxList<String> uploadedFolders = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Call the method to fetch and update the uploaded files initially
    readDataFromFirebase();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    pickedFile.value = result.files.first;
  }

  void fetchDataOnUserJoin() {
    // Call the method to read data from Firebase
    readDataFromFirebase();
  }

  void listOfAllFolders() async {
    final storageRef =
        FirebaseStorage.instance.ref().child("files/${getCurrentUserId()}");
    final listResult = await storageRef.listAll();
    final List<String> folders = [];

    for (var prefix in listResult.prefixes) {
      final folderName = prefix.name;
      folders.add(folderName);
    }

    uploadedFolders.assignAll(folders);
  }

  Future uploadFile() async {
    if (pickedFile.value == null) {
      Get.snackbar('Failed', 'Please select file',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
      return;
    }
    final userId = getCurrentUserId();
    final path = 'files/$userId/${pickedFile.value!.name}';
    final file = File(pickedFile.value!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() {
      // Update the uploadedFiles list after successful upload
      readDataFromFirebase();
      Get.snackbar('File Uploaded', 'The file was successfully uploaded.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    }).catchError((error) {
      Get.snackbar(
        'Error',
        'An error occurred while uploading the file.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Constants.Kbackground,
        colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack,
      );
    });
  }

  void readDataFromFirebase() async {
    uploadedFiles.clear();
    uploadedFolders.clear();

    final userId = getCurrentUserId();
    final ref = storage.ref().child('files/$userId');
    final ListResult result = await ref.listAll();
    final List<String> files = [];
    final List<String> folders = [];

    for (final item in result.items) {
      final itemName = item.name;
      if (itemName.endsWith('/')) {
        // Treat the item as a folder
        final folderName = itemName.substring(0, itemName.length - 1);
        folders.add(folderName);
      } else {
        // Treat the item as a file
        files.add(itemName);
      }
    }

    // Move the user-created folder to the beginning of the list
    if (pickedFile.value != null && pickedFile.value!.name.endsWith('/')) {
      final folderName = pickedFile.value!.name
          .substring(0, pickedFile.value!.name.length - 1);
      if (folders.contains(folderName)) {
        folders.remove(folderName);
        folders.insert(0, folderName);
        print(folderName);
      }
    }

    uploadedFiles.assignAll(files);
    uploadedFolders.assignAll(folders);
  }

  Future<void> downloadFile(String fileName) async {
    final userId = getCurrentUserId();
    final filePath = 'files/$userId/$fileName';
    final ref = storage.ref().child(filePath);
    final url = await ref.getDownloadURL();
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/$fileName';
    await Dio().download(url, path);

    try {
      if (url.contains(".mp4")) {
        await GallerySaver.saveVideo(path, toDcim: true);
      } else if (url.contains(".jpg") || url.contains(".png")) {
        await GallerySaver.saveImage(path, toDcim: true);
      }
      //await ref.writeToFile(File(localFilePath));
      Get.snackbar(
          'File Downloaded', 'The file was successfully downloaded to Gallery.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          // duration: Duration(seconds: 15),
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while downloading the file.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    }
  }

  Future<void> downloadFolder(String folderName) async {
    final userId = getCurrentUserId();
    final folderPath = 'files/$userId/$folderName';
    final ref = storage.ref().child(folderPath);
    final appSupportDir = await getTemporaryDirectory();
    final localFolderPath = '${appSupportDir.path}/Downloads/$folderName';

    try {
      final ListResult listResult = await ref.listAll();

      // Recreate the folder structure locally
      Directory(localFolderPath).createSync(recursive: true);

      // Download each file within the folder individually
      for (final item in listResult.items) {
        final itemName = item.name;
        final localFilePath = '$localFolderPath/$itemName';
        final file = File(localFilePath);

        final downloadTask = item.writeToFile(file);
        await downloadTask;
      }

      Get.snackbar('Folder Downloaded',
          'The folder was successfully downloaded. Path: $localFolderPath',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while downloading the folder.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    }
  }

  // Future<void> downloadFolder(String folderName) async {
  //   final userId = getCurrentUserId();
  //   final folderPath = 'files/$userId/$folderName';
  //   final ref = storage.ref().child(folderPath);
  //   final appSupportDir = await getTemporaryDirectory();
  //   final localFolderPath = '${appSupportDir.path}/Downloads/$folderName';
  //
  //   try {
  //     final ListResult listResult = await ref.listAll();
  //
  //     // Recreate the folder structure locally
  //     Directory(localFolderPath).createSync(recursive: true);
  //
  //     // Download each file within the folder individually
  //     for (final item in listResult.items) {
  //       final itemName = item.name;
  //       final localFilePath = '$localFolderPath/$itemName';
  //       final file = File(localFilePath);
  //
  //       final downloadTask = item.writeToFile(file);
  //       await downloadTask;
  //     }
  //
  //     // Open the downloaded folder using the open_file package
  //     OpenFile.open(localFolderPath);
  //
  //     Get.snackbar('Folder Downloaded',
  //         'The folder was successfully downloaded. Path: $localFolderPath',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Constants.Kbackground,
  //         colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
  //   } catch (e) {
  //     Get.snackbar('Error', 'An error occurred while downloading the folder.',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Constants.Kbackground,
  //         colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
  //   }
  // }
  //
  String getCurrentUserId() {
    return Get.find<AuthController>().getCurrentUserId();
  }

  bool isUploading = false;

  Future<void> createNewFile(String folderName) async {
    if (folderName.isEmpty || pickedFile.value == null) {
      Get.snackbar('Error', 'Please select a file and enter the folder name.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
      return;
    }

    final userId = getCurrentUserId();
    final folderPath = 'files/$userId/$folderName';
    final filePath = '$folderPath/${pickedFile.value!.name}';
    final ref = storage.ref().child(filePath);
    final file = File(pickedFile.value!.path!);

    try {
      // Upload the file to the folder in Firebase Storage
      await ref.putFile(file);

      Get.snackbar(
          'File Uploaded', 'The file was successfully uploaded to the folder.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);

      // Refresh the file list
      readDataFromFirebase();
      // Add the new folder to the uploadedFiles list
      uploadedFiles.add(folderName);
    } catch (e) {
      Get.snackbar(
          'Error', 'An error occurred while uploading the file to the folder.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    }
  }

  void searchData(String query) {
    final List<String> filteredFiles = uploadedFiles
        .where((file) => file.toLowerCase().contains(query.toLowerCase()))
        .toList();

    final List<String> filteredFolders = uploadedFolders
        .where((folder) => folder.toLowerCase().contains(query.toLowerCase()))
        .toList();

    uploadedFiles.assignAll(filteredFiles);
    uploadedFolders.assignAll(filteredFolders);
  }

  Future<void> deleteFile(String fileName) async {
    final userId = getCurrentUserId();
    final filePath = 'files/$userId/$fileName';
    final ref = storage.ref().child(filePath);

    try {
      await ref.delete();

      // Update the uploadedFiles list after successful deletion
      readDataFromFirebase();
      Get.snackbar('File Deleted', 'The file was successfully deleted.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting the file.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    }
  }

  Future<void> deleteFolder(String folderName) async {
    final userId = getCurrentUserId();
    final folderPath = 'files/$userId/$folderName';
    final ref = storage.ref().child(folderPath);

    try {
      // Get a list of all items (files and subfolders) within the folder
      final ListResult listResult = await ref.listAll();

      // Delete each item within the folder recursively
      for (final item in listResult.items) {
        await item.delete();
      }

      // Update the uploadedFolders list after successful deletion
      listOfAllFolders();
      Get.snackbar('Folder Deleted', 'The folder was successfully deleted.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting the folder.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
    }
  }
}
