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

  // @override
  // void dispose() {
  //   searchController.dispose();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  void clearSearch() {
    setState(() {
      searchQuery = '';
      searchController.clear();
    });
    Get.find<FileController>().listOfAllFolders();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GetBuilder<AuthController>(
          builder: (_authController) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Config.screenWidth! * 0.035),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Get.isDarkMode
                                  ? Get.changeTheme(ThemeData.light())
                                  : Get.changeTheme(ThemeData.dark());
                            },
                            icon: Get.isDarkMode
                                ? Icon(Icons.dark_mode)
                                : Icon(Icons.light_mode)),
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
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(CupertinoIcons.search),
                        hintText: "Search here...",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Constants.Kprimary),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Constants.Kprimary),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onChanged: (value) {
                        searchQuery = value;
                      },
                      onTap: () {
                        Get.find<FileController>().searchData(searchQuery);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GetBuilder<FileController>(
                          builder: (controller) => FileButton(
                            onPressed: () {
                              Get.to(SelectWidget());
                            },
                            icon: Icon(Icons.select_all_outlined),
                            label: Text("Select File"),
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
                    Container(
                      child: Obx(() {
                        final uploadedFolders = fileController.uploadedFolders;
                        if (uploadedFolders.isEmpty) {
                          return SizedBox();
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
                                title: Text(folder),
                                onTap: () {},
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
