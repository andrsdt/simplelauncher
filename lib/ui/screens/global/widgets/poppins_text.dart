import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoppinsText extends StatelessWidget {
  String text;
  Color color;
  double size;
  double letterSpacing;
  double height = 1;
  FontWeight weight = FontWeight.normal;

  PoppinsText(this.text,
      {this.color, this.size, this.weight, this.letterSpacing, this.height});

  @override
  Widget build(BuildContext context) {
    return Text(this.text,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: this.color,
                fontSize: this.size,
                fontWeight: this.weight,
                letterSpacing: this.letterSpacing,
                height: this.height)));
  }
}
