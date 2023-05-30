import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
      Get.snackbar(
        'File Uploaded',
        'The file was successfully uploaded.',
        snackPosition: SnackPosition.TOP,
      );
    }).catchError((error) {
      Get.snackbar(
        'Error',
        'An error occurred while uploading the file.',
        snackPosition: SnackPosition.TOP,
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
    final ref = storage.ref().child('files/$fileName');
    final downloadData = await ref.getData();

    if (downloadData != null) {
      final directory = await FilePicker.platform.getDirectoryPath();
      final filePath = '$directory/$fileName';
      final file = File(filePath);

      await file.writeAsBytes(downloadData);

      Get.snackbar(
        'File Downloaded',
        'The file was successfully downloaded.',
        snackPosition: SnackPosition.TOP,
      );

      // Open the downloaded file
      await openFile(file.path);
    } else {
      Get.snackbar(
        'Error',
        'An error occurred while downloading the file.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> openFile(String filePath) async {
    if (await canLaunchUrl(filePath as Uri)) {
      await launchUrl(filePath as Uri);
    } else {
      Get.snackbar(
        'Error',
        'Could not open the file.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  String getCurrentUserId() {
    return Get.find<AuthController>().getCurrentUserId();
  }

  bool isUploading = false;

  Future<void> createNewFile(String folderName) async {
    if (folderName.isEmpty || pickedFile.value == null) {
      Get.snackbar(
        'Error',
        'Please select a file and enter the folder name.',
        snackPosition: SnackPosition.TOP,
      );
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
        'File Uploaded',
        'The file was successfully uploaded to the folder.',
        snackPosition: SnackPosition.TOP,
      );

      // Refresh the file list
      readDataFromFirebase();
      // Add the new folder to the uploadedFiles list
      uploadedFiles.add(folderName);
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while uploading the file to the folder.',
        snackPosition: SnackPosition.TOP,
      );
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
}
