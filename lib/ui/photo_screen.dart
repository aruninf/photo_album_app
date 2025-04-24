import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_album_app/ui/photo_grid.dart';
import '../../logic/cubit/photo_cubit.dart';
import '../../logic/cubit/photo_state.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen>
    with AutomaticKeepAliveClientMixin<PhotoScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true; // Keeps widget alive in memory

  @override
  void initState() {
    super.initState();
    final cubit = context.read<PhotoCubit>();
    // Only fetch if not already loaded
    if (cubit.state is! PhotoLoaded && cubit.state is! PhotoLoading) {
      cubit.fetchPhotos();
    }
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<PhotoCubit>().fetchPhotos();
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<PhotoCubit>().refreshPhotos(_searchController.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important for AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Album', style: theme.textTheme.titleLarge),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            context.read<PhotoCubit>().refreshPhotos(_searchController.text),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _onSearchChanged(),
                decoration: InputDecoration(
                  hintText: 'Search photos...',
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<PhotoCubit, PhotoState>(
                buildWhen: (previous, current) =>
                current is! PhotoLoading || current is PhotoLoaded,
                builder: (context, state) {
                  if (state is PhotoLoading && state is! PhotoLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PhotoLoaded) {
                    return PhotoGrid(
                      photos: state.photos,
                      scrollController: _scrollController,
                      hasMore: state.hasMore,
                    );
                  } else if (state is PhotoError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

