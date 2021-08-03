import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths!.first.extension);
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
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
                      fontSize: 19,
                      color: Colors.black)))),
      Container(
          width: constraints.maxWidth > 760
              ? MediaQuery.of(context).size.width / 2.5
              : MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Color(0XFFD6D5D4)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          )
                          ),
                      onPressed: () => _openFileExplorer(),
                      child: Text(
                        "${ApplicationLocalizations.of(context).translate(i18.common.CHOOSE_FILE)}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    )),
              ),
              Text(
                "${ApplicationLocalizations.of(context).translate(i18.common.NO_FILE_UPLOADED)}",
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 5.0, bottom: 5, right: 10, left: 10),
                  child: constraints.maxWidth > 760
                      ? Row(children: _getConatiner(constraints, context))
                      : Column(children: _getConatiner(constraints, context))
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  //   child: Column(
                  //     children: <Widget>[
                  //       ElevatedButton(
                  //         onPressed: () => _openFileExplorer(),
                  //         child: const Text("Open file picker"),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Builder(
                  //   builder: (BuildContext context) => _loadingPath
                  //       ? Padding(
                  //           padding: const EdgeInsets.only(bottom: 10.0),
                  //           child: const CircularProgressIndicator(),
                  //         )
                  //       : _directoryPath != null
                  //           ? ListTile(
                  //               title: const Text('Directory path'),
                  //               subtitle: Text(_directoryPath!),
                  //             )
                  //           : _paths != null
                  //               ? Container(
                  //                   padding: const EdgeInsets.only(bottom: 30.0),
                  //                   height:
                  //                       MediaQuery.of(context).size.height * 0.50,
                  //                   child: Scrollbar(
                  //                       child: ListView.separated(
                  //                     itemCount:
                  //                         _paths != null && _paths!.isNotEmpty
                  //                             ? _paths!.length
                  //                             : 1,
                  //                     itemBuilder:
                  //                         (BuildContext context, int index) {
                  //                       final bool isMultiPath =
                  //                           _paths != null && _paths!.isNotEmpty;
                  //                       final String name = 'File $index: ' +
                  //                           (isMultiPath
                  //                               ? _paths!
                  //                                   .map((e) => e.name)
                  //                                   .toList()[index]
                  //                               : _fileName ?? '...');
                  //                       final path = _paths!
                  //                           .map((e) => e.path)
                  //                           .toList()[index]
                  //                           .toString();

                  //                       return ListTile(
                  //                         title: Text(
                  //                           name,
                  //                         ),
                  //                         subtitle: Text(path),
                  //                       );
                  //                     },
                  //                     separatorBuilder:
                  //                         (BuildContext context, int index) =>
                  //                             const Divider(),
                  //                   )),
                  //                 )
                  //               : const SizedBox(),
                  // ),
                  ,
                ),
              )));
    });
  }
}
