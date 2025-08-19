import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

// TODO: refresh cache only when needed (new version of data)

class ImageCacheService {
	static ImageCacheService? _instance;
	static ImageCacheService get instance => _instance ??= ImageCacheService._();
	
	ImageCacheService._();

	late Directory _cacheDir;
	bool _initialized = false;
	final Map<String, Uint8List> _memoryCache = {};
	final Set<String> _cachingInProgress = {};
	Box<Uint8List>? _webImageBox;

	Future<void> initialize() async {
		if (_initialized) return;
		
		if (kIsWeb) {
			await Hive.initFlutter();
			_webImageBox = await Hive.openBox<Uint8List>('image_cache');
		} else {
			final appDir = await getApplicationDocumentsDirectory();
			_cacheDir = Directory('${appDir.path}/image_cache');
			if (!await _cacheDir.exists()) {
				await _cacheDir.create(recursive: true);
			}
		}
		
		_initialized = true;
	}

	String _generateCacheKey(String imageUrl) {
		return md5.convert(utf8.encode(imageUrl)).toString();
	}

	String _getCacheFilePath(String imageUrl) {
		final key = _generateCacheKey(imageUrl);
		final extension = imageUrl.split('.').last;
		return '${_cacheDir.path}/$key.$extension';
	}

	bool isImageCachedInMemory(String imageUrl) {
		return _memoryCache.containsKey(imageUrl);
	}

	Future<bool> isImageCachedOnDisk(String imageUrl) async {
		await initialize();
		if (kIsWeb) {
			return _webImageBox?.containsKey(imageUrl) ?? false;
		}
		final file = File(_getCacheFilePath(imageUrl));
		return await file.exists();
	}

	Uint8List? getCachedImageFromMemory(String imageUrl) {
		return _memoryCache[imageUrl];
	}

	Future<Uint8List?> getCachedImageFromDisk(String imageUrl) async {
		await initialize();
		if (kIsWeb) {
			final data = _webImageBox?.get(imageUrl);
			return data;
		}
		try {
			final file = File(_getCacheFilePath(imageUrl));
			if (await file.exists()) {
				return await file.readAsBytes();
			}
		} catch (e) {
			debugPrint('Error reading cached image: $e');
		}
		return null;
	}

	Future<Uint8List?> _fetchImageBytes(String imageUrl) async {
		// Load from assets if it's an asset path; otherwise use HTTP
		if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
			try {
				final ByteData bd = await rootBundle.load(imageUrl);
				return bd.buffer.asUint8List();
			} catch (e) {
				debugPrint('Failed to load asset $imageUrl: $e');
				return null;
			}
		}
		try {
			final response = await http.get(
				Uri.parse(imageUrl),
				headers: {'Cache-Control': 'max-age=31536000'},
			);
			if (response.statusCode == 200) {
				return response.bodyBytes;
			}
			debugPrint('HTTP ${response.statusCode} for $imageUrl');
			return null;
		} catch (e) {
			debugPrint('HTTP error for $imageUrl: $e');
			return null;
		}
	}

	Future<void> cacheImage(String imageUrl) async {
		await initialize();
		if (_cachingInProgress.contains(imageUrl)) return;
		_cachingInProgress.add(imageUrl);
		try {
			if (isImageCachedInMemory(imageUrl)) return;
			if (await isImageCachedOnDisk(imageUrl)) {
				final imageData = await getCachedImageFromDisk(imageUrl);
				if (imageData != null) {
					_memoryCache[imageUrl] = imageData;
					return;
				}
			}
			final imageData = await _fetchImageBytes(imageUrl);
			if (imageData == null) return;
			_memoryCache[imageUrl] = imageData;
			if (kIsWeb) {
				await _webImageBox?.put(imageUrl, imageData);
			} else {
				try {
					final file = File(_getCacheFilePath(imageUrl));
					await file.writeAsBytes(imageData);
				} catch (e) {
					debugPrint('Error caching image to disk: $e');
				}
			}
		} catch (e) {
			debugPrint('Error caching image $imageUrl: $e');
		} finally {
			_cachingInProgress.remove(imageUrl);
		}
	}

	Future<void> preCacheImages(List<String> imageUrls) async {
		await initialize();
		debugPrint('Starting pre-cache of ${imageUrls.length} images...');
		const maxConcurrent = 5;
		for (int i = 0; i < imageUrls.length; i += maxConcurrent) {
			final batch = imageUrls.skip(i).take(maxConcurrent).toList();
			await Future.wait(batch.map(cacheImage));
		}
		debugPrint('Pre-cache completed for ${imageUrls.length} images');
	}

	Future<Uint8List?> getImageData(String imageUrl) async {
		await initialize();
		if (isImageCachedInMemory(imageUrl)) {
			return getCachedImageFromMemory(imageUrl);
		}
		final diskData = await getCachedImageFromDisk(imageUrl);
		if (diskData != null) {
			_memoryCache[imageUrl] = diskData;
			return diskData;
		}
		await cacheImage(imageUrl);
		return getCachedImageFromMemory(imageUrl);
	}

	void clearMemoryCache() {
		_memoryCache.clear();
		debugPrint('Memory cache cleared');
	}

	Future<void> clearDiskCache() async {
		await initialize();
		if (kIsWeb) {
			await _webImageBox?.clear();
			debugPrint('IndexedDB image cache cleared');
			return;
		}
		try {
			if (await _cacheDir.exists()) {
				await _cacheDir.delete(recursive: true);
				await _cacheDir.create();
			}
			debugPrint('Disk cache cleared');
		} catch (e) {
			debugPrint('Error clearing disk cache: $e');
		}
	}

	Future<void> clearAllCache() async {
		clearMemoryCache();
		await clearDiskCache();
	}

	Future<Map<String, dynamic>> getCacheStats() async {
		await initialize();
		int diskSize = 0;
		int diskFileCount = 0;
		if (kIsWeb) {
			final values = _webImageBox?.values ?? const Iterable<Uint8List>.empty();
			for (final bytes in values) {
				diskSize += bytes.length;
				diskFileCount += 1;
			}
			return {
				'memoryCacheSize': _memoryCache.length,
				'memoryCacheSizeBytes': _memoryCache.values.fold<int>(0, (sum, d) => sum + d.length),
				'diskCacheSize': diskFileCount,
				'diskCacheSizeBytes': diskSize,
				'cachingInProgress': _cachingInProgress.length,
			};
		}
		if (await _cacheDir.exists()) {
			await for (final file in _cacheDir.list(recursive: true)) {
				if (file is File) {
					diskSize += await file.length();
					diskFileCount++;
				}
			}
		}
		return {
			'memoryCacheSize': _memoryCache.length,
			'memoryCacheSizeBytes': _memoryCache.values.fold<int>(0, (sum, d) => sum + d.length),
			'diskCacheSize': diskFileCount,
			'diskCacheSizeBytes': diskSize,
			'cachingInProgress': _cachingInProgress.length,
		};
	}

	bool isCachingInProgress(String imageUrl) {
		return _cachingInProgress.contains(imageUrl);
	}

	Map<String, bool> getCacheProgress(List<String> imageUrls) {
		return {
			for (final url in imageUrls) url: isImageCachedInMemory(url) || isCachingInProgress(url)
		};
	}
}
