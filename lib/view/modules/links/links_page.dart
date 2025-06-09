import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/controllers/link_controller.dart';
import 'package:linkable/models/link_model.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/view/shared/custom_text_field.dart';
import 'package:linkable/view/modules/links/link_detailed_page.dart';
import 'package:intl/intl.dart';

class LinksPage extends StatelessWidget {
  LinksPage({super.key});
  
  final LinkController controller = Get.put(LinkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTagFilter(),
            Expanded(child: _buildLinksContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LightColors.surface,
        border: Border(
          bottom: BorderSide(color: LightColors.border, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sticky_note_2_outlined,
                size: 32,
                color: LightColors.primary,
              ),
              const SizedBox(width: 12),
              const Text(
                'My Notes',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: LightColors.primaryText,
                ),
              ),
              const Spacer(),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: LightColors.muted,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${controller.filteredLinks.length} notes',
                  style: const TextStyle(
                    fontSize: 14,
                    color: LightColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => _showAddNoteBottomSheet(context),
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(

                  foregroundColor: LightColors.primary,
                ),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: LightColors.border),
              color: LightColors.input,
            ),
            child: Obx(() => TextField(
              onChanged: controller.searchLinks,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search, color: LightColors.mutedText),
                suffixIcon: controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: LightColors.mutedText),
                      onPressed: controller.clearSearchFilter,
                    )
                  : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(13),
                hintStyle: const TextStyle(color: LightColors.mutedText),
              ),
              // Use the controller's search query as the initial value
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: controller.searchQuery.value,
                  selection: TextSelection.collapsed(
                    offset: controller.searchQuery.value.length,
                  ),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildTagFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Obx(() {
        final tags = ['All', ...controller.getUniqueTags()];
        final selectedTag = controller.selectedTag.value;
        
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: tags.length,
          itemBuilder: (context, index) {
            final tag = tags[index];
            final isSelected = (tag == 'All' && selectedTag.isEmpty) || selectedTag == tag;
            
            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  if (tag == 'All') {
                    controller.filterLinksByTag('');
                  } else {
                    controller.filterLinksByTag(selected ? tag : '');
                  }
                },
                backgroundColor: Colors.white,
                selectedColor: LightColors.primary[200],
                checkmarkColor: LightColors.primary,
                side: BorderSide(
                  color: isSelected ? LightColors.primary : LightColors.border,
                  width: 1,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? LightColors.primary : LightColors.secondaryText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                elevation: 0,
                pressElevation: 1,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildLinksContent() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(LightColors.primary),
          ),
        );
      }

      if (controller.filteredLinks.isEmpty) {
        return _buildEmptyState();
      }

      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: controller.filteredLinks.length,
        itemBuilder: (context, index) {
          final link = controller.filteredLinks[index];
          return _buildNoteCard(link);
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: LightColors.muted,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                controller.hasActiveFilters ? Icons.search_off : Icons.note_add,
                size: 60,
                color: LightColors.mutedText,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              controller.hasActiveFilters ? 'No notes found' : 'No notes yet',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: LightColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.hasActiveFilters 
                ? 'Try adjusting your search or filters'
                : 'Start building your personal note collection',
              style: const TextStyle(
                fontSize: 16,
                color: LightColors.secondaryText,
              ),
            ),
            const SizedBox(height: 32),
            if (controller.hasActiveFilters)
              Center(
                child: SizedBox(
                  width: 160,
                  child: ElevatedButton.icon(
                    onPressed: controller.clearFilters,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LightColors.secondaryText,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              )
            else
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddNoteBottomSheet(Get.context!),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Your First Note'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LightColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(LinkModel link) {
    return GestureDetector(
      onTap: () {
        Navigator.of(Get.context!).push(
          MaterialPageRoute(
            builder: (context) => LinkDetailedPage(link: link),
          ),
        );
      },
      child: Card(
        elevation: 0,
        color: LightColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: LightColors.border, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                link.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: LightColors.primaryText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  link.summary,
                  style: const TextStyle(
                    fontSize: 13,
                    color: LightColors.secondaryText,
                    height: 1.4,
                  ),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (link.createdAt != null) ...[
                const SizedBox(height: 12),
                Text(
                  DateFormat('MMM dd, yyyy • HH:mm').format(link.createdAt!),
                  style: const TextStyle(
                    fontSize: 11,
                    color: LightColors.mutedText,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteBottomSheet(BuildContext context, {LinkModel? link}) {
    final titleController = TextEditingController(text: link?.title ?? '');
    final summaryController = TextEditingController(text: link?.summary ?? '');
    final tagController = TextEditingController(text: link?.tag ?? '');
    final websiteController = TextEditingController(text: link?.website ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: LightColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: LightColors.mutedText,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Text(
                      link == null ? 'Add New Note' : 'Edit Note',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: LightColors.primaryText,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: LightColors.muted,
                        foregroundColor: LightColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              // Form content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField(
                        'Title',
                        CustomTextField(
                          hintText: 'Enter note title...',
                          controller: titleController,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        'Content',
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: LightColors.border),
                            color: LightColors.input,
                          ),
                          child: TextField(
                            controller: summaryController,
                            maxLines: 8,
                            decoration: const InputDecoration(
                              hintText: 'Write your note content here...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                              hintStyle: TextStyle(color: LightColors.mutedText),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: LightColors.primaryText,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        'Tag',
                        CustomTextField(
                          hintText: 'e.g. work, personal, ideas',
                          controller: tagController,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        'Reference URL (Optional)',
                        CustomTextField(
                          hintText: 'https://example.com',
                          controller: websiteController,
                          keyboardType: TextInputType.url,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value 
                            ? null 
                            : () async {
                                final success = await controller.handleFormSubmit(
                                  title: titleController.text,
                                  summary: summaryController.text,
                                  tag: tagController.text,
                                  website: websiteController.text,
                                  existingLink: link,
                                );
                                
                                if (success && context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LightColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                link == null ? 'Add Note' : 'Update Note',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        )),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: LightColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
