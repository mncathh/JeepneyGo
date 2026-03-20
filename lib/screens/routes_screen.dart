import 'package:flutter/material.dart';
import 'package:jeepneygo_milestone/main.dart';
import 'package:jeepneygo_milestone/widgets/weather_widget.dart'; // ← NEW
import 'favourites_screen.dart';
import 'add_route_screen.dart';
import 'news_screen.dart';

// App State Singleton
class AppState extends ChangeNotifier {
  static final AppState _i = AppState._();
  factory AppState() => _i;
  AppState._();

  final List<JeepRoute> routes = [
    JeepRoute(
      id: 'r1',
      code: '01',
      name: 'Balibago – SM Clark',
      jeepColor: Colors.purple,
      stops: [
        'Holy Rosary Church',
        'Angeles University Foundation',
        'Marisol',
        'Robinson Mall',
        'Astro Park',
        'SM Clark',
      ],
      fare: const RouteFare(normal: 13, student: 11, senior: 11),
    ),
    JeepRoute(
      id: 'r2',
      code: '02',
      name: 'Marisol – Jollibee Rotonda',
      jeepColor: J.green,
      stops: [
        'Angeles University Foundation',
        'Holy Rosary Parish Church',
        'Nepo Mall',
        'Jenra Mall',
        'Jollibee Rotonda',
      ],
      fare: const RouteFare(normal: 13, student: 11, senior: 11),
    ),
    JeepRoute(
      id: 'r3',
      code: '03',
      name: 'Pandan – Marquee Mall',
      jeepColor: J.blue,
      stops: [
        'Plaridel Street',
        'Mining Road',
        'Puregold Pandan',
        'Francisco G. Nepomuceno Memorial High School',
        'Marquee Mall',
      ],
      fare: const RouteFare(normal: 13, student: 11, senior: 11),
    ),
    JeepRoute(
      id: 'r4',
      code: '04',
      name: 'Telabastagan – Holy Angel University',
      jeepColor: Colors.yellow,
      stops: [
        'Savemore',
        'SM Telabastagan',
        'Chevalier School',
        'Super 8',
        'Holy Angel University',
      ],
      fare: const RouteFare(normal: 13, student: 11, senior: 11),
    ),
  ];

  final Set<String> favourites = {'r1', 'r3'};

  void toggleFav(String id) {
    favourites.contains(id) ? favourites.remove(id) : favourites.add(id);
    notifyListeners();
  }

  void addRoute(JeepRoute r) {
    routes.add(r);
    notifyListeners();
  }

  void updateRoute(JeepRoute r) {
    final i = routes.indexWhere((x) => x.id == r.id);
    if (i != -1) {
      routes[i] = r;
      notifyListeners();
    }
  }

  void deleteRoute(String id) {
    routes.removeWhere((r) => r.id == id);
    favourites.remove(id);
    notifyListeners();
  }

  bool isFav(String id) => favourites.contains(id);

  int get totalStops => routes.fold(0, (s, r) => s + r.stops.length);
}

// Route Models
class RouteFare {
  final double normal, student, senior;
  const RouteFare({
    required this.normal,
    required this.student,
    required this.senior,
  });
}

class JeepRoute {
  final String id, code, name;
  final Color jeepColor;
  final List<String> stops;
  final RouteFare fare;

  JeepRoute({
    required this.id,
    required this.code,
    required this.name,
    required this.jeepColor,
    required this.stops,
    required this.fare,
  });

  JeepRoute copyWith({
    String? code,
    String? name,
    Color? jeepColor,
    List<String>? stops,
    RouteFare? fare,
  }) {
    return JeepRoute(
      id: id,
      code: code ?? this.code,
      name: name ?? this.name,
      jeepColor: jeepColor ?? this.jeepColor,
      stops: stops ?? this.stops,
      fare: fare ?? this.fare,
    );
  }
}

