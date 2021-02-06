import 'package:socialbuddybot/backend/models/calendar_models.dart';
import 'package:socialbuddybot/utils/utils.dart';

String getDecisionResponse(EventDecision decision) {
  return [
    if (decision.isCheckOff) ...[
      'Netjes! Goed gedaan.',
      'Top! Opgeslagen.',
      'Mooi! Afgevinkt.',
    ] else if (decision.isPostpone) ...[
      'Geen probleem. Ik zal je later opnieuw herinneren.',
      'Begrepen. Ik herinner je later opnieuw.',
    ],
  ].randomOrNull;
}
