import 'package:cached_network_image/cached_network_image.dart';
import 'package:coronavirus/core/widgets/banner_view.dart';
import 'package:coronavirus/data/entities/epidemic_situation/coronavirus_situation_info.dart';
import 'package:flutter/material.dart';

class EpidemicSituationChartInfoView extends StatelessWidget {
  const EpidemicSituationChartInfoView({
    Key key,
    @required this.context,
    @required CornonavirusSituationInfo situationInfo,
  })  : _situationInfo = situationInfo,
        super(key: key);

  final BuildContext context;
  final CornonavirusSituationInfo _situationInfo;

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(top: 8),
      child: BannerView(
          width: MediaQuery.of(context).size.width - 16,
          height:
              (MediaQuery.of(context).size.width - 16) / (596.0 / 325.0) + 16,
          duration: const Duration(seconds: 5),
          dataSource: _situationInfo.statisticsInfo.dailyPics,
          itemBuilder: (_, __, ___, itemInfo) =>
              _buildBannerItemView(itemInfo, context)));

  Widget _buildBannerItemView(itemInfo, BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: EdgeInsets.only(bottom: 16),
      child: CachedNetworkImage(
          imageUrl: itemInfo.toString(),
          imageBuilder: (_, imageProvider) => Container(
              width: MediaQuery.of(context).size.width - 16,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(image: imageProvider)))));
}
