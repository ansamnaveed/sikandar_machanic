import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  double mainWidth;
  double mainHeight;
  double currentValue;
  ToggleButton({
    Key? key,
    this.mainHeight = 40,
    this.mainWidth = 130,
    required this.currentValue,
  }) : super(key: key);

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  double maleAlign = -1;
  double femaleAlign = 1;
  Color selectedColor = Colors.white;
  Color normalColor = Color.fromRGBO(48, 60, 66, 1);
  Color? maleColor;
  Color? femaleColor;
  @override
  void initState() {
    widget.currentValue = maleAlign;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.mainWidth,
        height: widget.mainHeight,
        decoration: BoxDecoration(
          color: Color.fromRGBO(
            204,
            213,
            221,
            1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(widget.currentValue, 0),
              duration: Duration(
                milliseconds: 300,
              ),
              child: Container(
                width: widget.mainWidth * 0.5,
                height: widget.mainHeight,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 112, 255, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.currentValue = maleAlign;
                  maleColor = selectedColor;
                  femaleColor = normalColor;
                });
              },
              child: Align(
                alignment: Alignment(-1, 0),
                child: Container(
                  width: widget.mainWidth * 0.5,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage(
                      'assets/icons/male.png',
                    ),
                    color: maleColor,
                    width: 22,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.currentValue = femaleAlign;
                  femaleColor = selectedColor;
                  maleColor = normalColor;
                });
              },
              child: Align(
                alignment: Alignment(1, 0),
                child: Container(
                  width: widget.mainWidth * 0.5,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage(
                      'assets/icons/female.png',
                    ),
                    color: femaleColor,
                    width: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
