import 'dart:ui';

import 'package:annunci_lavoro_flutter/cubits/dark_mode_cubit.dart';
import 'package:annunci_lavoro_flutter/models/freelance_positions_model.dart';
import 'package:annunci_lavoro_flutter/widgets/buttons/favourites_button.dart';
import 'package:annunci_lavoro_flutter/widgets/dialog_and_bottomsheet/freelance_ads_sheet.dart';
import 'package:annunci_lavoro_flutter/widgets/list_tile/job_ads_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../dialog_and_bottomsheet/more_action_dialog.dart';

//ignore: must_be_immutable
class FreelanceAdsTile extends StatefulWidget {
  bool enabled;
  final TileMode? tileMode;
  final FreeLancePosition? freeLancePosition;
  FreelanceAdsTile({
    required this.enabled,
    required this.freeLancePosition,
    this.tileMode,
    super.key,
  });

  factory FreelanceAdsTile.shimmed() =>
      FreelanceAdsTile(enabled: true, freeLancePosition: null);

  @override
  State<FreelanceAdsTile> createState() => _FreelanceAdsTileState();
}

class _FreelanceAdsTileState extends State<FreelanceAdsTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.tileMode == TileMode.dialogView
            ? BorderRadius.circular(16)
            : BorderRadius.circular(6),
        color: widget.freeLancePosition != null
            ? Theme.of(context).cardColor
            : Colors.transparent,
        boxShadow: widget.freeLancePosition != null && widget.tileMode == null
            ? [
                BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 0,
                  blurRadius: 0.9,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),
      margin: const EdgeInsets.all(6),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: widget.tileMode == TileMode.dialogView
                ? BorderRadius.circular(16)
                : BorderRadius.circular(6)),
        tileColor: widget.freeLancePosition != null
            ? Theme.of(context).cardColor
            : Colors.transparent,
        enabled: widget.enabled,
        onTap: _showBottomSheet,
        onLongPress: _showActionDialog,
        contentPadding: const EdgeInsets.all(10),
        isThreeLine: true,
        iconColor: Theme.of(context).iconTheme.color,
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        title: widget.freeLancePosition != null
            ? Text(
                widget.freeLancePosition!.adsTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              )
            : shimmedContainer(),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ndaInfo(widget.freeLancePosition!.nda),
            relationShipInfo(widget.freeLancePosition!.mapRelationshipString()),
          ],
        ),
        trailing: widget.freeLancePosition != null && widget.tileMode == null
            ? FavoriteButton(ads: widget.freeLancePosition!)
            : const SizedBox(),
      ),
    );
  }

  Widget shimmedIcon() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: CircleAvatar(),
      );

  Widget shimmedContainer({double? width, double? height}) => Container(
        height: height ?? 10,
        width: width ?? 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.grey),
      );

  Widget ndaInfo(NDA nda) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(
              'NDA :',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).dividerColor,
              ),
              child: Text(
                nda.toString().split('.')[1].toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

  Widget relationShipInfo(String label) => BlocBuilder<DarkModeCubit, bool>(
        builder: (context, darkMode) {
          return Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.freeLancePosition!.getRelationshipColor(
                  widget.freeLancePosition!.realtionship, darkMode),
            ),
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          );
        },
      );

  void _showBottomSheet() => showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(40),
        backgroundColor: Colors.transparent,
        elevation: 0,
        context: context,
        builder: (context) => FreelanceAdsSheet(
          freeLancePosition: widget.freeLancePosition!,
        ),
      );

  void _showActionDialog() => {
        HapticFeedback.heavyImpact(),
        showDialog(
          barrierDismissible: true,
          anchorPoint: Offset(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height / 2),
          context: context,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: MoreActionDialog(
                jobPosition: null, freeLancePosition: widget.freeLancePosition),
          ),
        )
      };
}
