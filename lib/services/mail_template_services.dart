import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EmailTemplate {
  final String title;
  final String content;
  
  EmailTemplate({required this.title, required this.content});
  
  factory EmailTemplate.fromMap(Map<String, dynamic> data) {
    return EmailTemplate(
      title: data['title'] ?? '',
      content: data['content'] ?? '',
    );
  }
}

class ProcessedEmailTemplate {
  final String title;
  final String content;

  ProcessedEmailTemplate({required this.title, required this.content});
}

class MailTemplateService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Cache for all templates
  Map<String, EmailTemplate>? _allTemplatesCache;
  DateTime? _lastFetchTime;
  
  final Duration cacheDuration = Duration(days: 1);

  /// Fetches all templates from Firestore
  Future<Map<String, EmailTemplate>> _getAllTemplates(
      {bool forceRefresh = false}) async {
    final now = DateTime.now();
    
    // Check cache first (unless force refresh is requested)
    if (!forceRefresh && 
        _allTemplatesCache != null &&
        _lastFetchTime != null &&
        now.difference(_lastFetchTime!) < cacheDuration) {
      return _allTemplatesCache!;
    }
    
    try {
      final docSnapshot =
          await _firestore.collection('metadata').doc('mailTemplates').get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final templates = <String, EmailTemplate>{};

        // Convert each template field to an EmailTemplate object
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            templates[key] = EmailTemplate.fromMap(value);
          }
        });
        
        // Update cache
        _allTemplatesCache = templates;
        _lastFetchTime = now;
        
        return templates;
      } else {
        throw Exception('Mail templates document not found');
      }
    } catch (e) {
      // If there was an error but we have a cached version, return it as fallback
      if (_allTemplatesCache != null) {
        return _allTemplatesCache!;
      }
      throw Exception('Failed to load templates: $e');
    }
  }
  
  /// Fetches a specific template by its key
  Future<EmailTemplate> getTemplate(String templateKey,
      {bool forceRefresh = false}) async {
    final templates = await _getAllTemplates(forceRefresh: forceRefresh);
    
    if (templates.containsKey(templateKey)) {
      return templates[templateKey]!;
    } else {
      throw Exception('Template "$templateKey" not found');
    }
  }
  
  /// Clear the entire cache
  void clearCache() {
    _allTemplatesCache = null;
    _lastFetchTime = null;
  }
  
  /// Process template text by replacing placeholders with actual values
  String _processText(String text, Map<String, String> placeholders) {
    String processed = text;
    
    placeholders.forEach((key, value) {
      processed = processed.replaceAll('{{$key}}', value);
    });
    
    return processed;
  }

  /// Get and process a template in a single call
  Future<ProcessedEmailTemplate> getProcessedTemplate(
      String templateKey, Map<String, String> placeholders,
      {bool forceRefresh = false}) async {
    final template = await getTemplate(templateKey, forceRefresh: forceRefresh);

    return ProcessedEmailTemplate(
        title: _processText(template.title, placeholders),
        content: _processText(template.content, placeholders));
  }
  
  /// Method to convert processed template into a structure ready for sending via Firestore
  Future<Map<String, dynamic>> prepareEmailData(String templateKey,
      String recipientEmail, Map<String, String> placeholders,
      {bool forceRefresh = false}) async {
    
    final processed = await getProcessedTemplate(templateKey, placeholders,
        forceRefresh: forceRefresh);

    return {
      "to": [recipientEmail],
      "message": {
        "subject": processed.title,
        "text": processed.title, // Fallback plain text
        "html": processed.content,
      }
    };
  }
}
