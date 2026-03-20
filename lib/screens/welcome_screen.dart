import 'package:flutter/material.dart';
import 'package:jeepneygo_milestone/main.dart';
import 'routes_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _road;
  late AnimationController _fade;

  late Animation<double> _lFade;
  late Animation<double> _cFade;
  late Animation<Offset> _lSlide;
  late Animation<Offset> _cSlide;

  @override
  void initState() {
    super.initState();

    // Single controller drives entire road — one value, one repaint
    _road = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _lFade = CurvedAnimation(
      parent: _fade,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );
    _lSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fade,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    ));

    _cFade = CurvedAnimation(
      parent: _fade,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _cSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fade,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fade.forward();
    });
  }

  @override
  void dispose() {
    _road.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Static gradient — never repaints
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.22, 0.42, 0.47, 1],
                colors: [
                  Color(0xFFffe066),
                  Color(0xFFffaa00),
                  Color(0xFFff6f00),
                  Color(0xFFc94000),
                  Color(0xFF1a3a1a),
                ],
              ),
            ),
          ),

          // Animated road scene — single CustomPainter, one canvas pass per frame
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _road,
              builder: (_, __) => CustomPaint(
                painter: _RoadPainter(progress: _road.value),
                child: const SizedBox.expand(),
              ),
            ),
          ),

          // Foreground UI
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: FadeTransition(
                    opacity: _lFade,
                    child: SlideTransition(
                      position: _lSlide,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.22),
                                    blurRadius: 36,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Image.asset(
                                  'assets/images/JeepneyGo.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(
                                      Icons.directions_bus_rounded,
                                      size: 60,
                                      color: J.goldLt,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 14,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                children: [
                                  TextSpan(text: 'Jeepney'),
                                  TextSpan(
                                    text: 'Go',
                                    style: TextStyle(color: J.goldLt),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Commute Smarter, Move Faster',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white70,
                                letterSpacing: .5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 52),
                  child: FadeTransition(
                    opacity: _cFade,
                    child: SlideTransition(
                      position: _cSlide,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.13),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Welcome Aboard!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1a2340),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Find your way around Angeles City routes quickly and easily.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF7a8a9a),
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (_, a, __) =>
                                          const MainShell(),
                                      transitionsBuilder: (_, a, __, child) =>
                                          FadeTransition(
                                        opacity: CurvedAnimation(
                                          parent: a,
                                          curve: Curves.easeInOut,
                                        ),
                                        child: child,
                                      ),
                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: J.gold,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 17),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 6,
                                  shadowColor: J.gold.withOpacity(.4),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Explore Routes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: .3,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded,
                                        size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Road Painter ─────────────────────────────────────────────────────────────
// Draws everything in one canvas pass — road, dashes, trees, buildings.
// Uses modulo (%) to keep all elements looping within screen bounds.

class _RoadPainter extends CustomPainter {
  final double progress;
  _RoadPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final roadTop = size.height * 0.72;
    final roadH = size.height * 0.28;

    // ── Road surface
    canvas.drawRect(
      Rect.fromLTWH(0, roadTop, size.width, roadH),
      Paint()..color = const Color(0xFF2a2a2a),
    );

    // ── Road top border
    canvas.drawLine(
      Offset(0, roadTop),
      Offset(size.width, roadTop),
      Paint()
        ..color = const Color(0xFF444444)
        ..strokeWidth = 3,
    );

    // ── Dash helper — uses % to loop cleanly within screen width
    void drawDashes(
        double y, Color color, double dashW, double gapW, double h) {
      final paint = Paint()..color = color;
      final total = dashW + gapW;
      // offset loops from 0 → total, then resets — seamless
      final startX = -(progress * total) % total;
      var x = startX;
      while (x < size.width + dashW) {
        canvas.drawRect(Rect.fromLTWH(x, y, dashW, h), paint);
        x += total;
      }
    }

    // Top white dashes
    drawDashes(
        roadTop + 10, Colors.white.withOpacity(0.35), 44, 88, 4);
    // Center gold line
    drawDashes(
        roadTop + roadH * 0.44, const Color(0xFFf5c842), 54, 96, 7);
    // Bottom white dashes
    drawDashes(
        roadTop + roadH - 14, Colors.white.withOpacity(0.20), 44, 88, 4);

    // ── Buildings — slow parallax, loops with %
    final bldgSpeed = progress * 0.4; // slower than road
    final bldgData = [
      [0.0, 40.0, 80.0],
      [55.0, 30.0, 60.0],
      [95.0, 50.0, 95.0],
      [155.0, 35.0, 70.0],
      [200.0, 45.0, 90.0],
      [255.0, 30.0, 65.0],
      [300.0, 40.0, 85.0],
      [350.0, 50.0, 100.0],
      [410.0, 35.0, 75.0],
    ];
    // Total width of one building tile
    const bldgTile = 460.0;
    final bldgOffset = (bldgSpeed * bldgTile) % bldgTile;
    final bldgPaint = Paint()..color = Colors.white.withOpacity(0.14);

    for (final b in bldgData) {
      // Draw twice side by side for seamless loop
      for (int rep = 0; rep < 3; rep++) {
        final x = b[0] - bldgOffset + rep * bldgTile;
        if (x + b[1] < 0 || x > size.width) continue;
        canvas.drawRect(
          Rect.fromLTWH(x, roadTop - b[2], b[1], b[2]),
          bldgPaint,
        );
      }
    }

    // ── Trees — medium speed, loops with %
    final treeSpeed = progress * 0.65;
    final treeXs = [30.0, 110.0, 195.0, 275.0, 355.0, 435.0];
    const treeTile = 480.0;
    final treeOffset = (treeSpeed * treeTile) % treeTile;
    final leavesPaint = Paint()
      ..color = const Color(0xFF3a9a3a).withOpacity(0.28);
    final trunkPaint = Paint()
      ..color = const Color(0xFF5a3a1a).withOpacity(0.28);

    for (final tx in treeXs) {
      for (int rep = 0; rep < 3; rep++) {
        final x = tx - treeOffset + rep * treeTile;
        if (x + 40 < 0 || x > size.width) continue;
        // Foliage
        canvas.drawCircle(Offset(x + 17, roadTop - 42), 19, leavesPaint);
        // Trunk
        canvas.drawRect(
            Rect.fromLTWH(x + 14, roadTop - 23, 6, 20), trunkPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_RoadPainter old) => old.progress != progress;
}