import 'package:flutter/material.dart';

import '../state/app_state.dart';

const pink = Color(0xFFED7B9D);
const gold = Color(0xFFEBC27E);
const ink = Color(0xFF444444);
const muted = Color(0xFF999999);
const line = Color(0xFFF2F2F2);
const brandGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [gold, Color(0xFFE24A9A)],
);

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

void open(BuildContext context, String route, [Object? arguments]) =>
    Navigator.of(context).pushNamed(route, arguments: arguments);
void home(BuildContext context) =>
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
void notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

Widget photo(
  String name, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) => Image.asset(
  'assets/images/$name.png',
  width: width,
  height: height,
  fit: fit,
  filterQuality: FilterQuality.medium,
);

class Avatar extends StatelessWidget {
  const Avatar(this.image, {super.key, this.size = 60, this.online = false});
  final String image;
  final double size;
  final bool online;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: Stack(
      children: [
        ClipOval(
          child: photo(image, width: size, height: size),
        ),
        if (online)
          Positioned(
            right: 0,
            bottom: 1,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: const Color(0xFF53DABB),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    ),
  );
}

class BrandButton extends StatelessWidget {
  const BrandButton(
    this.text,
    this.onPressed, {
    super.key,
    this.outlined = false,
    this.gradient = false,
    this.color,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool outlined, gradient;
  final Color? color;
  @override
  Widget build(BuildContext context) => Container(
    height: 46,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      gradient: gradient && !outlined ? brandGradient : null,
      color: gradient || outlined ? null : color ?? pink,
      border: outlined ? Border.all(color: color ?? pink) : null,
    ),
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: outlined ? color ?? pink : Colors.white,
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(text),
    ),
  );
}

class PageFrame extends StatelessWidget {
  const PageFrame(
    this.title, {
    super.key,
    required this.child,
    this.action,
    this.scroll = true,
  });
  final String title;
  final Widget child;
  final Widget? action;
  final bool scroll;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title), actions: [?action]),
    body: SafeArea(
      top: false,
      child: scroll
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: child,
            )
          : child,
    ),
  );
}

class FormFieldTile extends StatefulWidget {
  const FormFieldTile(
    this.label, {
    super.key,
    this.initial = '',
    this.onChanged,
    this.secret = false,
    this.lines = 1,
    this.keyboardType,
    this.hint,
    this.validator,
  });
  final String label, initial;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final bool secret;
  final int lines;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  @override
  State<FormFieldTile> createState() => _FormFieldTileState();
}

class _FormFieldTileState extends State<FormFieldTile> {
  bool visible = false;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      key: ValueKey(widget.label),
      initialValue: widget.initial,
      onChanged: widget.onChanged,
      validator: widget.validator,
      obscureText: widget.secret && !visible,
      maxLines: widget.lines,
      keyboardType: widget.keyboardType,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        alignLabelWithHint: true,
        suffixIcon: widget.secret
            ? IconButton(
                tooltip: visible ? 'Hide password' : 'Show password',
                onPressed: () => setState(() => visible = !visible),
                icon: Icon(
                  visible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                ),
              )
            : null,
      ),
    ),
  );
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Search person',
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    style: const TextStyle(fontSize: 13),
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      prefixIcon: const Icon(Icons.search, size: 20),
      suffixIcon: IconButton(
        tooltip: 'Clear search',
        icon: const Icon(Icons.close, size: 17),
        onPressed: () {
          controller.clear();
          onChanged('');
        },
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
    ),
  );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 12),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    ),
  );
}

class InterestChips extends StatelessWidget {
  const InterestChips({super.key, this.editable = false});
  final bool editable;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    const labels = ['Photography', 'Running', 'Music', 'Food', 'Handmade'];
    const colors = [
      pink,
      Color(0xFFA595ED),
      gold,
      Color(0xFF53DABB),
      Color(0xFF85ADF5),
    ];
    return Wrap(
      spacing: 7,
      runSpacing: 6,
      children: List.generate(
        labels.length,
        (i) => GestureDetector(
          onTap: editable ? () => state.toggleInterest(labels[i]) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors[i].withValues(
                alpha: !editable || state.interests.contains(labels[i])
                    ? 1
                    : .16,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              '${labels[i]} ${editable && state.interests.contains(labels[i]) ? '✓' : '+'}',
              style: TextStyle(
                fontSize: 11,
                color: !editable || state.interests.contains(labels[i])
                    ? Colors.white
                    : ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(gradient: brandGradient),
    child: CustomPaint(painter: _Waves(), child: child),
  );
}

class _Waves extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 3; i++) {
      final y = size.height * (.76 + i * .07);
      final p = Path()
        ..moveTo(0, y)
        ..cubicTo(
          size.width * .4,
          y - 160,
          size.width * .6,
          y + 180,
          size.width,
          y - 30,
        )
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(p, Paint()..color = Colors.white.withValues(alpha: .11));
    }
  }

  @override
  bool shouldRepaint(_Waves oldDelegate) => false;
}

class PatternBackground extends StatelessWidget {
  const PatternBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(child: CustomPaint(painter: _Pattern())),
      child,
    ],
  );
}

class _Pattern extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 20; i++) {
      final painter = TextPainter(
        text: TextSpan(
          text: i.isEven ? '♡' : '♧',
          style: TextStyle(
            fontSize: 38,
            color: (i % 3 == 0 ? gold : pink).withValues(alpha: .10),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate((i * 97.0) % size.width, i * size.height / 20);
      canvas.rotate(i.isEven ? .3 : -.3);
      painter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_Pattern oldDelegate) => false;
}
