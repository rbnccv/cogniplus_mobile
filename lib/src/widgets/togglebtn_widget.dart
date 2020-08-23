import 'package:flutter/material.dart';

class ToggleBtn extends StatefulWidget {
  final String digit;
  final bool visited;
  final bool selected;
  final double diameter;
  final double elevacion;
  final Color iconColor;
  final Color foreground;
  final Color background;
  final Color selectedForegroundColor;
  final Color selectedBackgroundColor;
  final ShapeBorder shape;
  final IconData defaultIcon;
  final void Function() onPressed;
  ToggleBtn(
      {Key key,
      this.digit,
      this.visited = false,
      this.selected = false,
      this.diameter = 62,
      this.elevacion = 6,
      this.iconColor = Colors.white,
      this.foreground = Colors.white,
      this.background = const Color(0xff67CABA),
      this.selectedForegroundColor = Colors.blueGrey,
      this.selectedBackgroundColor = const Color(0xff67CABA),
      this.shape = const CircleBorder(),
      this.defaultIcon = Icons.lock,
      @required this.onPressed})
      : super(key: key);

  @override
  _ToggleBtnState createState() => _ToggleBtnState();
}

class _ToggleBtnState extends State<ToggleBtn> {
  Widget _icon;
  Color _background;
  TextStyle _foreground;

  @override
  Widget build(BuildContext context) {
    _background =
        (widget.selected) ? widget.selectedBackgroundColor : widget.background;

    _foreground = TextStyle(
      color: (widget.selected)
          ? widget.selectedForegroundColor
          : widget.foreground,
      fontSize: (widget.diameter / 4) * 3,
      fontWeight: FontWeight.bold,
    );

    _icon = (!widget.visited)
        ? Icon(
            widget.defaultIcon,
            size: (widget.diameter / 4) * 3,
            color: widget.iconColor,
          )
        : Text(widget.digit, style: _foreground);

    return SizedBox(
      height: widget.diameter,
      width: widget.diameter,
      child: RaisedButton(
          child: _icon,
          color: _background,
          padding: EdgeInsets.zero,
          elevation: widget.elevacion,
          shape: widget.shape,
          onPressed: () {
            widget.onPressed();
          }),
    );
  }
}
