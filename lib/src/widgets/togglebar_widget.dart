import 'package:flutter/material.dart';
import 'togglebtn_widget.dart';
import '../utils/utils.dart' as utils;

class ToggleBar extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  final void Function(Map<String, dynamic> value) onSelected;
  final String fieldVisited;

  ToggleBar(
      {Key key,
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
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _list.length,
        itemBuilder: (context, index) {
          _isSelected = (_list[index]['id'] == _idSelected) ? true : false;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
            child: ToggleBtn(
              digit: _list[index]['id'].toString(),
              selected: _isSelected,
              diameter: 52,
              defaultIcon: Icons.lock,
              iconColor: Colors.white,
              foreground: Colors.white,
              background: utils.primary,
              selectedForegroundColor: Colors.black87,
              selectedBackgroundColor: Colors.blueGrey[600],
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
        });
  }
}
