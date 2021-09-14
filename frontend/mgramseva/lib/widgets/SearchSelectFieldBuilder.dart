import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class SearchSelectField extends StatefulWidget {
  final String labelText;
  final List<DropdownMenuItem<Object>> options;
  final dynamic value;
  final Function(dynamic) widget;
  final bool? isEnabled;
  final bool isRequired;
  final String? requiredMessage;
  final TextEditingController? controller;
  SearchSelectField(this.labelText, this.options, this.controller, this.widget,
      this.value, this.isEnabled, this.isRequired, this.requiredMessage);
  @override
  _SearchSelectFieldState createState() => _SearchSelectFieldState();
}

class _SearchSelectFieldState extends State<SearchSelectField> {
  final FocusNode _focusNode = FocusNode();
  bool isinit = false;
  // ignore: non_constant_identifier_names
  List<DropdownMenuItem<Object>> Options = [];
  late OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context)!.insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
      }
    });
    super.initState();
    filerobjects("");
  }

  afterViewBuild() {
    widget.controller?.text =
        ApplicationLocalizations.of(context).translate(widget.value);
  }

  filerobjects(val) {
    if (val != "") {
      setState(() {
        isinit = true;
        Options = widget.options
            .where((element) => element.value
                .toString()
                .toLowerCase()
                .contains(val.toString().toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        Options = widget.options;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    var size = renderBox!.size;

    return OverlayEntry(
        builder: (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: this._layerLink,
              showWhenUnlinked: true,
              offset: Offset(0.0, size.height + 5.0),
              child: Material(
                elevation: 4.0,
                child: Container(
                  height: widget.options.length * 50 < 200
                      ? widget.options.length * 50
                      : 200,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: <Widget>[
                      for (var item in Options.length == 0 && isinit == false
                          ? widget.options
                          : Options)
                        Ink(
                            color: Colors.white,
                            child: ListTile(
                              title: item.child,
                              onTap: () {
                                Text txt = item.child as Text;
                                widget.widget(item.value);
                                widget.controller?.text = (txt.data.toString());
                                _focusNode.unfocus();
                              },
                            )),
                    ],
                  ),
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: TextFormField(
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: (widget.isEnabled ?? true)
                ? Theme.of(context).primaryColorDark
                : Colors.grey),
        controller: widget.controller,
        onChanged: (value) => filerobjects(value),
        focusNode: this._focusNode,
        validator: (value) {
          if (widget.options
              .where((element) =>
                  element.value.toString().toLowerCase() ==
                  (value.toString().toLowerCase()))
              .toList()
              .isEmpty) {
            return ApplicationLocalizations.of(context).translate(
                widget.requiredMessage ?? '${widget.labelText}_REQUIRED');
          }
          if (value!.trim().isEmpty && widget.isRequired) {
            return ApplicationLocalizations.of(context).translate(
                widget.requiredMessage ?? '${widget.labelText}_REQUIRED');
          }
          return null;
        },
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.arrow_drop_down),
          errorMaxLines: 2,
          enabled: widget.isEnabled ?? true,
          fillColor: widget.isEnabled != null && widget.isEnabled!
              ? Colors.grey
              : Colors.white,
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }
}
