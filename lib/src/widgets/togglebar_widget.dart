import 'package:flutter/material.dart';
import 'togglebtn_widget.dart';

class ToggleBar extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  final void Function(Map<String, dynamic> value) onSelected;
  final String fieldVisited;

  final double padding;
  final double diameter;
  final Color iconColor;
  final Color foreground;
  final Color background;
  final Color selectedForegroundColor;
  final Color selectedBackgroundColor;

  final IconData defaultIcon;

  ToggleBar(
      {Key key,
      this.padding = 8.0,
      this.diameter = 62,
      this.iconColor = Colors.white,
      this.foreground = Colors.white,
      this.background = const Color(0xff67CABA),
      this.selectedForegroundColor = Colors.blueGrey,
      this.selectedBackgroundColor = const Color(0xff67CABA),
      this.defaultIcon = Icons.lock,
      @required this.list,
      @required this.fieldVisited,
      this.onSelected})
      : super(key: key);

  @override
  _ToggleBarState createState() => _ToggleBarState();
}

class _ToggleBarState extends State<ToggleBar> {
  List<Map<String, dynamic>> _list;
  int _idSelected = 0;
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    _list = widget.list;
    return Column(
      children: [
        Expanded(
          child: Center(
            // color: Colors.green,
            // padding: EdgeInsets.symmetric(horizontal: 40),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  _isSelected =
                      (_list[index]['id'] == _idSelected) ? true : false;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.padding, vertical: widget.padding),
                    child: ToggleBtn(
                      digit: _list[index]['id'].toString(),
                      selected: _isSelected,
                      diameter: widget.diameter,
                      defaultIcon: widget.defaultIcon,
                      iconColor: widget.iconColor,
                      foreground: widget.foreground,
                      background: widget.background,
                      selectedForegroundColor: widget.selectedForegroundColor,
                      selectedBackgroundColor: widget.selectedBackgroundColor,
                      visited: _list[index][widget.fieldVisited],
                      onPressed: () {
                        setState(() {
                          _list[index][widget.fieldVisited] = true;
                          _idSelected = _list[index]['id'];
                          widget.onSelected(_list[index]);
                        });
                      },
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
