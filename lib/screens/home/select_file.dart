import 'package:files_app/constants.dart';
import 'package:files_app/controller/file_controller.dart';
import 'package:files_app/screens/home/file_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'local_widget/file_button.dart';

class SelectWidget extends StatelessWidget {
  // Pass AuthController instance to FileController
  final FileController _fileController = Get.put(FileController());
  final TextEditingController folderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          Get.isDarkMode ? Constants.Dblack : Constants.Kbackground,
      appBar: AppBar(
        backgroundColor: Constants.Kprimary,
        title: const Text("File Preview"),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const ListFile());
              },
              icon: const Icon(CupertinoIcons.forward))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(() {
              final pickedFile = _fileController.pickedFile.value;
              return Container(
                  height: Config.screenHeight! * 0.5,
                  width: double.infinity,
                  color: Constants.Kprimary.withOpacity(0.1),
                  child: Center(
                      child: Text(
                    pickedFile?.name ?? 'No file selected',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )));
            }),
            FileButton(
                width: Config.screenWidth! / 1.5,
                onPressed: () {
                  _fileController.selectFile();
                },
                icon: const Icon(Icons.select_all_outlined),
                label: const Text("Select File from storage")),
            FileButton(
              width: Config.screenWidth! / 1.5,
              onPressed: () {
                _fileController.uploadFile();
              },
              icon: const Icon(Icons.upload_file_outlined),
              label: const Text("Upload"),
            ),
            FileButton(
              width: Config.screenWidth! / 1.5,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                            "New Folder",
                            style: TextStyle(
                                color: Get.isDarkMode
                                    ? Constants.Kbackground
                                    : Constants.Kprimary),
                          ),
                          icon: const Icon(CupertinoIcons.folder),
                          iconColor: Get.isDarkMode
                              ? Constants.Kbackground
                              : Constants.Kprimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          actions: [
                            TextField(
                              controller: folderController,
                              decoration: InputDecoration(
                                  labelText: "Folder Name",
                                  labelStyle: TextStyle(
                                      color: Get.isDarkMode
                                          ? Constants.Kbackground
                                          : Constants.Kprimary),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Get.isDarkMode
                                              ? Constants.Kbackground
                                              : Constants.Kprimary)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Get.isDarkMode
                                              ? Constants.Kbackground
                                              : Constants.Kprimary)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Get.isDarkMode
                                              ? Constants.Kbackground
                                              : Constants.Kprimary))),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FileButton(
                                    onPressed: () {
                                      createNewFile();
                                      //_fileController.selectFile();
                                    },
                                    icon: const Icon(
                                        CupertinoIcons.folder_badge_plus),
                                    label: const Text("Upload")),
                                FileButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(
                                        Icons.cancel_presentation_rounded),
                                    label: const Text("Cancel")),
                              ],
                            ),
                          ],
                        ));
              },
              icon: const Icon(Icons.create_new_folder),
              label: const Text("Create New Folder"),
            ),
          ],
        ),
      ),
    );
  }

  void createNewFile() {
    final folderName = folderController.text;
    if (folderName.isEmpty || _fileController.pickedFile.value == null) {
      Get.snackbar('Error', 'Please select a file and enter the folder name.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
      return;
    }
    _fileController.createNewFile(folderName).then((_) {
      _fileController.readDataFromFirebase();
      Get.snackbar('Success', 'New folder created successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Constants.Kbackground,
          colorText: Get.isDarkMode ? Constants.Kprimary : Constants.Kblack);
      folderController.clear();
      Get.back();
    });
  }
}
