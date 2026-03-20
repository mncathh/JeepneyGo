import 'package:flutter/material.dart';
import 'package:jeepneygo_milestone/main.dart';
import 'routes_screen.dart';

class AddRouteScreen extends StatefulWidget {
  final JeepRoute? edit;
  const AddRouteScreen({super.key, this.edit});

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final _st = AppState();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _stopIn = TextEditingController();
  final _norm = TextEditingController();
  final _stu = TextEditingController();
  final _sen = TextEditingController();

  Color _col = J.red;
  List<String> _stops = ['', ''];
  String _err = '';
  bool get _editing => widget.edit != null;

  static const _pal = [
    Color.fromARGB(255, 201, 12, 12),
    J.orange,
    Color.fromARGB(255, 103, 103, 103),
    Color.fromARGB(255, 181, 181, 181),
    J.gold,
    Color.fromARGB(255, 248, 245, 70),
    J.blue,
    Color.fromARGB(255, 15, 118, 25),
    J.pink,
    Color.fromARGB(255, 124, 87, 187),
  ];

  @override
  void initState() {
    super.initState();
    if (_editing) {
      final r = widget.edit!;
      _code.text = r.code;
      _name.text = r.name;
      _col = r.jeepColor;
      _stops = List.from(r.stops);
      _norm.text = r.fare.normal.toInt().toString();
      _stu.text = r.fare.student.toInt().toString();
      _sen.text = r.fare.senior.toInt().toString();
    }
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _stopIn.dispose();
    _norm.dispose();
    _stu.dispose();
    _sen.dispose();
    super.dispose();
  }

  void _addStop() {
    final s = _stopIn.text.trim();
    if (s.isNotEmpty) {
      setState(() {
        _stops.add(s);
        _stopIn.clear();
      });
    }
  }

