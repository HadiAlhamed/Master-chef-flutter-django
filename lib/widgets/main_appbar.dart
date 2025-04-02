import 'package:flutter/material.dart';

class MainAppBar extends AppBar {
  MainAppBar({super.key})
      : super(
          actions: [
            // Your custom icon button
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {},
            ),
          ],
        );
}
