import 'dart:convert';

import 'package:crypto/crypto.dart';

class UuidSlugGenerator {
  /// Generates a short, URL-friendly, deterministic slug from a UUID string.
  ///
  /// Args:
  ///   uuidString: The standard UUID string (e.g., "123e4567-e89b-12d3-a456-426614174000").
  ///   length: The desired length of the slug (e.g., 7, 8, 10).
  ///           Shorter lengths increase collision probability significantly.
  ///
  /// Returns:
  ///   A URL-safe string of the specified length derived from the UUID.
  static String generateSlug(String uuidString, {int length = 8}) {
    if (uuidString.isEmpty) {
      return ''; // Handle empty input
    }
    if (length <= 0) {
      return ''; // Handle invalid length
    }

    // 1. Convert UUID string to bytes
    var uuidBytes = utf8.encode(uuidString);

    // 2. Hash the bytes (SHA-1 is shorter, SHA-256 is more standard)
    // Using SHA-1 here for a slightly shorter hash base to encode from
    var digest = sha1.convert(uuidBytes);
    var hashBytes = digest.bytes; // Get the raw hash bytes (20 bytes for SHA-1)

    // 3. Encode hash bytes using URL-safe Base64
    // base64Url is safe: A-Z, a-z, 0-9, '-', '_'
    var base64UrlString = base64UrlEncode(hashBytes);

    // 4. Remove padding characters ('=') if any (Base64 pads to multiples of 4 chars)
    var slug = base64UrlString.replaceAll('=', '');

    // 5. Truncate to the desired length
    // Make sure the length is not longer than the generated slug
    final effectiveLength = length > slug.length ? slug.length : length;
    return slug.substring(0, effectiveLength);
  }
}
