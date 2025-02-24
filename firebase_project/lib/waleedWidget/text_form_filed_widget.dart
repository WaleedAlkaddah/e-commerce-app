import 'package:firebase_project/utility/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFiledWidget extends StatefulWidget {
  final double widthFiled;
  final double heightFiled;
  final String labelFiled;
  final double widthLabel;
  final double heightLabel;
  final double labelSizeFont;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool? obscurePassword;
  final FontWeight? fontWeightType;
  final Icon? prefixIconWidget;
  final String? hintTextWidget;
  final TextStyle? hintTextStyleWidget;
  final String? Function(String?)? validator;
  final bool readOnlyFiled;

  const TextFormFiledWidget({
    super.key,
    required this.widthFiled,
    required this.heightFiled,
    required this.labelFiled,
    required this.widthLabel,
    required this.heightLabel,
    required this.labelSizeFont,
    required this.controller,
    required this.textInputType,
    this.obscurePassword,
    this.validator,
    this.fontWeightType,
    this.prefixIconWidget,
    this.hintTextWidget,
    this.hintTextStyleWidget,
    this.readOnlyFiled = false,
  });

  @override
  State<TextFormFiledWidget> createState() => _TextFormFiledWidgetState();
}

class _TextFormFiledWidgetState extends State<TextFormFiledWidget> {
  FocusNode myFocusNode = FocusNode();
  String? errorMessage;

  @override
  void initState() {
    myFocusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void validate(String value) {
    if (widget.validator != null) {
      setState(() {
        errorMessage = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.widthFiled.w,
      height: widget.heightFiled.h,
      child: TextFormField(
        readOnly: widget.readOnlyFiled,
        focusNode: myFocusNode,
        obscureText: widget.obscurePassword ?? false,
        keyboardType: widget.textInputType,
        controller: widget.controller,
        onChanged: validate,
        validator: widget.validator,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00C569), width: 2.0),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          labelText: widget.labelFiled,
          labelStyle: GlobalUtils.googleFontsFunction(
              fontWeightText: widget.fontWeightType,
              fontSizeText: widget.labelSizeFont.sp,
              colorText:
                  myFocusNode.hasFocus ? const Color(0xFF00C569) : Colors.grey),
          errorText: errorMessage,
          prefixIcon: widget.prefixIconWidget,
          hintText: widget.hintTextWidget,
          hintStyle: widget.hintTextStyleWidget,
        ),
      ),
    );
  }
}
