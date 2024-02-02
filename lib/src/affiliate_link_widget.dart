import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:tezlapen_v2/src/model/affiliate_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

class AffiliateLinkWidget extends StatefulWidget {
  const AffiliateLinkWidget({required this.affiliate, super.key});
  final Affiliate affiliate;

  @override
  State<AffiliateLinkWidget> createState() => _AffiliateLinkWidgetState();
}

class _AffiliateLinkWidgetState extends State<AffiliateLinkWidget> {
  final style = const TextStyle(fontSize: 14, color: Colors.white);
  Map<String, PreviewData> previews = {};
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          LinkPreview(
            enableAnimation: true,
            linkStyle: style.copyWith(
              color: Colors.blue,
            ),
            metadataTextStyle: style.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            metadataTitleStyle: style.copyWith(
              fontWeight: FontWeight.w800,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            onPreviewDataFetched: (data) {
              setState(() {
                previews = {'preview': data};
              });
            },
            previewData: previews['preview'],
            text: widget.affiliate.affiliateUrl,
            width: MediaQuery.of(context).size.width / 2,
          ),
          const SizedBox(height: 10),
          Text(
            widget.affiliate.affiliateName,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
