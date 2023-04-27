import 'package:annunci_lavoro_flutter/blocs/jobAds/bloc/job_ads_bloc.dart';
import 'package:annunci_lavoro_flutter/models/job_positions_model.dart';
import 'package:annunci_lavoro_flutter/utils/sliver_appbar_delagate.dart';
import 'package:annunci_lavoro_flutter/widgets/list_tile/job_ads_tile.dart';
import 'package:annunci_lavoro_flutter/widgets/drop_down/contract_drop_down.dart';
import 'package:annunci_lavoro_flutter/widgets/dialog_and_bottomsheet/modal_bottom_sort.dart';
import 'package:annunci_lavoro_flutter/widgets/drop_down/seniority_drop_down.dart';
import 'package:annunci_lavoro_flutter/widgets/shimmers/shimmed_list.dart';
import 'package:annunci_lavoro_flutter/widgets/sort_icon.dart';
import 'package:annunci_lavoro_flutter/widgets/drop_down/team_drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JobAdsPage extends StatefulWidget {
  const JobAdsPage({super.key});

  @override
  State<JobAdsPage> createState() => _JobAdsPageState();
}

class _JobAdsPageState extends State<JobAdsPage> {
  final ScrollController _adsListController = ScrollController();
  final ScrollController _actionBarController = ScrollController();
  late TextEditingController _searchFieldController;
  final FocusNode _searchFieldFocusNode = FocusNode();
  bool _showHeader = true;
  bool _showTextFiled = false;
  bool _enableListTap = true;

