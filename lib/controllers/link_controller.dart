import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkable/models/link_model.dart';
import 'package:linkable/services/auth_services.dart';
import 'package:flutter/material.dart';

class LinkController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthServices _authServices = Get.find<AuthServices>();
  
  // Observable lists for different link categories
  final RxList<LinkModel> userLinks = <LinkModel>[].obs;
  final RxList<LinkModel> filteredLinks = <LinkModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isConnected = true.obs; // Track connection status
  final RxString selectedTag = ''.obs;
  final RxString searchQuery = ''.obs;
  
  // Stream subscription for the listener
  late final Stream<QuerySnapshot> _linksStream;

  @override
  void onInit() {
    super.onInit();
    // Set up real-time listener for user's links
    setupFirestoreListener();
  }

  /// Sets up a real-time listener for the current user's links
  void setupFirestoreListener() {
    if (_authServices.user.value?.uid == null) {
      debugPrint('No authenticated user found for Firestore listener');
      return;
    }

    final userId = _authServices.user.value!.uid;
    debugPrint('Setting up Firestore listener for user: $userId');

    // Create the stream
    _linksStream = _firestore
        .collection('links')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();

    // Listen to the stream
    _linksStream.listen(
      (QuerySnapshot snapshot) {
        try {
          isConnected.value = true;
          final updatedLinks = snapshot.docs.map((doc) {
            return LinkModel.fromFirestore(doc);
          }).toList();

          userLinks.value = updatedLinks;
          // Apply current filters when data updates
          _applyFilters();
          debugPrint('🔄 Real-time update: ${userLinks.length} links loaded');
        } catch (e) {
          debugPrint('❌ Error processing links snapshot: $e');
          isConnected.value = false;
        }
      },
      onError: (error) {
        debugPrint('❌ Links listener error: $error');
        isConnected.value = false;
      },
      cancelOnError: false,
    );
  }

  /// Fetches all links for the current user (one-time fetch)
  Future<List<LinkModel>> fetchUserLinks() async {
    if (_authServices.user.value?.uid == null) {
      throw Exception('No authenticated user found');
    }

    isLoading.value = true;
    
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('links')
          .where('userId', isEqualTo: _authServices.user.value!.uid)
          .orderBy('createdAt', descending: true)
          .get();

      final links = snapshot.docs.map((doc) {
        return LinkModel.fromFirestore(doc);
      }).toList();

      userLinks.value = links;
      _applyFilters();
      
      return links;
    } catch (e) {
      debugPrint('Error fetching user links: $e');
      throw Exception('Failed to fetch links: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches links by tag for the current user
  Future<List<LinkModel>> fetchLinksByTag(String tag) async {
    if (_authServices.user.value?.uid == null) {
      throw Exception('No authenticated user found');
    }

    isLoading.value = true;
    
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('links')
          .where('userId', isEqualTo: _authServices.user.value!.uid)
          .where('tag', isEqualTo: tag)
          .orderBy('createdAt', descending: true)
          .get();

      final links = snapshot.docs.map((doc) {
        return LinkModel.fromFirestore(doc);
      }).toList();

      return links;
    } catch (e) {
      debugPrint('Error fetching links by tag: $e');
      throw Exception('Failed to fetch links by tag: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Main filtering method that combines search and tag filtering
  void _applyFilters() {
    List<LinkModel> result = List.from(userLinks);
    
    // Apply tag filter first
    if (selectedTag.value.isNotEmpty) {
      result = result.where((link) => 
        link.tag.toLowerCase() == selectedTag.value.toLowerCase()
      ).toList();
    }
    
    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((link) =>
        link.title.toLowerCase().contains(query) ||
        link.summary.toLowerCase().contains(query) ||
        link.website.toLowerCase().contains(query) ||
        link.tag.toLowerCase().contains(query)
      ).toList();
    }
    
    filteredLinks.value = result;
    debugPrint('Applied filters - Tag: "${selectedTag.value}", Search: "${searchQuery.value}", Results: ${result.length}');
  }

  /// Filters the current links by tag
  void filterLinksByTag(String tag) {
    selectedTag.value = tag;
    _applyFilters();
    debugPrint('Filter by tag: $tag');
  }

  /// Searches links by query across multiple fields
  void searchLinks(String query) {
    searchQuery.value = query;
    _applyFilters();
    debugPrint('Search query: $query');
  }

  /// Clears all filters
  void clearFilters() {
    selectedTag.value = '';
    searchQuery.value = '';
    _applyFilters();
    debugPrint('Cleared all filters');
  }

  /// Clears only the tag filter
  void clearTagFilter() {
    selectedTag.value = '';
    _applyFilters();
    debugPrint('Cleared tag filter');
  }

  /// Clears only the search filter
  void clearSearchFilter() {
    searchQuery.value = '';
    _applyFilters();
    debugPrint('Cleared search filter');
  }

  /// Advanced search with multiple criteria
  void advancedSearch({
    String? titleQuery,
    String? summaryQuery,
    String? tag,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    List<LinkModel> result = List.from(userLinks);
    
    // Filter by title
    if (titleQuery != null && titleQuery.isNotEmpty) {
      final query = titleQuery.toLowerCase();
      result = result.where((link) =>
        link.title.toLowerCase().contains(query)
      ).toList();
    }
    
    // Filter by summary
    if (summaryQuery != null && summaryQuery.isNotEmpty) {
      final query = summaryQuery.toLowerCase();
      result = result.where((link) =>
        link.summary.toLowerCase().contains(query)
      ).toList();
    }
    
    // Filter by tag
    if (tag != null && tag.isNotEmpty) {
      result = result.where((link) =>
        link.tag.toLowerCase() == tag.toLowerCase()
      ).toList();
    }
    
    // Filter by date range
    if (fromDate != null) {
      result = result.where((link) =>
        link.createdAt != null && link.createdAt!.isAfter(fromDate)
      ).toList();
    }
    
    if (toDate != null) {
      result = result.where((link) =>
        link.createdAt != null && link.createdAt!.isBefore(toDate)
      ).toList();
    }
    
    filteredLinks.value = result;
    debugPrint('Advanced search results: ${result.length}');
  }

  /// Gets filtered links by multiple tags
  List<LinkModel> getFilteredLinksByTags(List<String> tags) {
    if (tags.isEmpty) return userLinks.toList();
    
    return userLinks.where((link) =>
      tags.any((tag) => link.tag.toLowerCase() == tag.toLowerCase())
    ).toList();
  }

  /// Sorts filtered links by different criteria
  void sortFilteredLinks(String sortBy, {bool ascending = true}) {
    final links = List<LinkModel>.from(filteredLinks);
    
    switch (sortBy.toLowerCase()) {
      case 'title':
        links.sort((a, b) => ascending 
          ? a.title.compareTo(b.title)
          : b.title.compareTo(a.title));
        break;
      case 'date':
      case 'created':
        links.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return ascending ? -1 : 1;
          if (b.createdAt == null) return ascending ? 1 : -1;
          return ascending 
            ? a.createdAt!.compareTo(b.createdAt!)
            : b.createdAt!.compareTo(a.createdAt!);
        });
        break;
      case 'tag':
        links.sort((a, b) => ascending 
          ? a.tag.compareTo(b.tag)
          : b.tag.compareTo(a.tag));
        break;
      case 'summary':
      case 'content':
        links.sort((a, b) => ascending 
          ? a.summary.compareTo(b.summary)
          : b.summary.compareTo(a.summary));
        break;
    }
    
    filteredLinks.value = links;
    debugPrint('Sorted by $sortBy (${ascending ? 'asc' : 'desc'})');
  }

  /// Adds a new link to Firestore
  Future<void> addLink(LinkModel link) async {
    if (_authServices.user.value?.uid == null) {
      throw Exception('No authenticated user found');
    }

    isLoading.value = true;
    
    try {
      final linkWithUserId = link.copyWith(
        userId: _authServices.user.value!.uid,
      );

      await _firestore.collection('links').add(linkWithUserId.toMap());
      debugPrint('Link added successfully');
    } catch (e) {
      debugPrint('Error adding link: $e');
      throw Exception('Failed to add link: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates an existing link
  Future<void> updateLink(LinkModel link) async {
    if (link.id == null) {
      throw Exception('Link ID is required for update');
    }

    isLoading.value = true;
    
    try {
      await _firestore
          .collection('links')
          .doc(link.id)
          .update(link.toMap());
      debugPrint('Link updated successfully');
    } catch (e) {
      debugPrint('Error updating link: $e');
      throw Exception('Failed to update link: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Reconnects the Firestore listener (useful if connection was lost)
  void reconnectListener() {
    debugPrint('🔄 Manually reconnecting Firestore listener');
    setupFirestoreListener();
  }

  /// Gets the connection status
  bool get isFirestoreConnected => isConnected.value;

  /// Handles form submission for adding/updating links
  Future<bool> handleFormSubmit({
    required String title,
    required String summary,
    required String tag,
    String? website,
    LinkModel? existingLink,
  }) async {
    try {
      // Validate required fields
      if (title.trim().isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter a title',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade700,
        );
        return false;
      }

      if (summary.trim().isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter note content',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade700,
        );
        return false;
      }

      if (tag.trim().isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter a tag',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade700,
        );
        return false;
      }

      // Create the link model
      final linkModel = LinkModel(
        id: existingLink?.id,
        title: title.trim(),
        summary: summary.trim(),
        tag: tag.trim(),
        website: website?.trim().isEmpty == true 
            ? 'https://example.com' 
            : website?.trim() ?? 'https://example.com',
      );

      // Add or update the link - the real-time listener will automatically update the UI
      if (existingLink == null) {
        await addLink(linkModel);
        Get.snackbar(
          'Success',
          '📝 Note added successfully! Updates are live.',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        );
        debugPrint('✅ New note added - real-time listener will update UI');
      } else {
        await updateLink(linkModel);
        Get.snackbar(
          'Success',
          '✏️ Note updated successfully! Changes are live.',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        );
        debugPrint('✅ Note updated - real-time listener will update UI');
      }

      return true;
    } catch (e) {
      debugPrint('❌ Error in handleFormSubmit: $e');
      Get.snackbar(
        'Error',
        'Failed to save note: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red.shade700,
      );
      return false;
    }
  }

  /// Deletes a link
  Future<void> deleteLink(String linkId) async {
    isLoading.value = true;
    
    try {
      await _firestore.collection('links').doc(linkId).delete();
      debugPrint('Link deleted successfully');
    } catch (e) {
      debugPrint('Error deleting link: $e');
      throw Exception('Failed to delete link: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Gets unique tags from user's links
  List<String> getUniqueTags() {
    final tags = userLinks.map((link) => link.tag).toSet().toList();
    tags.sort();
    return tags;
  }

  /// Gets links count by tag
  Map<String, int> getLinkCountByTag() {
    final tagCounts = <String, int>{};
    
    for (final link in userLinks) {
      tagCounts[link.tag] = (tagCounts[link.tag] ?? 0) + 1;
    }
    
    return tagCounts;
  }

  /// Gets filtered links count by tag
  Map<String, int> getFilteredLinkCountByTag() {
    final tagCounts = <String, int>{};
    
    for (final link in filteredLinks) {
      tagCounts[link.tag] = (tagCounts[link.tag] ?? 0) + 1;
    }
    
    return tagCounts;
  }

  /// Checks if any filters are active
  bool get hasActiveFilters => selectedTag.value.isNotEmpty || searchQuery.value.isNotEmpty;

  /// Gets the current filter status
  Map<String, dynamic> get filterStatus => {
    'selectedTag': selectedTag.value,
    'searchQuery': searchQuery.value,
    'totalLinks': userLinks.length,
    'filteredCount': filteredLinks.length,
    'hasFilters': hasActiveFilters,
  };

  /// Gets related notes by tag (excluding the current note)
  List<LinkModel> getRelatedNotesByTag(String tag, String? excludeId) {
    return userLinks.where((link) => 
      link.tag.toLowerCase() == tag.toLowerCase() && 
      link.id != excludeId
    ).toList();
  }

  /// Gets related notes by tag from filtered list (excluding the current note)
  List<LinkModel> getRelatedNotesFromFiltered(String tag, String? excludeId) {
    return filteredLinks.where((link) => 
      link.tag.toLowerCase() == tag.toLowerCase() && 
      link.id != excludeId
    ).toList();
  }

  /// Clears all local data (useful for logout)
  void clearData() {
    userLinks.clear();
    filteredLinks.clear();
    selectedTag.value = '';
    searchQuery.value = '';
    isLoading.value = false;
    debugPrint('Cleared all controller data');
  }
}