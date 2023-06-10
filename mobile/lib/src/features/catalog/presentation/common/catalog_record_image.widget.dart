import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../shared/common_widgets/custom_text.dart';
import '../../../../shared/common_widgets/common_rich_text.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../domain/catalog.dart';

class CatalogRecordImageWidget extends StatelessWidget {
  const CatalogRecordImageWidget({
    Key? key,
    required this.image,
  }) : super(key: key);

  final CatalogRecordImage image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: image.url,
          placeholder: (context, url) => const CircularProgressIndicator(),
          imageBuilder: (context, imageProvider) => Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
            ),
          ),
        ),
        gapH12,
        CommonRichText(
          textAlign: TextAlign.center,
          children: <TextSpanDetails>[
            TextSpanDetails(
              text: DateTimeFormat.toYYYYMMDD(image.submittedAt),
              fontStyle: FontStyle.italic,
            ),
            const TextSpanDetails(text: ' por '),
            TextSpanDetails(
              text: image.authorName,
              fontStyle: FontStyle.normal,
            )
          ],
        ),
        gapH4,
        CustomText(
          text: image.description,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
