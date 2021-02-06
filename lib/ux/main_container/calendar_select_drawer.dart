import 'package:flutter/material.dart';

import 'package:socialbuddybot/app/theme.dart';
import 'package:socialbuddybot/backend/backend.dart';
import 'package:socialbuddybot/backend/models/calendar_models.dart';
import 'package:socialbuddybot/ux/widgets/loading_indicator.dart';
import 'package:socialbuddybot/ux/widgets/value_stream_builder.dart';
import 'package:socialbuddybot/ux/widgets/widget_utils.dart';

class CalendarSelectDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final calendarRepository = backend.calendarRepository;

    return Drawer(
      child: FutureBuilder<List<Calendar>>(
        future: calendarRepository.getCalendars(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: LoadingIndicator.colored(),
            );
          }

          final calendars = snapshot.data;

          if (calendars.isEmpty) {
            return const Center(
              child: Text("Geen agenda's gevonden."),
            );
          }

          return ValueStreamBuilder<Calendar>(
            valueStream: calendarRepository.selectedCalendar,
            builder: (context, selectedCalendar) {
              return ListView(
                children: <Widget>[
                  verticalMargin12,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      'Selecteer agenda',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: AppTheme.colorGrey,
                          ),
                    ),
                  ),
                  verticalMargin12,
                  ListTile(
                    onTap: calendarRepository.deselectCalendar,
                    title: const Text('Geen agenda'),
                    trailing: selectedCalendar?.id != null
                        ? null
                        : const Icon(
                            Icons.check,
                            color: AppTheme.colorMain,
                          ),
                  ),
                  for (final calendar in calendars)
                    ListTile(
                      onTap: () =>
                          calendarRepository.setSelectedCalendar(calendar),
                      title: Text(calendar.name),
                      subtitle: Text('ID: ${calendar.id}'),
                      trailing: calendar.id != selectedCalendar?.id
                          ? null
                          : const Icon(
                              Icons.check,
                              color: AppTheme.colorMain,
                            ),
                    ),
                  verticalMargin12,
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
