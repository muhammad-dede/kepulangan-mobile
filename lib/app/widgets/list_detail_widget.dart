import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ListDetailWidget extends StatelessWidget {
  const ListDetailWidget({
    Key? key,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTapImage,
    this.onTapListTile,
  }) : super(key: key);

  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final void Function()? onTapImage;
  final void Function()? onTapListTile;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      visualDensity: imageUrl == null
          ? const VisualDensity(horizontal: 0, vertical: -4)
          : null,
      leading: imageUrl != null
          ? ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                  ),
                ),
                child: GestureDetector(
                  onTap: onTapImage,
                  child: CachedNetworkImage(
                    key: UniqueKey(),
                    fit: BoxFit.cover,
                    imageUrl: imageUrl ?? "",
                    placeholder: (context, url) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return const Center(
                        child: Icon(Icons.image),
                      );
                    },
                    cacheManager: CacheManager(
                      Config(
                        "image_detail",
                        stalePeriod: const Duration(days: 3),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
      title: title != null
          ? Text(
              title ?? "",
              style: TextStyle(fontSize: imageUrl != null ? 16 : 14),
            )
          : null,
      subtitle: subtitle != null
          ? Text(
              subtitle ?? "",
              style: TextStyle(fontSize: imageUrl != null ? 14 : 16),
            )
          : null,
      trailing: onTapImage != null && onTapListTile != null
          ? const Icon(Icons.arrow_forward_ios)
          : null,
      onTap: onTapListTile,
    );
  }
}
