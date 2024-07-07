import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({
    super.key,
    this.title,
    this.subtitle,
    this.imageFile,
    this.imageNetwork,
    this.onDelete,
    this.onTapCamera,
    this.onTapGalery,
  });

  final String? title;
  final String? subtitle;
  final File? imageFile;
  final String? imageNetwork;
  final void Function()? onDelete;
  final Function()? onTapCamera;
  final Function()? onTapGalery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          child: imageFile != null
              ? Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                )
              : imageNetwork != null
                  ? CachedNetworkImage(
                      key: UniqueKey(),
                      fit: BoxFit.cover,
                      imageUrl: imageNetwork ?? "",
                      placeholder: (context, url) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return const Center(
                          child: Icon(Icons.broken_image_outlined),
                        );
                      },
                      cacheManager: CacheManager(
                        Config(
                          "image_picker",
                          stalePeriod: const Duration(days: 3),
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.camera_enhance),
                    ),
        ),
      ),
      title: Text(title ?? ""),
      subtitle: Text(subtitle ?? "File Format: JPEG, PNG"),
      trailing: imageFile != null
          ? IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
            )
          : null,
      onTap: () {
        Get.bottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10),
            ),
          ),
          Wrap(
            children: [
              ListTile(
                title: Text(
                  title ?? "",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: GestureDetector(
                  child: const Icon(Icons.close),
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.camera_enhance),
                title: const Text('Kamera'),
                onTap: onTapCamera,
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Galeri'),
                onTap: onTapGalery,
              ),
            ],
          ),
        );
      },
    );
  }
}
