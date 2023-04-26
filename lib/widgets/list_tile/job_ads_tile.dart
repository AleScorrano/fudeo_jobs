import 'package:annunci_lavoro_flutter/cubits/dark_mode_cubit.dart';
import 'package:annunci_lavoro_flutter/models/job_positions_model.dart';
import 'package:annunci_lavoro_flutter/widgets/buttons/favourites_button.dart';
import 'package:annunci_lavoro_flutter/widgets/dialog_and_bottomsheet/job_ads_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//ignore: must_be_immutable
class JobAdsTile extends StatefulWidget {
  bool enabled;
  final JobPosition? jobPosition;
  JobAdsTile({
    super.key,
    required this.jobPosition,
    required this.enabled,
  });
  factory JobAdsTile.shimmed() => JobAdsTile(
        jobPosition: null,
        enabled: true,
      );

  @override
  State<JobAdsTile> createState() => _JobAdsTileState();
}

class _JobAdsTileState extends State<JobAdsTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: widget.jobPosition != null
            ? Theme.of(context).cardColor
            : Colors.transparent,
        boxShadow: widget.jobPosition != null
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
        tileColor: widget.jobPosition != null
            ? Theme.of(context).cardColor
            : Colors.transparent,
        enabled: widget.enabled,
        onTap: () => showCupertinoModalBottomSheet(
          topRadius: const Radius.circular(40),
          backgroundColor: Colors.transparent,
          elevation: 0,
          context: context,
          builder: (context) => JobAdsSheet(
            jobPosition: widget.jobPosition!,
          ),
        ).then(
          (value) => setState(() {}),
        ),
        contentPadding: const EdgeInsets.all(10),
        isThreeLine: true,
        iconColor: Theme.of(context).iconTheme.color,
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        leading: widget.jobPosition != null
            ? Icon(widget.jobPosition!.teamIcon)
            : shimmedIcon(),
        title: widget.jobPosition != null
            ? Text(
                widget.jobPosition!.onlyTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              )
            : shimmedContainer(width: 280),
        subtitle: widget.jobPosition != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.jobPosition!.company,
                      style: Theme.of(context).textTheme.titleMedium!),
                  const SizedBox(height: 4),
                  Text(
                    widget.jobPosition!.remuneration ?? '-',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _contractAndSeniority(context),
                ],
              )
            : shimmedSubtitle(),
        trailing: widget.jobPosition != null
            ? FavoriteButton(ads: widget.jobPosition!)
            : const SizedBox(),
      ),
    );
  }

  Widget _contractAndSeniority(BuildContext context) =>
      widget.jobPosition != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.jobPosition!.mapSeniorityString() != null
                    ? _seniorityInfo(
                        context, widget.jobPosition!.mapSeniorityString())
                    : const SizedBox(),
                SizedBox(
                    width: widget.jobPosition!.mapSeniorityString() != null
                        ? 6
                        : 0),
                widget.jobPosition!.mapContractTypeString() != null
                    ? _contractInfo(
                        context, widget.jobPosition!.mapContractTypeString())
                    : const SizedBox(),
              ],
            )
          : const SizedBox();

  Widget _seniorityInfo(BuildContext context, String? label) => label == null
      ? const SizedBox()
      : BlocBuilder<DarkModeCubit, bool>(
          builder: (context, darkMode) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: widget.jobPosition!.getSeniorityColor(
                    widget.jobPosition!.seniority!, darkMode),
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

  Widget _contractInfo(BuildContext context, String? label) => label == null
      ? const SizedBox()
      : BlocBuilder<DarkModeCubit, bool>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: widget.jobPosition!
                    .getContractColor(widget.jobPosition!.contractType!, state),
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

  Widget shimmedContainer({double? width, double? height}) => Container(
        height: height ?? 10,
        width: width ?? 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.grey),
      );

  Widget shimmedSubtitle() => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmedContainer(height: 8),
            const SizedBox(height: 10),
            shimmedContainer(width: 150, height: 6),
          ],
        ),
      );

  Widget shimmedIcon() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: CircleAvatar(),
      );
}
