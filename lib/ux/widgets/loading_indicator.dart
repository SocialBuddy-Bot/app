import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:socialbuddybot/app/theme.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
    this.color = AppTheme.colorWhite,
  })  : assert(color != null, 'color cannot be null.'),
        super(key: key);

  const LoadingIndicator.colored({Key key})
      : color = AppTheme.colorMain,
        super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
  }
}
