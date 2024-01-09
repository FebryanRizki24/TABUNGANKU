import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'TabunganKu',
          style: GoogleFonts.poppins(fontSize: 35, fontWeight: FontWeight.w700),
        ),
        Text(
          'Makes Dream Come True With TabunganKu',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