  @override
  void initState() {
    super.initState();
    _searchFieldController =
        BlocProvider.of<JobAdsBloc>(context).jobAdsController.searchController;

    _adsListController.addListener(
      () {
        if (_adsListController.position.userScrollDirection ==
            ScrollDirection.forward) {
          setState(() {
            _showHeader = true;
          });
        }
        if (_adsListController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          setState(() {
            _showHeader = false;
          });
        }
        if (_adsListController.position.maxScrollExtent ==
            _adsListController.offset) {
          moreAds();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobAdsBloc, JobAdsState>(
      buildWhen: (previous, current) =>
          current is FetchInitialJobAdsEvent || current is FetchedJobAdsState,
      builder: (context, state) {
        if (state is InitJobAdsState) {
          return ShimmedList(child: JobAdsTile.shimmed());
        } else if (state is ErrorJobAdsState) {
          return _errorWidget();
        } else if (state is FetchedJobAdsState || state is NoMoreJobAdsState) {
          return Scaffold(
            floatingActionButton:
                _showHeader && _showTextFiled == false ? _fab() : null,
            body: CustomScrollView(
              physics:
                  _showTextFiled ? const NeverScrollableScrollPhysics() : null,
              controller: _adsListController,
              slivers: [
                _showHeader
                    ? SliverPersistentHeader(
                        floating: true,
                        delegate: SliverAppBarDelegate(
                          color: Theme.of(context).cardColor,
                          minHeight: 106,
                          maxHeight: 106,
                          child: Column(
                            children: [
                              _header(),
                              _actionsBar(),
                            ],
                          ),
                        ),
                      )
                    : const SliverToBoxAdapter(),
                _adsList(),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _actionsBar() => Expanded(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _actionBarController,
          scrollDirection: Axis.horizontal,
          children: [
            _dropDownFilters(),
            _toggleSearchButton(),
            _showTextFiled ? _searchField() : const SizedBox(),
          ],
        ),
      );

  Widget _toggleSearchButton() => IconButton(
        onPressed: () => _showTextFiled ? _remTextField() : _showField(),
        icon: _showTextFiled
            ? const Icon(
                FontAwesomeIcons.close,
              )
            : const Icon(FontAwesomeIcons.search),
      );

  Widget _searchField() => Container(
        width: MediaQuery.of(context).size.width - 66,
        margin: const EdgeInsets.only(top: 12, bottom: 12, right: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey)),
        child: TextField(
          controller: _searchFieldController,
          focusNode: _searchFieldFocusNode,
          onTap: () => setState(() {
            _enableListTap = false;
          }),
          onEditingComplete: () => setState(() {
            _enableListTap = true;
            _searchFieldFocusNode.unfocus();
          }),
          cursorHeight: 18,
          cursorRadius: const Radius.circular(20),
          cursorWidth: 1,
          cursorColor: Theme.of(context).hintColor,
          textAlignVertical: TextAlignVertical.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(overflow: TextOverflow.ellipsis),
          decoration: InputDecoration(
            hintStyle: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).hintColor)
                .copyWith(fontStyle: FontStyle.italic),
            contentPadding: const EdgeInsets.only(
              left: 8,
              bottom: 14,
            ),
            hintText: ' Cerca qualcosa...',
            border: InputBorder.none,
          ),
        ),
      );

  Widget _sortButton() => SizedBox(
        height: 32,
        child: TextButton(
          onPressed: () => showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              context: context,
              builder: (context) => const SortingModalBottomSheet()),
          child: const SortIcon(),
        ),
      );

  Widget _header() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 6),
              child: Row(
                children: [
                  const Icon(Icons.list),
                  const SizedBox(width: 10),
                  StreamBuilder<List<JobPosition>>(
                    stream: BlocProvider.of<JobAdsBloc>(context)
                        .jobAdsController
                        .stream,
                    builder: (context, snapshot) => snapshot.hasData
                        ? Text(
                            'Posizioni aperte  ${snapshot.data!.length}',
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        : Text(
                            'Posizioni aperte aaa}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                  ),
                  Spacer(),
                  _sortButton(),
                ],
              ),
            ),
            const SizedBox(height: 6),
            _divider(),
          ],
        ),
      );

  Widget _fab() => FloatingActionButton.small(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _adsListController.animateTo(0.0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
        child: const Icon(
          Icons.arrow_upward_rounded,
          color: Colors.white,
        ),
      );

  Widget _dropDownFilters() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TeamDropDown(),
          SeniorityDropDown(),
          ContractDropDown(),
        ],
      );

  Widget _divider() => Row(
        children: [
          Container(
            height: 2,
            width: 200,
            color: Theme.of(context).primaryColorDark,
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width - 220,
            color: Colors.grey.shade400,
          ),
        ],
      );

  Widget _adsList() => BlocConsumer<JobAdsBloc, JobAdsState>(
        listener: (context, state) {
          if (state is NoMoreJobAdsState) {
            ScaffoldMessenger.of(context).showSnackBar(_snackBar());
          }
        },
        builder: (context, state) {
          return StreamBuilder<List<JobPosition>>(
            stream:
                BlocProvider.of<JobAdsBloc>(context).jobAdsController.stream,
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data!.isNotEmpty
                  ? SliverList.builder(
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data!.length) {
                          return state is FetchingMoreJobAdsState
                              ? _loadingAdsWidget()
                              : state is NoMoreJobAdsState
                                  ? _noMoreAdsWidget()
                                  : const SizedBox();
                        }
                        return JobAdsTile(
                          jobPosition: snapshot.data![index],
                          enabled: _enableListTap,
                        );
                      },
                    )
                  : _noAdsWidget();
            },
          );
        },
      );

  Widget _noAdsWidget() => SliverFillRemaining(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.list,
                size: 100,
                color: Colors.grey.shade500,
              ),
              const SizedBox(height: 10),
              Text(
                'Nessun Annuncio',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.grey.shade500,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      );

  Widget _noMoreAdsWidget() => Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 40),
        child: Column(
          children: [
            Icon(
              Icons.info,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 10),
            Text(
              'Hai visualizzato tutti gli annunci',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).disabledColor),
            ),
          ],
        ),
      );

  Widget _loadingAdsWidget() => Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: CupertinoActivityIndicator(
              radius: 16, color: Theme.of(context).dividerColor),
        ),
      );

  SnackBar _snackBar() => SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: ClipRRect(
          child: Row(
            children: [
              const Icon(
                Icons.info,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                'Hai visualizzato tutti gli annunci',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      );

  Widget _errorWidget() => const Center(
          child: Column(
        children: [
          Icon(Icons.error),
          Text('Errore'),
        ],
      ));

  void moreAds() {
    BlocProvider.of<JobAdsBloc>(context).moreAds();
    _adsListController.animateTo(
      _adsListController.offset * 0.2,
      duration: Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  void _showField() {
    setState(() {
      _showTextFiled = true;
      _enableListTap = false;
      _searchFieldFocusNode.requestFocus();
    });
    _actionBarController.animateTo(MediaQuery.of(context).size.width,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _remTextField() {
    setState(
      () {
        _showTextFiled = false;
        _enableListTap = true;
        _searchFieldFocusNode.unfocus();
        _searchFieldController.clear();
        BlocProvider.of<JobAdsBloc>(context).jobAdsController.stopSearch();
      },
    );
    _actionBarController.animateTo(0.0,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }
}
