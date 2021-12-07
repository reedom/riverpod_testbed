import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:riverpod_testbed/testbed/controllers/provider_state_controller.dart';

class ProviderStateTile extends StatelessWidget {
  const ProviderStateTile({required this.label, required this.state, Key? key})
      : super(key: key);

  final String label;
  final ProviderState state;

  static const _kMonoFontStyle = TextStyle(
    fontFeatures: [FontFeature.tabularFigures()],
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('value:'),
                  Text('created:'),
                  Text('disposed:'),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${state.value}', style: _kMonoFontStyle),
                  Text('${state.createdTimes}', style: _kMonoFontStyle),
                  Text('${state.disposedTimes}', style: _kMonoFontStyle),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
