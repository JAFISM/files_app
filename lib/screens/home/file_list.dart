import 'package:files_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/file_controller.dart';

class ListFile extends StatefulWidget {
  const ListFile({Key? key}) : super(key: key);

  @override
  _ListFileState createState() => _ListFileState();
}

class _ListFileState extends State<ListFile> {
  final FileController _fileController = Get.put(FileController());

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fileController.listOfAllFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          Get.isDarkMode ? Constants.Dblack : Constants.Kbackground,
      appBar: AppBar(
        title: const Text("File Manager"),
        backgroundColor: Constants.Kprimary,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Search here...",
                  prefixIcon: const Icon(CupertinoIcons.search),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Constants.Kprimary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Constants.Kprimary)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.Kprimary),
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                searchQuery = value;
              },
              onTap: () {
                Get.find<FileController>().searchData(searchQuery);
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Get.isDarkMode ? Constants.Dblack : Constants.Kbackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          'Uploaded Folders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          CupertinoIcons.folder_fill,
                          color: Colors.deepPurple,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Config.screenHeight! * 0.01),
                  Expanded(
                    child: Obx(() {
                      final uploadedFolders = _fileController.uploadedFolders;
                      return Container(
                        //color: Colors.red,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: ListView.separated(
                          itemCount: uploadedFolders.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: Config.screenHeight! * 0.01,
                          ),
                          itemBuilder: (context, index) {
                            final folder = uploadedFolders[index];
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Constants.Kprimary.withOpacity(0.1)),
                              child: ListTile(
                                title: Text(folder),
                                leading: const Icon(
                                  CupertinoIcons.folder,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Get.isDarkMode ? Constants.Dblack : Constants.Kbackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Config.screenHeight! * 0.035,
                    //color: Constants.Kbackground,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            "Files",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.file_copy,
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Config.screenHeight! * 0.01,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Config.screenWidth! * 0.03,
                          vertical: Config.screenHeight! * 0.01),
                      child: Obx(() {
                        final uploadedFiles = _fileController.uploadedFiles;
                        if (uploadedFiles.isEmpty) {
                          // Display circular progress indicator while fetching data
                          return const Center(child: Text("No file Found!"));
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: uploadedFiles.length,
                          separatorBuilder: (_, index) =>
                              SizedBox(height: Config.screenHeight! * 0.01),
                          itemBuilder: (context, index) {
                            final fileName = uploadedFiles[index];
                            final fileExtension =
                                fileName.split('.').last.toLowerCase();
                            IconData iconData;
                            switch (fileExtension) {
                              case 'pdf':
                                iconData = Icons.picture_as_pdf;
                                break;
                              case 'doc':
                              case 'docx':
                                iconData = Icons.description;
                                break;
                              case 'jpg':
                              case 'jpeg':
                              case 'png':
                                iconData = Icons.image;
                                break;
                              case 'mp4':
                              case 'mov':
                              case 'avi':
                                iconData = Icons.movie;
                                break;
                              default:
                                iconData = Icons.insert_drive_file;
                            }
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Constants.Kprimary.withOpacity(0.1),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  iconData,
                                  color: Constants.Kprimary,
                                ),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                      color: Constants.Kprimary,
                                      icon:
                                          const Icon(FontAwesomeIcons.download),
                                      onPressed: () {
                                        _fileController.downloadFile(fileName);
                                      },
                                    ),
                                    IconButton(
                                      color: Constants.Kprimary,
                                      icon: const Icon(CupertinoIcons.delete),
                                      onPressed: () {
                                        _fileController.deleteFile(fileName);
                                      },
                                    ),
                                  ],
                                ),
                                title: Text(fileName),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
