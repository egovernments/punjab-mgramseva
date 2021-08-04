import 'package:flutter/material.dart';

class SimpleAccountMenu extends StatefulWidget {
  final List input;

  final Color backgroundColor;
  final Color iconColor;
  final ValueChanged<int> onChange;

  const SimpleAccountMenu({
    Key? key,
    required this.input,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    required this.onChange,
  })  : assert(input != null),
        super(key: key);
  @override
  _SimpleAccountMenuState createState() => _SimpleAccountMenuState();
}

class _SimpleAccountMenuState extends State<SimpleAccountMenu>
    with SingleTickerProviderStateMixin {
  late GlobalKey _key;
  bool isMenuOpen = false;
  late Offset buttonPosition;
  late Size buttonSize;
  late OverlayEntry _overlayEntry;

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  findButton() {
    // RenderBox renderBox = _key.currentContext.findRenderObject();
    // buttonSize = (500) as Size;
    buttonPosition = Offset(0, 30);
  }

  void closeMenu() {
    _overlayEntry.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)!.insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      decoration: BoxDecoration(),
      child: IconButton(
        icon: new Icon(Icons.arrow_drop_down),
        color: Colors.white,
        onPressed: () {
          if (isMenuOpen) {
            closeMenu();
          } else {
            openMenu();
          }
        },
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + 10,
          left: buttonPosition.dx,
          width: MediaQuery.of(context).size.width,
          child: Material(
            elevation: 4,
            color: widget.backgroundColor,
            child: Stack(
              children: <Widget>[
                Align(alignment: Alignment.topCenter, child: Text("Select GP")),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    height: widget.input.length * 30,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                    ),
                    child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: widget.iconColor,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(widget.input.length, (index) {
                          return GestureDetector(
                              onTap: () {
                                widget.onChange(index);
                                closeMenu();
                              },
                              child: Material(
                                child: Container(
                                  color: widget.backgroundColor,
                                  width: MediaQuery.of(context).size.width,
                                  height: 20,
                                  child: Text(widget.input[index].tenantId),
                                ),
                              ));
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
