import 'package:demo/screens/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        final HomeViewModel homeViewModel = ref.watch(homeViewModelProvider);
        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
        );
      },
    );
  }
}
