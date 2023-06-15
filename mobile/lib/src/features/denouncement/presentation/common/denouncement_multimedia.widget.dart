import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../shared/common_widgets/custom_text.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../domain/denouncement.dart';

class DenouncementMultimediaWidget extends StatelessWidget {
  const DenouncementMultimediaWidget({
    Key? key,
    required this.multimediaElement,
  }) : super(key: key);

  final DenouncementMultimedia multimediaElement;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: multimediaElement.uri,
          placeholder: (context, url) => const CircularProgressIndicator(),
          imageBuilder: (context, multimediaElementProvider) => Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: multimediaElementProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        gapH12,
        CustomText(
          text: multimediaElement.description,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
