import 'package:flutter/material.dart';
import '../utils/utils.dart' as utils;

class InputText extends StatefulWidget {
  final String label;
  final Function(String) validator;
  final Function(String) onSaved;
  final String value;
  final String hint;
  final bool isSecure;
  final TextInputType inputType;
  final double fontSize;
  final IconData prefixIcon;

  const InputText(
      {Key key,
      this.label,
      this.onSaved,
      this.value,
      this.hint,
      this.validator,
      this.isSecure = false,
      this.inputType = TextInputType.text,
      this.fontSize = 17,
      this.prefixIcon = Icons.done})
      : super(key: key);

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.value,
      onSaved: widget.onSaved,
      keyboardType: widget.inputType,
      obscureText: widget.isSecure,
      validator: widget.validator,
      style: TextStyle(fontSize: widget.fontSize),
      decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize:16),
          prefixIcon: Icon(widget.prefixIcon),
          hintText: widget.hint,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          contentPadding: EdgeInsets.all(10.0),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              borderSide: BorderSide(color: utils.accent))),
    );
  }
}

/*
TextFormField(
    initialValue: '',
    onSaved: (value) => _name = value,
    decoration: InputDecoration(
        hintText: 'Nombre',
        fillColor:
            Theme.of(context).scaffoldBackgroundColor,
        filled: true,
        contentPadding: EdgeInsets.all(10.0),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(3.0)),
            borderSide:
                BorderSide(color: utils.accent))
    ),

    style: TextStyle(fontSize: 14),
    validator: (value) {
      if (value.isEmpty)
        return "El nombre esta vacio";
      return null;
    },
  ),

*/
