import 'package:annunci_lavoro_flutter/cubits/dark_mode_cubit.dart';
import 'package:annunci_lavoro_flutter/models/freelance_positions_model.dart';
import 'package:annunci_lavoro_flutter/widgets/buttons/favourites_button.dart';
import 'package:annunci_lavoro_flutter/widgets/dialog_and_bottomsheet/freelance_ads_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//ignore: must_be_immutable
class FreelanceAdsTile extends StatefulWidget {
  bool enabled;
  final FreeLancePosition? freeLancePosition;
  FreelanceAdsTile({
    required this.enabled,
    required this.freeLancePosition,
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
        borderRadius: BorderRadius.circular(6),
        color: widget.freeLancePosition != null
            ? Theme.of(context).cardColor
            : Colors.transparent,
        boxShadow: widget.freeLancePosition != null
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          tileColor: widget.freeLancePosition != null
              ? Theme.of(context).cardColor
              : Colors.transparent,
          enabled: widget.enabled,
          onTap: () => showCupertinoModalBottomSheet(
                topRadius: const Radius.circular(40),
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) => FreelanceAdsSheet(
                  freeLancePosition: widget.freeLancePosition!,
                ),
              ).then(
                (value) => setState(() {}),
              ),
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
              relationShipInfo(
                  widget.freeLancePosition!.mapRelationshipString()),
            ],
          ),
          trailing: widget.freeLancePosition != null
              ? FavoriteButton(ads: widget.freeLancePosition!)
              : const SizedBox()),
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
}
