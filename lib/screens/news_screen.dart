import 'package:flutter/material.dart';
import 'package:jeepneygo_milestone/main.dart';
import 'routes_screen.dart';


const kNews = [
  {
    'type': 'alert',
    'title': 'Road Closure – Sto. Rosario St.',
    'body':
        'Sto. Rosario Street will be closed 8 AM–12 PM on June 14 due to the Fiesta Procession. Route 02 passengers expect delays.',
    'date': 'June 12, 2025'
  },
  {
    'type': 'info',
    'title': 'New Fare Adjustment Effective July 1',
    'body':
        'LTFRB approved a ₱1 fare increase for all jeepney routes in Pampanga. Updated fares will be reflected soon.',
    'date': 'June 10, 2025'
  },
  {
    'type': 'tip',
    'title': 'Commuter Tip: Beat the Rush Hour',
    'body':
        'Avoid riding between 7–9 AM and 5–7 PM near Nepo Mall and SM Clark. Jeepneys fill up fast during these windows.',
    'date': 'June 8, 2025'
  },
  {
    'type': 'alert',
    'title': 'Route 03 Temporary Detour',
    'body':
        'Due to road repairs on Hensonville Ave, Route 03 jeepneys detour via Sto. Rosario St. until further notice.',
    'date': 'June 6, 2025'
  },
];

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradHeader(
          title: 'News & Alerts',
          subtitle: 'Updates, tips & announcements',
          extra: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/angeles_city_jeepney.png',
                  height: 108,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 108,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🚐', style: TextStyle(fontSize: 36)),
                        SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Angeles City',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16),
                            ),
                            Text(
                              'Jeepney Network',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: kNews.length,
            itemBuilder: (_, i) {
              final n = kNews[i];
              final type = n['type']!;
              late Color accent, bg, border;
              late IconData icon;
              late String badge;

              if (type == 'alert') {
                accent = J.red;
                bg = const Color(0xFFFFF4F2);
                border = const Color(0xFFFFCFCC);
                icon = Icons.warning_amber_rounded;
                badge = 'ALERT';
              } else if (type == 'info') {
                accent = J.blue;
                bg = const Color(0xFFEFF8FF);
                border = const Color(0xFFBAE6FD);
                icon = Icons.info_outline_rounded;
                badge = 'INFO';
              } else {
                accent = J.green;
                bg = const Color(0xFFF0FDF4);
                border = const Color(0xFFBBF7D0);
                icon = Icons.tips_and_updates_outlined;
                badge = 'TIP';
              }

              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                color: J.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: border, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: accent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    n['title']!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: J.ink),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: bg,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: border),
                                  ),
                                  child: Text(
                                    badge,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      color: accent,
                                      letterSpacing: .3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              n['body']!,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: J.sub,
                                  height: 1.55),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              children: [
                                const Icon(Icons.schedule_rounded,
                                    size: 12, color: J.muted),
                                const SizedBox(width: 4),
                                Text(
                                  n['date']!,
                                  style: const TextStyle(
                                      fontSize: 11.5,
                                      color: J.muted,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

}