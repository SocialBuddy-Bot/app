import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UppercaseText extends StatelessWidget {
  const UppercaseText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final Text text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.data.toUpperCase(),
      key: text.key,
      style: text.style,
      strutStyle: text.strutStyle,
      textAlign: text.textAlign,
      textDirection: text.textDirection,
      locale: text.locale,
      softWrap: text.softWrap,
      overflow: text.overflow,
      textScaleFactor: text.textScaleFactor,
      maxLines: text.maxLines,
      semanticsLabel: text.semanticsLabel,
      textWidthBasis: text.textWidthBasis,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Text>('text', text));
  }
}