// Main Shell with Bottom Navigation
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const RoutesScreen(),
      const FavouritesScreen(),
      const AddRouteScreen(),
      const NewsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: J.bg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        switchInCurve: Curves.easeOut,
        child: KeyedSubtree(key: ValueKey(_idx), child: _screens[_idx]),
      ),
      bottomNavigationBar: _BottomBar(
        idx: _idx,
        onTap: (i) => setState(() => _idx = i),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int idx;
  final ValueChanged<int> onTap;
  const _BottomBar({required this.idx, required this.onTap});

  static const _tabs = [
    (Icons.directions_bus_rounded, Icons.directions_bus_outlined, 'Routes'),
    (Icons.favorite_rounded, Icons.favorite_outline_rounded, 'Favorites'),
    (Icons.add_circle_rounded, Icons.add_circle_outline_rounded, 'Add Route'),
    (Icons.campaign_rounded, Icons.campaign_outlined, 'News'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: J.white,
        border: const Border(top: BorderSide(color: J.line, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 24,
            offset: const Offset(0, -6),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final t = _tabs[i];
              final on = idx == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: on ? J.red.withOpacity(.08) : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          on ? t.$1 : t.$2,
                          size: 22,
                          color: on ? J.red : J.muted,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          t.$3,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                on ? FontWeight.w800 : FontWeight.w500,
                            color: on ? J.red : J.muted,
                            letterSpacing: on ? .2 : 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// Routes Screen
class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final _st = AppState();
  final _sc = TextEditingController();
  String _q = '';
  bool _az = true;
  String? _open;

  @override
  void initState() {
    super.initState();
    _st.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  List<JeepRoute> get _list {
    final q = _q.toLowerCase();
    var l = _st.routes
        .where((r) =>
            r.name.toLowerCase().contains(q) ||
            r.code.contains(q) ||
            r.stops.any((s) => s.toLowerCase().contains(q)))
        .toList();
    l.sort((a, b) =>
        _az ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    return l;
  }

  void _del(JeepRoute r) {
    showDialog(
      context: context,
      builder: (_) => DelDialog(
        name: r.name,
        onOk: () {
          _st.deleteRoute(r.id);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradHeader(
          showLogo: true,
          title: 'Jeepney Routes',
          subtitle: 'Angeles City · ${_st.routes.length} active routes',
          action: SortPill(
            az: _az,
            onTap: () => setState(() => _az = !_az),
          ),
          extra: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  StatChip(
                    icon: Icons.alt_route_rounded,
                    value: '${_st.routes.length}',
                    label: 'Routes',
                  ),
                  const SizedBox(width: 8),
                  StatChip(
                    icon: Icons.favorite_rounded,
                    value: '${_st.favourites.length}',
                    label: 'Saved',
                  ),
                  const SizedBox(width: 8),
                  StatChip(
                    icon: Icons.location_on_rounded,
                    value: '${_st.totalStops}',
                    label: 'Stops',
                  ),
                ],
              ),
            ),
            GradSearch(
              ctrl: _sc,
              hint: 'Search routes, stops…',
              onChange: (v) => setState(() => _q = v),
            ),
          ],
        ),
        Expanded(
          child: _list.isEmpty
              ? const Empty(
                  icon: '🔍',
                  msg: 'No routes found',
                  sub: 'Try a different keyword',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: _list.length + 1, // +1 for weather widget
                  itemBuilder: (_, i) {
                    // ↓ Only change from original — weather widget as first item
                    if (i == 0) return const WeatherWidget();

                    final r = _list[i - 1];
                    return RouteCard(
                      route: r,
                      open: _open == r.id,
                      fav: _st.isFav(r.id),
                      onTap: () => setState(
                          () => _open = _open == r.id ? null : r.id),
                      onFav: () => _st.toggleFav(r.id),
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AddRouteScreen(edit: r)),
                      ),
                      onDel: () => _del(r),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// Gradient Header with Logo
class GradHeader extends StatelessWidget {
  final String title, subtitle;
  final Widget? action;
  final List<Widget> extra;
  final bool showLogo;

  const GradHeader({
    required this.title,
    required this.subtitle,
    this.action,
    this.extra = const [],
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B35), J.red, J.gold],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                children: [
                  if (showLogo) ...[
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          'assets/images/JeepneyGo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.directions_bus_rounded,
                            color: J.red,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: showLogo ? 22 : 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -.5,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (action != null) action!,
                ],
              ),
            ),
            ...extra,
          ],
        ),
      ),
    );
  }
}

// Search Bar on Gradient
class GradSearch extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final ValueChanged<String> onChange;
  const GradSearch({
    required this.ctrl,
    required this.hint,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: TextField(
        controller: ctrl,
        onChanged: onChange,
        style: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(.55), fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded,
              color: Colors.white.withOpacity(.65), size: 20),
          filled: true,
          fillColor: Colors.white.withOpacity(.18),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withOpacity(.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withOpacity(.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// Sort Pill
class SortPill extends StatelessWidget {
  final bool az;
  final VoidCallback onTap;
  const SortPill({required this.az, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.18),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.white.withOpacity(.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.sort_rounded, size: 14, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              az ? 'A→Z' : 'Z→A',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Stat Chip
class StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.16),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(.25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(.75),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Route Card
class RouteCard extends StatelessWidget {
  final JeepRoute route;
  final bool open, fav;
  final VoidCallback onTap, onFav, onEdit, onDel;
  const RouteCard({
    required this.route,
    required this.open,
    required this.fav,
    required this.onTap,
    required this.onFav,
    required this.onEdit,
    required this.onDel,
  });

  @override
  Widget build(BuildContext context) {
    final c = route.jeepColor;
    return Card(
      elevation: open ? 6 : 1,
      shadowColor:
          open ? c.withOpacity(.22) : Colors.black.withOpacity(.07),
      margin: const EdgeInsets.only(top: 12),
      color: J.card,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: open ? c.withOpacity(.45) : J.line, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [c, c.withOpacity(.3)]),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: c.withOpacity(.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: c.withOpacity(.2)),
                        ),
                        child: Center(
                          child: Text(
                            route.code,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: c),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              route.name,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: J.ink,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.place_outlined,
                                    size: 12, color: c),
                                const SizedBox(width: 3),
                                Text(
                                  '${route.stops.length} stops',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: J.muted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: onFav,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                fav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline_rounded,
                                key: ValueKey(fav),
                                color: fav ? J.red : J.muted,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AnimatedRotation(
                            turns: open ? .5 : 0,
                            duration: const Duration(milliseconds: 220),
                            child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: J.muted,
                                size: 22),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: c.withOpacity(.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: c.withOpacity(.12)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                              color: c, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            route.stops.first,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: c),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward_rounded,
                              size: 13, color: c.withOpacity(.4)),
                        ),
                        Expanded(
                          child: Text(
                            route.stops.last,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: c),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                              color: c, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      FarePill('Regular', route.fare.normal, J.red),
                      const SizedBox(width: 6),
                      FarePill('Student', route.fare.student, J.blue),
                      const SizedBox(width: 6),
                      FarePill('Senior', route.fare.senior, J.green),
                    ],
                  ),
                  if (open) ...[
                    const SizedBox(height: 16),
                    Divider(color: J.line, height: 1),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 13,
                          decoration: BoxDecoration(
                              color: c,
                              borderRadius: BorderRadius.circular(2)),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'ALL STOPS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: J.muted,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Timeline(stops: route.stops, color: c),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ActBtn(
                            label: 'Edit',
                            icon: Icons.edit_rounded,
                            onTap: onEdit,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ActBtn(
                          label: 'Delete',
                          icon: Icons.delete_rounded,
                          onTap: onDel,
                          danger: true,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FarePill extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  const FarePill(this.label, this.amount, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(.07),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: color.withOpacity(.15)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 11,
                  color: J.muted,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3),
            Text(
              '₱${amount.toInt()}',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class Timeline extends StatelessWidget {
  final List<String> stops;
  final Color color;
  const Timeline({required this.stops, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(stops.length, (i) {
        final end = i == 0 || i == stops.length - 1;
        return IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 22,
                child: Column(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: end ? color : J.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 2.5),
                      ),
                    ),
                    if (i < stops.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: color.withOpacity(.2),
                          margin: const EdgeInsets.symmetric(vertical: 2),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: i < stops.length - 1 ? 13 : 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          stops[i],
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight:
                                end ? FontWeight.w700 : FontWeight.w500,
                            color: end ? J.ink : J.sub,
                          ),
                        ),
                      ),
                      if (i == 0)
                        TLBadge('START', J.green, const Color(0xFFDCFCE7))
                      else if (i == stops.length - 1)
                        TLBadge('END', color, color.withOpacity(.1)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class TLBadge extends StatelessWidget {
  final String label;
  final Color color, bg;
  const TLBadge(this.label, this.color, this.bg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: .3,
        ),
      ),
    );
  }
}

class ActBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;
  const ActBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final col = danger ? J.red : J.sub;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: danger ? J.red.withOpacity(.07) : J.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: danger ? J.red.withOpacity(.25) : J.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: col),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: col),
            ),
          ],
        ),
      ),
    );
  }
}

class Empty extends StatelessWidget {
  final String icon, msg, sub;
  const Empty({required this.icon, required this.msg, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
                color: J.line, shape: BoxShape.circle),
            child: Center(
                child:
                    Text(icon, style: const TextStyle(fontSize: 34))),
          ),
          const SizedBox(height: 16),
          Text(
            msg,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: J.sub),
          ),
          const SizedBox(height: 5),
          Text(
            sub,
            style: const TextStyle(fontSize: 13, color: J.muted),
          ),
        ],
      ),
    );
  }
}

class DelDialog extends StatelessWidget {
  final String name;
  final VoidCallback onOk;
  const DelDialog({required this.name, required this.onOk});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: J.card,
      title: const Text('Delete Route?',
          style: TextStyle(fontWeight: FontWeight.w900, color: J.ink)),
      content: Text(
        'Remove "$name" from the list?',
        style: const TextStyle(color: J.sub, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
              style:
                  TextStyle(color: J.muted, fontWeight: FontWeight.w700)),
        ),
        ElevatedButton(
          onPressed: onOk,
          style: ElevatedButton.styleFrom(
            backgroundColor: J.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text('Delete',
              style: TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}