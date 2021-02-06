import 'package:flutter/material.dart';

import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';

import 'package:socialbuddybot/backend/backend.dart';
import 'package:socialbuddybot/backend/models/calendar_models.dart';
import 'package:socialbuddybot/utils/utils.dart';
import 'package:socialbuddybot/ux/ux_utils.dart';
import 'package:socialbuddybot/ux/widgets/value_stream_builder.dart';

class _DebugStat<T> {
  const _DebugStat.cachedStream({
    @required this.title,
    @required this.valueStreamBuilder,
    Mapper<T, String> stringMapper,
  }) : _stringMapper = stringMapper;

  _DebugStat.future({
    @required this.title,
    @required ContextBuilder<Future<T>> futureBuilder,
    Mapper<T, String> stringMapper,
  })  : _stringMapper = stringMapper,
        valueStreamBuilder =
            ((context) => futureBuilder(context).toValueStream());

  final Mapper<T, String> _stringMapper;

  final String title;
  final ContextBuilder<ValueStream<T>> valueStreamBuilder;

  String stringMapper(dynamic object) {
    return _stringMapper?.call(object as T) ?? object.toString();
  }
}

class DebugDrawer extends StatelessWidget {
  final _stats = <_DebugStat>[
    _DebugStat.future(
      title: 'Versie & build',
      futureBuilder: (_) => PackageInfo.fromPlatform(),
      stringMapper: (info) => '${info.version} (${info.buildNumber})',
    ),
    _DebugStat.cachedStream(
      title: 'Calender',
      valueStreamBuilder: (context) =>
          backend.calendarRepository.selectedCalendar,
      stringMapper: (calendar) => (calendar as Calendar).format(),
    ),
    _DebugStat<Event>.cachedStream(
      title: 'Laatste event',
      valueStreamBuilder: (context) =>
          backend.calendarRepository.latestQueuedEvent,
      stringMapper: (event) => event.format(),
    ),
    _DebugStat<bool>.cachedStream(
      title: 'Gezichten gedetecteerd',
      valueStreamBuilder: (context) =>
          backend.faceDetectionService.facesDetected,
      stringMapper: (detected) => detected ? 'JA' : 'NEE',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Divider(
            height: 1,
            thickness: 1.0,
          ),
          for (final stat in _stats) ...[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${stat.title}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: ValueStreamBuilder(
                      valueStream: stat.valueStreamBuilder(context),
                      builder: (context, data) {
                        if (data == null) {
                          return const Text(
                            'null',
                            style: TextStyle(color: Colors.grey),
                          );
                        }

                        return Text(stat.stringMapper(data));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1.0,
            ),
          ],
        ],
      ),
    );
  }
}
