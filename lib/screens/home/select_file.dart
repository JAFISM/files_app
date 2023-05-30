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
      appBar: AppBar(
        backgroundColor: Constants.Kprimary,
        title: Text("File Preview"),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(ListFile());
              },
              icon: Icon(CupertinoIcons.forward))
        ],
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            style: TextStyle(color: Constants.Kprimary),
                          ),
                          icon: Icon(CupertinoIcons.folder),
                          iconColor: Constants.Kprimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          actions: [
                            TextField(
                              controller: folderController,
                              decoration: InputDecoration(
                                  labelText: "Folder Name",
                                  labelStyle:
                                      TextStyle(color: Constants.Kprimary),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.Kprimary)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.Kprimary)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.Kprimary))),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FileButton(
                                    onPressed: () {
                                      createNewFile();
                                      //_fileController.selectFile();
                                    },
                                    icon:
                                        Icon(CupertinoIcons.folder_badge_plus),
                                    label: Text("Create")),
                                FileButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon:
                                        Icon(Icons.cancel_presentation_rounded),
                                    label: Text("Cancel")),
                              ],
                            ),
                          ],
                        ));
              },
              icon: const Icon(Icons.create_new_folder),
              label: const Text("New Folder"),
            ),
          ],
        ),
      ),
    );
  }

  void createNewFile() {
    final folderName = folderController.text;
    if (folderName.isEmpty || _fileController.pickedFile.value == null) {
      Get.snackbar(
        'Error',
        'Please select a file and enter the folder name.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    _fileController.createNewFile(folderName).then((_) {
      _fileController.readDataFromFirebase();
      Get.snackbar(
        'Success',
        'New folder created successfully.',
        snackPosition: SnackPosition.TOP,
      );
      folderController.clear();
      Get.back();
    });
  }
}