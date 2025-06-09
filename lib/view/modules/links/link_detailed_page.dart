import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/controllers/link_controller.dart';
import 'package:linkable/models/link_model.dart';
import 'package:linkable/routes/app_routes.dart';
import 'package:linkable/utils/app_assets.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/view/shared/custom_text_field.dart';
import 'package:linkable/view/modules/main/share_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:linkable/controllers/home_controller.dart';

class LinkDetailedPage extends StatefulWidget {
  final LinkModel link;

  const LinkDetailedPage({super.key, required this.link});

  @override
  State<LinkDetailedPage> createState() => _LinkDetailedPageState();
}

class _LinkDetailedPageState extends State<LinkDetailedPage> {
  final LinkController controller = Get.find<LinkController>();
  late TextEditingController titleController;
  late TextEditingController summaryController;
  late TextEditingController tagController;
  late TextEditingController websiteController;
  
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.link.title);
    summaryController = TextEditingController(text: widget.link.summary);
    tagController = TextEditingController(text: widget.link.tag);
    websiteController = TextEditingController(text: widget.link.website);
  }

  @override
  void dispose() {
    titleController.dispose();
    summaryController.dispose();
    tagController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildContent(),
                      const SizedBox(height: 32),
                      _buildMetadata(),
                      if (widget.link.website.isNotEmpty && 
                          widget.link.website != 'https://example.com') ...[
                        const SizedBox(height: 24),
                        _buildReferenceUrl(),
                      ],
                      if (widget.link.scrapedLinks != null && 
                          widget.link.scrapedLinks!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildScrapedLinks(),
                      ],
                      const SizedBox(height: 32),
                      _buildRelatedNotes(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: LightColors.surface,
        border: Border(
          bottom: BorderSide(color: LightColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              foregroundColor: LightColors.primaryText,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isEditing ? 'Editing Note' : 'Note Details',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: LightColors.primaryText,
              ),
            ),
          ),
          if (!isEditing) ...[
            IconButton(
              onPressed: _showDeleteConfirmation,
              icon: const Icon(Icons.delete_outline),
              style: IconButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              tooltip: 'Delete Note',
            ),
            IconButton(
              onPressed: _shareNote,
              icon: const Icon(Icons.qr_code),
              style: IconButton.styleFrom(
                foregroundColor: LightColors.primaryText,
              ),
              tooltip: 'Share Link',
            ),
            IconButton(
              onPressed: _showNotionComingSoon,
              icon: Image.asset(
                AppAssets.notionLogo,
                width: 24,
                height: 24,
              ),
              style: IconButton.styleFrom(
                foregroundColor: LightColors.primaryText,
              ),
              tooltip: 'Add to Notion',
            ),
            // IconButton(
            //   onPressed: () => setState(() => isEditing = true),
            //   icon: const Icon(Icons.edit),
            //   style: IconButton.styleFrom(
            //     foregroundColor: LightColors.primaryText,
            //   ),
            //   tooltip: 'Edit Note',
            // ),
          ] else ...[
            TextButton(
              onPressed: _cancelEdit,
              child: const Text(
                'Cancel',
                style: TextStyle(color: LightColors.secondaryText),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: LightColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Save'),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: LightColors.accent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: LightColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: LightColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isEditing ? tagController.text : widget.link.tag,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: LightColors.primaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Title
        isEditing
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: LightColors.border),
                  color: LightColors.input,
                ),
                child: TextField(
                  controller: titleController,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: LightColors.primaryText,
                    height: 1.2,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Note title...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintStyle: TextStyle(color: LightColors.mutedText),
                  ),
                  maxLines: null,
                ),
              )
            : SelectableText(
                widget.link.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: LightColors.primaryText,
                  height: 1.2,
                ),
              ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Content',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: LightColors.secondaryText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        isEditing
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: LightColors.border),
                  color: LightColors.input,
                ),
                child: TextField(
                  controller: summaryController,
                  maxLines: null,
                  minLines: 8,
                  style: const TextStyle(
                    fontSize: 16,
                    color: LightColors.primaryText,
                    height: 1.6,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Write your note content here...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintStyle: TextStyle(color: LightColors.mutedText),
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: LightColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: LightColors.border, width: 0.5),
                ),
                child: SelectableText(
                  widget.link.summary,
                  style: const TextStyle(
                    fontSize: 16,
                    color: LightColors.primaryText,
                    height: 1.6,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildMetadata() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LightColors.muted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LightColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          _buildMetadataRow(
            Icons.web,
            'Website',
            isEditing
                ? Container(
                    width: 200,
                    child: CustomTextField(
                      controller: tagController,
                      hintText: 'Enter tag...',
                    ),
                  )
                : Text(
                    widget.link.webPageName ?? 'Not Specified',
                    style: const TextStyle(
                      color: LightColors.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
          if (widget.link.createdAt != null) ...[
            const SizedBox(height: 12),
            _buildMetadataRow(
              Icons.access_time,
              'Created',
              Text(
                DateFormat('EEEE, MMMM dd, yyyy • HH:mm').format(widget.link.createdAt!),
                style: const TextStyle(
                  color: LightColors.secondaryText,
                ),
              ),
            ),
          ],
          if (isEditing) ...[
            const SizedBox(height: 12),
            _buildMetadataRow(
              Icons.link,
              'Reference URL',
              Container(
                width: 300,
                child: CustomTextField(
                  controller: websiteController,
                  hintText: 'https://example.com',
                  keyboardType: TextInputType.url,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetadataRow(IconData icon, String label, Widget value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: LightColors.mutedText),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: LightColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: value),
      ],
    );
  }

  Widget _buildReferenceUrl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reference',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: LightColors.secondaryText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: LightColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: LightColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: LightColors.muted,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.link,
                  size: 16,
                  color: LightColors.primaryText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reference URL',
                      style: TextStyle(
                        fontSize: 12,
                        color: LightColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.link.website,
                      style: const TextStyle(
                        fontSize: 14,
                        color: LightColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _launchUrl(widget.link.website),
                icon: const Icon(Icons.open_in_new),
                style: IconButton.styleFrom(
                  foregroundColor: LightColors.secondaryText,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(32, 32),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScrapedLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scraped Links',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: LightColors.secondaryText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: LightColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: LightColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Found ${widget.link.scrapedLinks!.length} related links',
                style: const TextStyle(
                  fontSize: 12,
                  color: LightColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: widget.link.scrapedLinks!.map((link) {
                  // Extract domain from URL for display
                  String displayText = link;
                  
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _navigateToHomeWithLink(link),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: LightColors.accent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: LightColors.border),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.link,
                                size: 16,
                                color: LightColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  displayText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: LightColors.primaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: LightColors.mutedText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      String domain = uri.host;
      
      // Remove 'www.' if present
      if (domain.startsWith('www.')) {
        domain = domain.substring(4);
      }
      
      // Limit length for display
      if (domain.length > 25) {
        domain = '${domain.substring(0, 22)}...';
      }
      
      return domain;
    } catch (e) {
      // If URL parsing fails, return a truncated version of the original
      if (url.length > 25) {
        return '${url.substring(0, 22)}...';
      }
      return url;
    }
  }

  void _navigateToHomeWithLink(String link) {
    // Get the home controller and set the link
    final homeController = Get.find<HomeController>();
    homeController.linkInput.text = link;
    
    // Navigate to home page and clear navigation stack to prevent controller conflicts
    Get.offAllNamed(AppRoutes.mainPage);

    
    
    Get.snackbar(
      'Link Added',
      'Scraped link has been added to the input field',
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green.shade700,
      duration: const Duration(seconds: 2),
    );
  }

  Widget _buildRelatedNotes() {
    return Obx(() {
      final relatedNotes = controller.getRelatedNotesByTag(
        widget.link.tag, 
        widget.link.id
      );

      if (relatedNotes.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: LightColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Related Notes',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: LightColors.primaryText,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: LightColors.accent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: LightColors.border),
                ),
                child: Text(
                  '${relatedNotes.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: LightColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const SizedBox(height: 16),
          ...relatedNotes.map((note) => _buildRelatedNoteCard(note)),
        ],
      );
    });
  }

  Widget _buildRelatedNoteCard(LinkModel note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: LightColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightColors.border, width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LinkDetailedPage(link: note),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: LightColors.primaryText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  note.summary,
                  style: const TextStyle(
                    fontSize: 14,
                    color: LightColors.secondaryText,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (note.createdAt != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 14,
                        color: LightColors.mutedText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('MMM dd, yyyy').format(note.createdAt!),
                        style: const TextStyle(
                          fontSize: 12,
                          color: LightColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
      // Reset controllers to original values
      titleController.text = widget.link.title;
      summaryController.text = widget.link.summary;
      tagController.text = widget.link.tag;
      websiteController.text = widget.link.website;
    });
  }

  Future<void> _saveChanges() async {
    final success = await controller.handleFormSubmit(
      title: titleController.text,
      summary: summaryController.text,
      tag: tagController.text,
      website: websiteController.text,
      existingLink: widget.link,
    );

    if (success) {
      setState(() => isEditing = false);
      // The real-time listener will automatically update the UI with the new values
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: LightColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete Note',
          style: TextStyle(color: LightColors.primaryText),
        ),
        content: const Text(
          'Are you sure you want to delete this note? This action cannot be undone.',
          style: TextStyle(color: LightColors.secondaryText),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Get.back();
              try {
                await controller.deleteLink(widget.link.id!);
                if (mounted) {
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Note deleted successfully',
                    backgroundColor: Colors.green.withOpacity(0.1),
                    colorText: Colors.green.shade700,
                  );
                }
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to delete note: $e',
                  backgroundColor: Colors.red.withOpacity(0.1),
                  colorText: Colors.red.shade700,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open URL: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red.shade700,
      );
    }
  }

  void _showNotionComingSoon() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: LightColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Image.asset(
              AppAssets.notionLogo,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Add to Notion',
              style: TextStyle(color: LightColors.primaryText),
            ),
          ],
        ),
        content: const Text(
          'Notion integration is coming soon! Stay tuned for this exciting feature.',
          style: TextStyle(color: LightColors.secondaryText),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: LightColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _shareNote() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ShareBottomSheet(shortId: widget.link.id ?? ''),
    );
  }
}
