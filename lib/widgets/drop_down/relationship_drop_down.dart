import 'package:annunci_lavoro_flutter/blocs/freelanceAds/bloc/freelance_ads_bloc.dart';
import 'package:annunci_lavoro_flutter/models/freelance_positions_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelationshipDropDown extends StatefulWidget {
  final String hintText = 'Relazione di lavoro';
  final List<String> items = ['Col commisionante', 'Con altri professionisti'];
  RelationshipDropDown({
    super.key,
  });

  @override
  State<RelationshipDropDown> createState() => _SeniorityDropDownState();
}

class _SeniorityDropDownState extends State<RelationshipDropDown> {
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  widget.hintText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              items: widget.items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  enabled: false,
                  child: StatefulBuilder(
                    builder: (context, menuSetState) {
                      final isSelected = selectedItems.contains(item);
                      return InkWell(
                        onTap: () {
                          isSelected ? removeFilter(item) : addFilter(item);
                          setState(() {});
                          menuSetState(() {});
                        },
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              isSelected
                                  ? const Icon(Icons.check_box_outlined)
                                  : const Icon(Icons.check_box_outline_blank),
                              const SizedBox(width: 10),
                              Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
              value: selectedItems.isEmpty ? null : selectedItems.last,
              onChanged: (value) {},
              selectedItemBuilder: (context) {
                return widget.items.map(
                  (item) {
                    return Container(
                      alignment: AlignmentDirectional.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        selectedItems.join(', '),
                        style: const TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    );
                  },
                ).toList();
              },
              buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 36,
                width: 200,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.zero,
              ),
              dropdownStyleData: DropdownStyleData(
                  width: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  offset: const Offset(0, -3)),
            ),
          ),
        ),
        _filterActiveIndicator(),
      ],
    );
  }

  Widget _filterActiveIndicator() => ValueListenableBuilder<bool>(
        valueListenable: BlocProvider.of<FreelanceAdsBloc>(context)
            .freeLanceAdsController
            .isRelationshipFiltersEmpty,
        builder: ((context, value, child) => !value
            ? Positioned(
                bottom: 5,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.orangeAccent.shade700,
                  radius: 5,
                ),
              )
            : const SizedBox()),
      );

  void addFilter(String item) {
    final Relationship type = FreeLancePosition.mapRelationshipEnum(item);

    if (type != null) {
      BlocProvider.of<FreelanceAdsBloc>(context)
          .freeLanceAdsController
          .addRelationshipFilter(type);
      selectedItems.add(item);
    }
  }

  void removeFilter(String item) {
    final Relationship type = FreeLancePosition.mapRelationshipEnum(item);

    if (type != null) {
      BlocProvider.of<FreelanceAdsBloc>(context)
          .freeLanceAdsController
          .removeRelationshipFilter(type);
      selectedItems.remove(item);
    }
  }
}
