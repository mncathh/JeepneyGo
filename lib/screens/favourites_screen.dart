import 'package:flutter/material.dart';
import 'package:jeepneygo_milestone/main.dart';
import 'routes_screen.dart';
import 'add_route_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
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
            _st.isFav(r.id) &&
            (r.name.toLowerCase().contains(q) ||
                r.code.contains(q) ||
                r.stops.any((s) => s.toLowerCase().contains(q))))
        .toList();
    l.sort((a, b) =>
        _az ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    return l;
  }

  int get _totalFavStops => _list.fold(0, (s, r) => s + r.stops.length);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradHeader(
          showLogo: true,
          title: 'Favorites',
          subtitle:
              '❤️ ${_st.favourites.length} saved route${_st.favourites.length != 1 ? "s" : ""}',
          action: SortPill(
            az: _az,
            onTap: () => setState(() => _az = !_az),
          ),
          extra: [
            // Stat chips — only shown when there are favourites
            if (_st.favourites.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Row(
                  children: [
                    StatChip(
                      icon: Icons.favorite_rounded,
                      value: '${_st.favourites.length}',
                      label: 'Saved',
                    ),
                    const SizedBox(width: 8),
                    StatChip(
                      icon: Icons.location_on_rounded,
                      value: '$_totalFavStops',
                      label: 'Stops',
                    ),
                  ],
                ),
              ),
            GradSearch(
              ctrl: _sc,
              hint: 'Search favorites…',
              onChange: (v) => setState(() => _q = v),
            ),
          ],
        ),
        Expanded(
          child: _list.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: J.red.withOpacity(.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('❤️',
                              style: TextStyle(fontSize: 36)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: J.sub,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap the heart on any route to save it',
                        style: TextStyle(fontSize: 13, color: J.muted),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: _list.length + 1, // +1 for tip text
                  itemBuilder: (_, i) {
                    // Tip text at the bottom
                    if (i == _list.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 13, color: J.muted),
                            const SizedBox(width: 6),
                            const Text(
                              'Tap any route to view stops & fares',
                              style: TextStyle(
                                fontSize: 12,
                                color: J.muted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final r = _list[i];
                    return RouteCard(
                      route: r,
                      open: _open == r.id,
                      fav: true,
                      onTap: () => setState(
                          () => _open = _open == r.id ? null : r.id),
                      onFav: () => _st.toggleFav(r.id),
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AddRouteScreen(edit: r)),
                      ),
                      onDel: () => showDialog(
                        context: context,
                        builder: (_) => DelDialog(
                          name: r.name,
                          onOk: () {
                            _st.deleteRoute(r.id);
                            Navigator.pop(context);
                          },
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