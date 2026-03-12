import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Utility for managing product image storage on local file system.
/// 
/// Handles copying images to app documents directory and deleting images.
class ImageStorage {
  /// Saves a product image to the app documents directory.
  /// 
  /// [productId] - unique product identifier
  /// [pickedFile] - the picked file from file_picker
  /// 
  /// Returns the local file path saved to database.
  /// Throws exception if image cannot be saved.
  static Future<String> saveProductImage(
    String productId,
    PlatformFile pickedFile,
  ) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(docsDir.path, 'images', 'products'));

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    // Get file extension
    final fileName = pickedFile.name;
    final ext = fileName.contains('.')
        ? fileName.substring(fileName.lastIndexOf('.'))
        : '.jpg';

    final newFileName = '$productId$ext';
    final newFilePath = p.join(imagesDir.path, newFileName);

    // Copy file to app documents directory
    final sourceFile = File(pickedFile.path ?? '');
    if (!await sourceFile.exists()) {
      throw Exception('Source image file does not exist');
    }

    await sourceFile.copy(newFilePath);

    return newFilePath;
  }

  /// Deletes a product image from storage.
  /// 
  /// [imagePath] - the image path to delete (null-safe)
  static Future<void> deleteProductImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return;
    }

    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Gets the thumbnail image file, returning null if image doesn't exist.
  /// Handles both absolute and relative paths.
  /// 
  /// [imagePath] - the image path (absolute or relative)
  static Future<File?> getProductImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    // Try absolute path first
    var file = File(imagePath);
    if (await file.exists()) {
      return file;
    }

    // If relative path, try to find it in app documents
    if (!p.isAbsolute(imagePath)) {
      try {
        final docsDir = await getApplicationDocumentsDirectory();
        
        // Try in images/products directory
        file = File(p.join(docsDir.path, 'images', 'products', imagePath));
        if (await file.exists()) {
          return file;
        }

        // Try stripping leading slash if present
        final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
        file = File(p.join(docsDir.path, 'images', cleanPath));
        if (await file.exists()) {
          return file;
        }

        // Try without the leading directory name
        final fileName = p.basename(imagePath);
        file = File(p.join(docsDir.path, 'images', 'products', fileName));
        if (await file.exists()) {
          return file;
        }
      } catch (e) {
        print('Error attempting to resolve relative image path: $e');
      }
    }

    return null;
  }
}
