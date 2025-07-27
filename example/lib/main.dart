import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:rounded_background_text/rounded_background_text.dart';

final _primaryAndAccentColors = [...Colors.primaries, ...Colors.accents];

enum _HighlightTextType { field, text, span, selectableText }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ScrollController colorsController;
  final controller = TextEditingController();

  double fontSize = 20.0;
  double innerRadius = kDefaultInnerRadius;
  double outerRadius = kDefaultOuterRadius;

  TextAlign textAlign = TextAlign.center;
  FontWeight fontWeight = FontWeight.bold;
  _HighlightTextType type = _HighlightTextType.text;

  late Color selectedColor;

  @override
  void initState() {
    super.initState();

    final initialIndex = math.Random().nextInt(_primaryAndAccentColors.length);
    selectedColor = _primaryAndAccentColors[initialIndex];

    colorsController = ScrollController(
      initialScrollOffset: 40.0 * initialIndex,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    colorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rounded Background Showcase',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: Scaffold(
        body: SafeArea(
          child: Column(children: [
            Material(
              child: Row(children: [
                const VerticalDivider(),
                Expanded(
                  child: DropdownButton<FontWeight>(
                    isExpanded: true,
                    value: fontWeight,
                    onChanged: (w) => setState(
                      () => fontWeight = w ?? FontWeight.normal,
                    ),
                    icon: const Icon(Icons.format_bold),
                    items: FontWeight.values.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text('$e'.replaceAll('FontWeight.', '')),
                      );
                    }).toList(),
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: DropdownButton<TextAlign>(
                    value: textAlign,
                    onChanged: (align) => setState(
                      () => textAlign = align ?? TextAlign.center,
                    ),
                    icon: Icon(() {
                      switch (textAlign) {
                        case TextAlign.center:
                          return Icons.format_align_center;
                        case TextAlign.end:
                        case TextAlign.right:
                          return Icons.format_align_right;
                        case TextAlign.start:
                        case TextAlign.left:
                          return Icons.format_align_left;
                        default:
                          return null;
                      }
                    }()),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: TextAlign.start,
                        child: Text('Start'),
                      ),
                      DropdownMenuItem(
                        value: TextAlign.center,
                        child: Text('Center'),
                      ),
                      DropdownMenuItem(
                        value: TextAlign.end,
                        child: Text('End'),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: DropdownButton<_HighlightTextType>(
                    value: type,
                    onChanged: (t) => setState(
                      () => type = t ?? _HighlightTextType.field,
                    ),
                    icon: const Icon(Icons.text_fields),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: _HighlightTextType.field,
                        child: Text('Field'),
                      ),
                      DropdownMenuItem(
                        value: _HighlightTextType.text,
                        child: Text('Text'),
                      ),
                      DropdownMenuItem(
                        value: _HighlightTextType.selectableText,
                        child: Text('Selectable Text'),
                      ),
                      DropdownMenuItem(
                        value: _HighlightTextType.span,
                        child: Text('Span'),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: () {
                    final textColor = selectedColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white;
                    switch (type) {
                      case _HighlightTextType.field:
                        return RoundedBackgroundTextField(
                          controller: controller,
                          backgroundColor: selectedColor,
                          textAlign: textAlign,
                          hint: 'Type your text here',
                          cursorColor: Color(0xFF000000),  // Black cursor
                          selectionControls: Platform.isIOS
                              ? customCupertinoTextSelectionControls
                              : MaterialTextSelectionControls(),
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                            color: textColor,
                          ),
                          innerRadius: innerRadius,
                          outerRadius: outerRadius,
                        );
                      case _HighlightTextType.text:
                        return RoundedBackgroundText(
                          '''Rounded Background Text Showcase
It handles well all font sizes and weights, as well as text alignments
Contributions are welcome!
Done with so much <3 by @bdlukaa''',
                          backgroundColor: selectedColor,
                          textAlign: textAlign,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                            color: textColor,
                          ),
                          innerRadius: innerRadius,
                          outerRadius: outerRadius,
                        );
                      case _HighlightTextType.selectableText:
                        return RoundedBackgroundText.selectable(
                          '''Rounded Background Text Showcase

It handles well all font sizes and weights, as well as text alignments
Contributions are welcome!
Done with so much <3 by @bdlukaa''',
                          backgroundColor: selectedColor,
                          textAlign: textAlign,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                            color: textColor,
                          ),
                          innerRadius: innerRadius,
                          outerRadius: outerRadius,
                        );
                      case _HighlightTextType.span:
                        return RichText(
                          textAlign: textAlign,
                          text: TextSpan(
                            text: 'You can use this to ',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: fontWeight,
                              color: Colors.white,
                            ),
                            children: [
                              RoundedBackgroundTextSpan(
                                text: 'highlight important stuff inside a text',
                                backgroundColor: selectedColor,
                                innerRadius: innerRadius,
                                outerRadius: outerRadius,
                                textAlign: textAlign,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: fontWeight,
                                  color: textColor,
                                ),
                              ),
                              const TextSpan(text: ' and stuff like that'),
                            ],
                          ),
                        );
                    }
                  }(),
                ),
              ),
            ),
            Row(children: [
              GestureDetector(
                onTap: () {
                  colorsController.animateTo(
                    (colorsController.position.pixels - 40),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: const Icon(Icons.chevron_left),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  colorsController.animateTo(
                    (colorsController.position.pixels + 40),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: const Icon(Icons.chevron_right),
              ),
            ]),
            Material(
              child: SingleChildScrollView(
                controller: colorsController,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  runSpacing: 10.0,
                  spacing: 10.0,
                  alignment: WrapAlignment.center,
                  children: _primaryAndAccentColors.map((color) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => setState(() => selectedColor = color),
                        child: AnimatedContainer(
                          duration: kThemeChangeDuration,
                          curve: Curves.bounceInOut,
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2.0),
                            border: Border.all(
                              color: color.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                              width: 2.5,
                              style: selectedColor == color
                                  ? BorderStyle.solid
                                  : BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Material(
              child: Row(children: [
                Expanded(
                  child: Slider(
                    onChanged: (v) => setState(() => fontSize = v),
                    value: fontSize,
                    min: 8,
                    max: 60,
                    divisions: 30 - 8,
                    label: '${fontSize.toInt()}',
                  ),
                ),
                Expanded(
                  child: Slider(
                    onChanged: (v) => setState(() => innerRadius = v),
                    value: innerRadius,
                    min: 0,
                    max: 20,
                    label: '${innerRadius.toInt()}',
                    divisions: 20,
                  ),
                ),
                Expanded(
                  child: Slider(
                    onChanged: (v) => setState(() => outerRadius = v),
                    value: outerRadius,
                    min: 0,
                    max: 20,
                    label: '${outerRadius.toInt()}',
                    divisions: 20,
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}






/// A custom cupertino selection with better UI fidelity.

// Custom blue color for selection handles and highlight
const Color _kCustomSelectionColor = Colors.blue;

// Read off from the output on iOS 12. This color does not vary with the
// application's theme color.
const double _kSelectionHandleOverlap = 1.5;
// Extracted from https://developer.apple.com/design/resources/.
const double _kSelectionHandleRadius = 6;

// Minimal padding from tip of the selection toolbar arrow to horizontal edges of the
// screen. Eyeballed value.
const double _kArrowScreenPadding = 26.0;

/// Draws a single text selection handle with a bar and a ball.
class _CustomCupertinoTextSelectionHandlePainter extends CustomPainter {
  const _CustomCupertinoTextSelectionHandlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const double halfStrokeWidth = 1.0;
    final Paint paint = Paint()..color = _kCustomSelectionColor;
    final Rect circle = Rect.fromCircle(
      center: const Offset(_kSelectionHandleRadius, _kSelectionHandleRadius),
      radius: _kSelectionHandleRadius,
    );
    final Rect line = Rect.fromPoints(
      const Offset(
        _kSelectionHandleRadius - halfStrokeWidth,
        2 * _kSelectionHandleRadius - _kSelectionHandleOverlap,
      ),
      Offset(_kSelectionHandleRadius + halfStrokeWidth, size.height),
    );
    final Path path = Path()
      ..addOval(circle)
      ..addRect(line);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CustomCupertinoTextSelectionHandlePainter oldPainter) => false;
}

/// Custom Cupertino styled text selection controls.
class CustomCupertinoTextSelectionControls extends TextSelectionControls {
  /// Returns the size of the Cupertino handle.
  @override
  Size getHandleSize(double textLineHeight) {
    return Size(
      _kSelectionHandleRadius * 2,
      textLineHeight + _kSelectionHandleRadius * 2 - _kSelectionHandleOverlap,
    );
  }

  /// Builder for iOS-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset selectionMidpoint,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ValueListenable<ClipboardStatus>? clipboardStatus,
      Offset? lastSecondaryTapDownPosition,
      ) {
    return CupertinoTextSelectionControlsToolbar(
      clipboardStatus: clipboardStatus,
      endpoints: endpoints,
      globalEditableRegion: globalEditableRegion,
      handleCut: canCut(delegate) ? () => handleCut(delegate) : null,
      handleCopy: canCopy(delegate) ? () => handleCopy(delegate) : null,
      handlePaste: canPaste(delegate) ? () => handlePaste(delegate) : null,
      handleSelectAll: canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
      selectionMidpoint: selectionMidpoint,
      textLineHeight: textLineHeight,
    );
  }

  /// Builder for iOS text selection edges.
  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textLineHeight, [VoidCallback? onTap]) {
    // iOS selection handles do not respond to taps.
    final Size desiredSize;
    final Widget handle;

    final Widget customPaint = CustomPaint(
      painter: _CustomCupertinoTextSelectionHandlePainter(),
    );

    // [buildHandle]'s widget is positioned at the selection cursor's bottom
    // baseline. We transform the handle such that the SizedBox is superimposed
    // on top of the text selection endpoints.
    switch (type) {
      case TextSelectionHandleType.left:
        desiredSize = getHandleSize(textLineHeight);
        handle = SizedBox.fromSize(
          size: desiredSize,
          child: customPaint,
        );
        return handle;
      case TextSelectionHandleType.right:
        desiredSize = getHandleSize(textLineHeight);
        handle = SizedBox.fromSize(
          size: desiredSize,
          child: customPaint,
        );
        return Transform(
          transform: Matrix4.identity()
            ..translate(desiredSize.width / 2, desiredSize.height / 2)
            ..rotateZ(math.pi)
            ..translate(-desiredSize.width / 2, -desiredSize.height / 2),
          child: handle,
        );
    // iOS should draw an invisible box so the handle can still receive gestures
    // on collapsed selections.
      case TextSelectionHandleType.collapsed:
        return SizedBox.fromSize(size: getHandleSize(textLineHeight));
    }
  }

  /// Gets anchor for cupertino-style text selection handles.
  ///
  /// See [TextSelectionControls.getHandleAnchor].
  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    final Size handleSize = getHandleSize(textLineHeight);

    switch (type) {
    // The circle is at the top for the left handle, and the anchor point is
    // all the way at the bottom of the line.
      case TextSelectionHandleType.left:
        return Offset(
          handleSize.width / 2,
          handleSize.height,
        );
    // The right handle is vertically flipped, and the anchor point is near
    // the top of the circle to give slight overlap.
      case TextSelectionHandleType.right:
        return Offset(
          handleSize.width / 2,
          handleSize.height - 2 * _kSelectionHandleRadius + _kSelectionHandleOverlap,
        );
    // A collapsed handle anchors itself so that it's centered.
      case TextSelectionHandleType.collapsed:
        return Offset(
          handleSize.width / 2,
          textLineHeight + (handleSize.height - textLineHeight) / 2,
        );
    }
  }
}

/// Custom text selection controls that follow iOS design conventions.
final TextSelectionControls customCupertinoTextSelectionControls =
CustomCupertinoTextSelectionControls();

/// Toolbar for Cupertino text selection controls.
class CupertinoTextSelectionControlsToolbar extends StatefulWidget {
  const CupertinoTextSelectionControlsToolbar({
    required this.clipboardStatus,
    required this.endpoints,
    required this.globalEditableRegion,
    required this.handleCopy,
    required this.handleCut,
    required this.handlePaste,
    required this.handleSelectAll,
    required this.selectionMidpoint,
    required this.textLineHeight,
  });

  final ValueListenable<ClipboardStatus>? clipboardStatus;
  final List<TextSelectionPoint> endpoints;
  final Rect globalEditableRegion;
  final VoidCallback? handleCopy;
  final VoidCallback? handleCut;
  final VoidCallback? handlePaste;
  final VoidCallback? handleSelectAll;
  final Offset selectionMidpoint;
  final double textLineHeight;

  @override
  CupertinoTextSelectionControlsToolbarState createState() => CupertinoTextSelectionControlsToolbarState();
}

class CupertinoTextSelectionControlsToolbarState extends State<CupertinoTextSelectionControlsToolbar> {
  void _onChangedClipboardStatus() {
    setState(() {
      // Inform the widget that the value of clipboardStatus has changed.
    });
  }

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus?.addListener(_onChangedClipboardStatus);
  }

  @override
  void didUpdateWidget(CupertinoTextSelectionControlsToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clipboardStatus != widget.clipboardStatus) {
      oldWidget.clipboardStatus?.removeListener(_onChangedClipboardStatus);
      widget.clipboardStatus?.addListener(_onChangedClipboardStatus);
    }
  }

  @override
  void dispose() {
    widget.clipboardStatus?.removeListener(_onChangedClipboardStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't render the menu until the state of the clipboard is known.
    if (widget.handlePaste != null && widget.clipboardStatus?.value == ClipboardStatus.unknown) {
      return const SizedBox.shrink();
    }

    assert(debugCheckHasMediaQuery(context));
    final EdgeInsets mediaQueryPadding = MediaQuery.paddingOf(context);

    // The toolbar should appear below the TextField when there is not enough
    // space above the TextField to show it, assuming there's always enough
    // space at the bottom in this case.
    final double anchorX = clampDouble(widget.selectionMidpoint.dx + widget.globalEditableRegion.left,
      _kArrowScreenPadding + mediaQueryPadding.left,
      MediaQuery.sizeOf(context).width - mediaQueryPadding.right - _kArrowScreenPadding,
    );

    final double topAmountInEditableRegion = widget.endpoints.first.point.dy - widget.textLineHeight;
    final double anchorTop = math.max(topAmountInEditableRegion, 0) + widget.globalEditableRegion.top;

    // The y-coordinate has to be calculated instead of directly quoting
    // selectionMidpoint.dy, since the caller
    // (TextSelectionOverlay._buildToolbar) does not know whether the toolbar is
    // going to be facing up or down.
    final Offset anchorAbove = Offset(
      anchorX,
      anchorTop,
    );
    final Offset anchorBelow = Offset(
      anchorX,
      widget.endpoints.last.point.dy + widget.globalEditableRegion.top,
    );

    final List<Widget> items = <Widget>[];
    final CupertinoLocalizations localizations = CupertinoLocalizations.of(context);
    final Widget onePhysicalPixelVerticalDivider =
    SizedBox(width: 1.0 / MediaQuery.devicePixelRatioOf(context));

    void addToolbarButton(
        String text,
        VoidCallback onPressed,
        ) {
      if (items.isNotEmpty) {
        items.add(onePhysicalPixelVerticalDivider);
      }

      items.add(CupertinoTextSelectionToolbarButton.text(
        onPressed: onPressed,
        text: text,
      ));
    }

    if (widget.handleCut != null) {
      addToolbarButton(localizations.cutButtonLabel, widget.handleCut!);
    }
    if (widget.handleCopy != null) {
      addToolbarButton(localizations.copyButtonLabel, widget.handleCopy!);
    }
    if (widget.handlePaste != null
        && widget.clipboardStatus?.value == ClipboardStatus.pasteable) {
      addToolbarButton(localizations.pasteButtonLabel, widget.handlePaste!);
    }
    if (widget.handleSelectAll != null) {
      addToolbarButton(localizations.selectAllButtonLabel, widget.handleSelectAll!);
    }

    // If there is no option available, build an empty widget.
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return CupertinoTextSelectionToolbar(
      anchorAbove: anchorAbove,
      anchorBelow: anchorBelow,
      children: items,
    );
  }
}