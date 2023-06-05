import 'package:files_app/controller/auth_controller.dart';
import 'package:files_app/screens/home/select_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controller/file_controller.dart';
import 'local_widget/file_button.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FileController fileController =
      Get.put(FileController(), permanent: true);

  String searchQuery = '';
  bool _searchFieldEnabled = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Call the fetchDataOnUserJoin() method when the widget is built and ready
      fileController.fetchDataOnUserJoin();
      fileController.listOfAllFolders();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  // void clearSearch() {
  //   setState(() {
  //     searchQuery = '';
  //     searchController.clear();
  //   });
  //   Get.find<FileController>().listOfAllFolders();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor:
        //     Get.isDarkMode ? Constants.Kblack : Constants.Kbackground,
        body: GetBuilder<AuthController>(
          builder: (_authController) {
            return Container(
              child: Column(
                children: [
                  Container(
                    // color: Get.isDarkMode
                    //     ? Constants.Kblack
                    //     : Constants.Kbackground,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Config.screenWidth! * 0.035),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //SizedBox(height: Config.screenHeight! * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  'Hello ${_authController.displayName.toString().capitalize}!',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Constants.Kprimary),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Get.isDarkMode
                                        ? Get.changeTheme(ThemeData.light())
                                        : Get.changeTheme(ThemeData.dark());
                                  },
                                  icon: Get.isDarkMode
                                      ? const Icon(Icons.dark_mode)
                                      : const Icon(Icons.light_mode)),
                              IconButton(
                                icon: Icon(
                                  Icons.logout_rounded,
                                  color: Constants.Kprimary,
                                ),
                                onPressed: () {
                                  _authController.signout();
                                },
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              _searchFieldEnabled = true;
                            },
                            child: TextField(
                              enabled: !_searchFieldEnabled,
                              controller: searchController,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(CupertinoIcons.search),
                                hintText: "Search here...",
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants.Kprimary),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants.Kprimary),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onChanged: (value) {
                                searchQuery = value;
                              },
                              onTap: () {
                                Get.find<FileController>()
                                    .searchData(searchQuery);
                              },
                            ),
                          ),
                          SizedBox(
                            height: Config.screenHeight! * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GetBuilder<FileController>(
                                builder: (controller) => FileButton(
                                  onPressed: () {
                                    Get.to(SelectWidget());
                                  },
                                  icon: const Icon(Icons.select_all_outlined),
                                  label: const Text("Select File"),
                                ),
                              ),
                              GetBuilder<FileController>(
                                builder: (controller) => FileButton(
                                  onPressed: () {
                                    fileController.listOfAllFolders();
                                    if (controller.uploadedFiles.isEmpty) {
                                      Get.snackbar(
                                          "Refresh", "Add Files in your app");
                                    } else {
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Refresh"),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Config.screenHeight! * 0.01,
                          ),
                          Container(
                            child: const Text(
                              "Important Documents",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: Config.screenHeight! * 0.01,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Config.screenWidth! * 0.035),
                      child: Obx(() {
                        final uploadedFolders = fileController.uploadedFolders;
                        if (uploadedFolders.isEmpty) {
                          return const SizedBox();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: uploadedFolders.length,
                          itemBuilder: (context, index) {
                            final folder = uploadedFolders[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: ListTile(
                                tileColor: Constants.Kprimary.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                leading: const Icon(
                                  CupertinoIcons.folder_fill,
                                  color: Colors.deepPurple,
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    Get.dialog(AlertDialog(
                                      title: const Text("Delete Folder"),
                                      content: const Text(
                                          "Are you sure you want to delete this folder?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              fileController
                                                  .deleteFolder(folder);
                                              Get.back();
                                            },
                                            child: const Text("Delete")),
                                        TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text("Cancel"))
                                      ],
                                    ));
                                  },
                                  child: const Icon(CupertinoIcons.delete),
                                ),
                                title: Text(folder),
                                onTap: () {
                                  fileController.downloadFilesInFolder(folder);
                                },
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
