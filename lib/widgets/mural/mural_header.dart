import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/mural_model.dart';

class MuralHeader extends StatelessWidget {
  final Mural mural;

  const MuralHeader({
    super.key,
    required this.mural,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy - HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo.webp',
          width: 50,
          height: 50,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GUIDO POWER ACADEMIA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _formatDate(mural.updatedAt.isAfter(mural.createdAt)
                  ? mural.updatedAt
                  : mural.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
