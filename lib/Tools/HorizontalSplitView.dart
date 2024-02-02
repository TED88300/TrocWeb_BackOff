import 'package:flutter/material.dart';



class HorizontalSplitView extends StatefulWidget {
  final Widget top;
  final Widget bottom;
  final double ratio;

  const HorizontalSplitView(
      { required this.top, required this.bottom, this.ratio = 0.5})
      : assert(top != null),
        assert(bottom != null),
        assert(ratio >= 0),
        assert(ratio <= 1);

  @override
  _HorizontalSplitViewState createState() => _HorizontalSplitViewState();
}

class _HorizontalSplitViewState extends State<HorizontalSplitView> {
  final _dividerHeight = 16.0;


  double _ratio = 0;
  double _maxHeight = 0;

  get _height1 => _ratio * _maxHeight;

  get _height2 => (1 - _ratio) * _maxHeight;

  @override
  void initState() {
    super.initState();
    _ratio = widget.ratio;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      assert(_ratio <= 1);
      assert(_ratio >= 0);
      if (_maxHeight == null) _maxHeight = constraints.maxHeight - _dividerHeight;
      if (_maxHeight != constraints.maxHeight) {
        _maxHeight = constraints.maxHeight - _dividerHeight;
      }

      return SizedBox(
        height: constraints.maxHeight,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: _height1,
              child: widget.top,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: SizedBox(
                height: _dividerHeight,
                width: constraints.maxHeight,
                child: RotationTransition(
                  child: Icon(Icons.drag_handle),
                  turns: AlwaysStoppedAnimation(0.25),
                ),
              ),
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  _ratio += details.delta.dy / _maxHeight;
                  if (_ratio > 1)
                    _ratio = 1;
                  else if (_ratio < 0.0) _ratio = 0.0;
                });
              },
            ),
            SizedBox(
              height: _height2,
              child: widget.bottom,
            ),
          ],
        ),
      );
    });
  }
}