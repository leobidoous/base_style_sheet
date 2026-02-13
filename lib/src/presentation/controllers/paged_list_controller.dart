import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Durations;

class _PagedListConfig<T> {
  /// [nextPageKey] is the key to verify if is necessary
  /// make another [fetchNewItems] call.
  /// Is the key page, offset or similar
  _PagedListConfig({
    required this.pageKey,
    required this.pageSize,
    required this.nextPageKey,
    required this.pageIncrement,
    required this.forceNewFetch,
    required this.preventNewFetch,
    required this.initWithRequest,
  }) {
    _pageKey = pageKey;
    _pageSize = pageSize;
    _nextPageKey = nextPageKey;
    _pageIncrement = pageIncrement;
    _forceNewFetch = forceNewFetch;
    _preventNewFetch = preventNewFetch;
    _initWithRequest = initWithRequest;
  }

  int pageKey;
  int pageSize;
  int nextPageKey;
  int pageIncrement;
  bool forceNewFetch;
  bool preventNewFetch;
  bool initWithRequest;
  List<T> lastItems = List.empty(growable: true);

  late final int _pageKey;
  late final int _pageSize;
  late final int _nextPageKey;
  late final int _pageIncrement;
  late final bool _forceNewFetch;
  late final bool _preventNewFetch;
  late final bool _initWithRequest;

  bool get isLastFetch {
    return lastItems.isNotEmpty && lastItems.length < pageSize;
  }

  void reset() {
    lastItems.clear();
    pageKey = _pageKey;
    pageSize = _pageSize;
    nextPageKey = _nextPageKey;
    pageIncrement = _pageIncrement;
    forceNewFetch = _forceNewFetch;
    preventNewFetch = _preventNewFetch;
    initWithRequest = _initWithRequest;
  }
}

class PagedListController<E, S> extends ValueNotifier<List<S>> {
  PagedListController({
    int pageSize = 10,
    this.firstPageKey = 0,
    this.reverse = false,
    int pageIncrement = 1,
    this.searchPercent = 100,
    bool forceNewFetch = false,
    bool initWithRequest = true,
    bool preventNewFetch = false,
    this.searchDebounce = Duration.zero,
    this.onSearchChanged,
  }) : assert(searchPercent >= 0 && searchPercent <= 100),
       super(const []) {
    config = _PagedListConfig(
      nextPageKey: firstPageKey + pageIncrement,
      initWithRequest: initWithRequest,
      preventNewFetch: preventNewFetch,
      forceNewFetch: forceNewFetch,
      pageIncrement: pageIncrement,
      pageKey: firstPageKey,
      pageSize: pageSize,
    );
  }

  bool _wasDisposed = false;
  Timer? _searchDebounceTimer;
  String? _lastSearchTerm;
  final ValueNotifier<E?> _error = ValueNotifier(null);
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  /// [searchDebounce] duration to wait before executing search
  /// Set to Duration.zero to disable debounce
  final Duration searchDebounce;

  /// [onSearchChanged] callback executed when search term changes
  /// Use this to update filters externally before refresh
  final Future<void> Function(String searchTerm)? onSearchChanged;

  bool get wasDisposed => _wasDisposed;

  E? get error => _error.value;
  bool get hasError => _error.value != null;
  void setError(E value) {
    if (!_wasDisposed) {
      _loading.value = false;
      _error.value = value;
      notifyListeners();
    }
  }

  void clearError({bool update = false}) {
    if (_error.value == null) return;
    _error.value = null;
    if (update) notifyListeners();
  }

  bool get isLoading => _loading.value;
  void setLoading(bool value, {bool update = true}) {
    if (!_wasDisposed) {
      _loading.value = value;
      if (update) notifyListeners();
    }
  }

  List<S> get state => value;
  void update(List<S> state, {force = false}) {
    if (!_wasDisposed) {
      clearError();
      setLoading(false, update: false);
      if (value != state || force) {
        value = state;
        notifyListeners();
      }
    }
  }

  /// [fetchItems] is used to do a new search by new items.
  late final Future<List<S>> Function({required int pageKey, int? pageSize})
  _fetchItems;

