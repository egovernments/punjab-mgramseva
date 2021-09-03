import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mgramseva/model/file/file_store.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/global_variables.dart';

class FilePickerDemo extends StatefulWidget {
  final Function(List<FileStore>?) callBack;
  final String? moduleName;
  final List<String>? extensions;
  final GlobalKey? contextkey;

  const FilePickerDemo({Key? key, required this.callBack, this.moduleName, this.extensions, this.contextkey}) : super(key: key);
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<PlatformFile> _selectedFiles = <PlatformFile>[];
  List<FileStore> _fileStoreList = <FileStore>[];
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.custom;
  TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      var paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: widget.extensions ?? ((_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null),
      ))
          ?.files;

      if(paths != null){
        if(_multiPick){
          _selectedFiles.addAll(paths);
        }else{
          _selectedFiles = paths;
        }

         List<dynamic> files = paths;
        if(!kIsWeb){
          files = paths.map((e) => File(e.path ?? '')).toList();
        }

      var response = await CoreRepository().uploadFiles(files, widget.moduleName ?? APIConstants.API_MODULE_NAME);
        _fileStoreList.addAll(response);
        if(_selectedFiles.isNotEmpty)
      widget.callBack(_fileStoreList);
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
    });
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? '${ApplicationLocalizations.of(context).translate(i18.common.TEMPORARY_FILES_REMOVED)}'
              : '${ApplicationLocalizations.of(context).translate(i18.common.FALIED_TO_FETCH_TEMPORARY_FILES)}')),
        ),
      );
    });
  }

  void _selectFolder() {
    FilePicker.platform.getDirectoryPath().then((value) {
      setState(() => _directoryPath = value);
    });
  }

  _getConatiner(constraints, context) {
    return [
      Container(
          width: constraints.maxWidth > 760
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 18, bottom: 3),
          child: new Align(
              alignment: Alignment.centerLeft,
              child: Text("${ApplicationLocalizations.of(context).translate(i18.common.ATTACH_BILL)}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                  color: Theme.of(context).primaryColorDark)))),
      Container(
          width: constraints.maxWidth > 760
              ? MediaQuery.of(context).size.width / 2.5
              : MediaQuery.of(context).size.width,
          // height: 50,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 4.0, right: 16.0, top: 4.0 , bottom: 4.0),
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 15)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0XFFD6D5D4)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        )
                        ),
                    onPressed: () => selectDocumentOrImage(),
                    child: Text(
                      "${ApplicationLocalizations.of(context).translate(i18.common.CHOOSE_FILE)}",
                      style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 16),
                    ),
                  )),
            _selectedFiles.isNotEmpty ?
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 3,
                    children : List.generate(_selectedFiles.length, (index) => Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 2,
                      children: [
                        Text(_selectedFiles[index].name),
                        IconButton(
                            padding: EdgeInsets.all(5),
                            onPressed: ()=> onClickOfClear(index), icon: Icon(Icons.cancel))
                      ],
                    )).toList()),
              ),
            )
            : Text(
                "${ApplicationLocalizations.of(context).translate(i18.common.NO_FILE_UPLOADED)}",
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ))
    ];
  }

  void onClickOfClear(int index){
    setState(() {
      _selectedFiles.removeAt(index);
    if(index < _fileStoreList.length)  _fileStoreList.removeAt(index);
    });
    widget.callBack(_fileStoreList);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SingleChildScrollView(
                child: Container(
                  key: widget.contextkey,
                  margin: constraints.maxWidth > 760 ? const EdgeInsets.only(
                      top: 5.0, bottom: 5, right: 10, left: 10) : const EdgeInsets.only(
                      top: 5.0, bottom: 5, right: 0, left: 0),
                  child: constraints.maxWidth > 760
                      ? Row(children: _getConatiner(constraints, context))
                      : Column(children: _getConatiner(constraints, context))
                  ,
                ),
              )));
    });
  }


  Future<void> selectDocumentOrImage() async {
    FocusScope.of(context).unfocus();

    if(kIsWeb){
      _openFileExplorer();
      return ;
    }
    var selectionMode;
      await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context)  {
            return AlertDialog(
                contentPadding: EdgeInsets.all(30.0),
                content: Container(
                  height: 130,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom : 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                                child: Icon(Icons.close),
                                onTap: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 200,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        color: Colors.white,
                        onPressed: () async {
                          Navigator.pop(context);
                          selectionMode = 'camera';
                        },
                        child: Text(
                          "camera",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      MaterialButton(
                        minWidth: 200,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        color: Colors.white,
                        onPressed: () async {
                          selectionMode = 'filePicker';
                          Navigator.pop(context);
                        },
                        child: Text(
                          'File manger',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ));
          });

    if(selectionMode == null) return null;
   imagePath(context, selectionMode: selectionMode);
  }


  Future<void> imagePath(BuildContext context, { required String selectionMode}) async {
    FocusScope.of(context).unfocus();
    try{
      if (selectionMode == 'camera') {
        final pickedFile = await _picker.pickImage(source: ImageSource.camera);
        if(pickedFile != null) {
          final File file = File(pickedFile.path);
          if(file != null) {
            // if (!(await CommonMethods.isValidFileSize(file))) return null;
            // if (isAzureRequired) {
            //   return await getCloudLink(file);
            // } else {
            //   return file.path;
            }
          } else {
            return null;
          }
        } else {
    _openFileExplorer();
    }
    } catch(e){

    }
  }
}
