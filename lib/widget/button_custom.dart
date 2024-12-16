import 'package:flutter/material.dart';
import 'package:syth_hotel/config/app_color.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom(
      {super.key, required this.label, required this.onTap, this.isExpand});
  final String label;
  final Function onTap;
  final bool? isExpand;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, 0.7),
            child: Container(
              width: isExpand == true ? double.infinity : null,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: AppColor.primary,
                      blurRadius: 20,
                      offset: Offset(0, 5)),
                ],
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Berguna untuk memberikan tampilan efek pada InkWell ketika diklik
          Align(
            child: Material(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => onTap(),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: isExpand == true ? double.infinity : null,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 12,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