  /// [searchPercent] is the key to be used in case of a [refresh].
  final int searchPercent;

  /// [firstPageKey] is the key page, offset or similar
  ///  to be used in case of a [refresh].
  final int firstPageKey;

  /// [config] is the [PagedListController] settings
  late final _PagedListConfig<S> config;

  /// [reverse] check if the list is inverted
  late final bool reverse;

  Future<void> refresh() async {
    if (!isLoading) {
      config.reset();
      update(List<S>.empty(growable: true));
      await fetchNewItems(pageKey: firstPageKey, pageSize: config.pageSize);
    }
  }

  /// Search with debounce
  /// [searchTerm] the term to search
  /// [immediate] if true, executes immediately without debounce
  Future<void> search(String searchTerm, {bool immediate = false}) async {
    _lastSearchTerm = searchTerm;

    // Cancel previous debounce timer
    _searchDebounceTimer?.cancel();

    // Execute immediately if requested or debounce is zero
    if (immediate || searchDebounce == Duration.zero) {
      await _executeSearch(searchTerm);
      return;
    }

    // Schedule search with debounce
    _searchDebounceTimer = Timer(searchDebounce, () async {
      // Only execute if this is still the last search term
      if (_lastSearchTerm == searchTerm) {
        await _executeSearch(searchTerm);
      }
    });
  }

  Future<void> _executeSearch(String searchTerm) async {
    // Call external callback if provided
    if (onSearchChanged != null) {
      await onSearchChanged!(searchTerm);
    }

    // Reset and refresh
    config.reset();
    update(List<S>.empty(growable: true));
    await fetchNewItems(pageKey: firstPageKey, pageSize: config.pageSize);
  }

  void setListener(
    Future<List<S>> Function({required int pageKey, int? pageSize}) fetchItems,
  ) => _fetchItems = fetchItems;

  Future<void> fetchNewItems({
    bool forceFetch = false,
    required int pageKey,
    int? pageSize,
  }) async {
    if (((state.isNotEmpty && config.preventNewFetch) ||
            (config.nextPageKey + config.pageIncrement == pageKey) ||
            (config.isLastFetch && !config.forceNewFetch) ||
            isLoading) &&
        !forceFetch) {
      return;
    }

    config.pageKey = pageKey;
    config.pageSize = pageSize ?? config.pageSize;
    config.nextPageKey = config.pageKey + config.pageIncrement;
    clearError();
    setLoading(true);
    await _fetchItems(pageKey: pageKey, pageSize: pageSize ?? config.pageSize)
        .then((value) async {
          config.lastItems = value;
          if (value.isNotEmpty) {
            final newValues = value.where((v) => !state.contains(v)).toList();
            await Future.delayed(Durations.medium1);
            update(state..addAll(newValues));
          }
        })
        .catchError((error) {
          setError(error);
        })
        .whenComplete(() => setLoading(false));
  }

  Future<void> fetchItemsPerPage({required int pageKey, int? pageSize}) async {
    update([]);
    setLoading(true);
    config.pageKey = pageKey;
    config.pageSize = pageSize ?? config.pageSize;
    config.nextPageKey = config.pageKey + config.pageIncrement;
    await _fetchItems(pageKey: pageKey, pageSize: pageSize ?? config.pageSize)
        .then((value) async {
          config.lastItems = value;
          if (value.isNotEmpty) {
            final newValues = value.where((v) => !state.contains(v)).toList();
            await Future.delayed(Durations.medium1);
            update(state..addAll(newValues));
          }
        })
        .catchError((error) {
          setError(error);
        })
        .whenComplete(() => setLoading(false));
  }

  @override
  void dispose() {
    try {
      if (_wasDisposed) {
        debugPrint('$runtimeType already disposed');
        return;
      }
      debugPrint('$runtimeType has been disposed');
      _searchDebounceTimer?.cancel();
      _error.dispose();
      _loading.dispose();
      _wasDisposed = true;
    } catch (exception) {
      debugPrint('$runtimeType already disposed');
    }
    super.dispose();
  }
}
