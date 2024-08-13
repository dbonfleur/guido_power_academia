import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class CustomEmbedBuilder implements quill.EmbedBuilder {
  @override
  String get key => 'image';

  @override
  Widget build(
    BuildContext context,
    quill.QuillController controller,
    quill.Embed embed,
    bool readOnly,
    bool autoFocus,
    TextStyle textStyle,
  ) {
    final String base64Image = embed.value.data;
    return Image.memory(base64Decode(base64Image));
  }

  @override
  WidgetSpan buildWidgetSpan(
    Widget widget,
  ) {
    return WidgetSpan(
      child: widget,
    );
  }

  bool matches(String key) {
    return key == 'image';
  }

  @override
  String toPlainText(quill.Embed embed) {
    return '[image]';
  }

  @override
  bool get expanded => false;
}