  void _save() {
    if (_code.text.trim().isEmpty) {
      setState(() => _err = 'Route code is required.');
      return;
    }
    if (_name.text.trim().isEmpty) {
      setState(() => _err = 'Route name is required.');
      return;
    }
    if (_stops.where((s) => s.trim().isNotEmpty).length < 2) {
      setState(() => _err = 'Add at least 2 stops.');
      return;
    }
    if (_norm.text.isEmpty || _stu.text.isEmpty || _sen.text.isEmpty) {
      setState(() => _err = 'Please fill in all fares.');
      return;
    }

    final r = JeepRoute(
      id: _editing
          ? widget.edit!.id
          : 'r${DateTime.now().millisecondsSinceEpoch}',
      code: _code.text.trim(),
      name: _name.text.trim(),
      jeepColor: _col,
      stops: _stops.where((s) => s.trim().isNotEmpty).toList(),
      fare: RouteFare(
        normal: double.tryParse(_norm.text) ?? 0,
        student: double.tryParse(_stu.text) ?? 0,
        senior: double.tryParse(_sen.text) ?? 0,
      ),
    );

    if (_editing) {
      _st.updateRoute(r);
      Navigator.pop(context);
    } else {
      _st.addRoute(r);
      setState(() {
        _code.clear();
        _name.clear();
        _norm.clear();
        _stu.clear();
        _sen.clear();
        _stops = ['', ''];
        _col = _pal[0];
        _err = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Route added! ✅',
              style: TextStyle(fontWeight: FontWeight.w700)),
          backgroundColor: J.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  InputDecoration _deco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: J.muted, fontSize: 14),
      filled: true,
      fillColor: J.bg,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: J.line, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: J.line, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: J.red, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: J.bg,
      // Stack allows sticky button over scrollable content
      body: Stack(
        children: [
          Column(
            children: [
              GradHeader(
                showLogo: true,
                title: _editing ? 'Edit Route' : 'Add New Route',
                subtitle: _editing
                    ? 'Updating Route ${widget.edit!.code}'
                    : 'Fill in the details below',
                action: _editing
                    ? GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.close_rounded,
                              color: Colors.white, size: 20),
                        ))
                    : null,
              ),
              Expanded(
                child: ListView(
                  // Extra bottom padding so content clears the sticky button
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  children: [
                    // Route info
                    _Sect(
                      title: 'Route Info',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FL('Route Code'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _code,
                            style: _ts,
                            decoration: _deco('e.g. 06'),
                          ),
                          const SizedBox(height: 14),
                          _FL('Route Name'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _name,
                            style: _ts,
                            decoration: _deco('e.g. Malabanias – SM Clark'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Color picker — bigger circles (48px) for easier mobile tapping
                    _Sect(
                      title: 'Jeepney Color',
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _pal.map((pc) {
                          final on = _col == pc;
                          return GestureDetector(
                            onTap: () => setState(() => _col = pc),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: pc,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: on ? J.ink : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: on
                                    ? [
                                        BoxShadow(
                                            color: pc.withOpacity(.5),
                                            blurRadius: 8,
                                            spreadRadius: 1)
                                      ]
                                    : [],
                              ),
                              child: on
                                  ? const Icon(Icons.check_rounded,
                                      color: Colors.white, size: 20)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Stops
                    _Sect(
                      title: 'Stops & Landmarks',
                      child: Column(
                        children: [
                          ..._stops.asMap().entries.map((e) {
                            final i = e.key;
                            final s = e.value;
                            final isEnd = i == 0 || i == _stops.length - 1;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: isEnd ? _col : J.line,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: isEnd
                                              ? Colors.white
                                              : J.muted,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: s,
                                      onChanged: (v) => _stops[i] = v,
                                      style: _ts,
                                      decoration: _deco(i == 0
                                          ? 'Starting point'
                                          : i == _stops.length - 1
                                              ? 'End point'
                                              : 'Stop ${i + 1}'),
                                    ),
                                  ),
                                  if (_stops.length > 2) ...[
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => setState(
                                          () => _stops.removeAt(i)),
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: J.line,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          size: 15,
                                          color: J.muted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _stopIn,
                                  onSubmitted: (_) => _addStop(),
                                  style: _ts,
                                  decoration:
                                      _deco('Add a stop or landmark…'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // + button dynamically matches selected jeepney color
                              GestureDetector(
                                onTap: _addStop,
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: _col,
                                    borderRadius:
                                        BorderRadius.circular(13),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _col.withOpacity(.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.add_rounded,
                                      color: Colors.white, size: 22),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Fares
                    _Sect(
                      title: 'Fare (₱)',
                      child: Row(
                        children: [
                          Expanded(
                              child: _FareBox(_norm, 'Regular', J.red)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: _FareBox(_stu, 'Student', J.blue)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: _FareBox(_sen, 'Senior', J.green)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Error message
                    if (_err.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4F2),
                          borderRadius: BorderRadius.circular(13),
                          border:
                              Border.all(color: J.red.withOpacity(.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                size: 16, color: J.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _err,
                                style: const TextStyle(
                                    color: J.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Sticky save button — always visible at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              decoration: BoxDecoration(
                color: J.bg,
                border: const Border(
                  top: BorderSide(color: J.line, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: J.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    shadowColor: J.red.withOpacity(.3),
                  ),
                  child: Text(
                    _editing ? 'Save Changes' : 'Add Route',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _ts =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: J.ink);
}

class _Sect extends StatelessWidget {
  final String title;
  final Widget child;
  const _Sect({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: J.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: J.line),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: J.muted,
                letterSpacing: .9),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FL extends StatelessWidget {
  final String t;
  const _FL(this.t);

  @override
  Widget build(BuildContext context) {
    return Text(
      t,
      style: const TextStyle(
          fontSize: 12.5, fontWeight: FontWeight.w700, color: J.sub),
    );
  }
}

class _FareBox extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final Color color;
  const _FareBox(this.ctrl, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 11.5, fontWeight: FontWeight.w700, color: color),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          decoration: InputDecoration(
            hintText: '0',
            prefixText: '₱',
            hintStyle: const TextStyle(color: J.muted),
            prefixStyle: TextStyle(
                color: color, fontWeight: FontWeight.w800, fontSize: 14),
            filled: true,
            fillColor: color.withOpacity(.05),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 13, horizontal: 6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: color.withOpacity(.25), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: color.withOpacity(.25), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}