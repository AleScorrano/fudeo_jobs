import 'package:annunci_lavoro_flutter/blocs/freelanceAds/bloc/freelance_ads_bloc.dart';
import 'package:annunci_lavoro_flutter/models/freelance_positions_model.dart';
import 'package:annunci_lavoro_flutter/utils/sliver_appbar_delagate.dart';
import 'package:annunci_lavoro_flutter/widgets/list_tile/freelance_ads_tile.dart';
import 'package:annunci_lavoro_flutter/widgets/drop_down/nda_dropd_down.dart';
import 'package:annunci_lavoro_flutter/widgets/drop_down/relationship_drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FreeLanceAdsPage extends StatefulWidget {
  const FreeLanceAdsPage({
    super.key,
  });

  @override
  State<FreeLanceAdsPage> createState() => _FreeLanceAdsPageState();
}

class _FreeLanceAdsPageState extends State<FreeLanceAdsPage> {
  final ScrollController _adsListController = ScrollController();
  final ScrollController _actionBarController = ScrollController();
  late TextEditingController _searchFieldController;
  final FocusNode _searchFiledFocusNode = FocusNode();
  bool _showHeader = true;
  bool _showTextFiled = false;
  bool _enableListTap = true;

  @override
  void initState() {
    super.initState();
    _searchFieldController = BlocProvider.of<FreelanceAdsBloc>(context)
        .freeLanceAdsController
        .searchController;

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
          BlocProvider.of<FreelanceAdsBloc>(context).moreAds();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          _showHeader && _showTextFiled == false ? _fab() : null,
      body: CustomScrollView(
        physics: _showTextFiled ? const NeverScrollableScrollPhysics() : null,
        controller: _adsListController,
        slivers: [
          _showHeader
              ? SliverPersistentHeader(
                  floating: true,
                  delegate: SliverAppBarDelegate(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    minHeight: 120,
                    maxHeight: 120,
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

  Widget _dropDownFilters() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NdaDropDown(),
            RelationshipDropDown(),
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
          focusNode: _searchFiledFocusNode,
          onTap: () => setState(() {
            _enableListTap = false;
          }),
          onSubmitted: (value) => setState(() {
            _enableListTap = true;
            _searchFiledFocusNode.unfocus();
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

  Widget _header() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 20),
            child: Row(
              children: [
                const Icon(Icons.list),
                const SizedBox(
                  width: 10,
                ),
                StreamBuilder<List<FreeLancePosition>>(
                  stream: BlocProvider.of<FreelanceAdsBloc>(context)
                      .freeLanceAdsController
                      .stream,
                  builder: (context, snapshot) => snapshot.hasData
                      ? Text(
                          'Offerte attive  ${snapshot.data!.length}',
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      : Text(
                          'Posizioni aperte aaa}',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                )
              ],
            ),
          ),
          const SizedBox(height: 6),
          _divider(),
        ],
      );

  Widget _adsList() => BlocConsumer<FreelanceAdsBloc, FreelanceAdsState>(
        listener: (context, state) {
          if (state is NoMoreFreelanceAdsState) {
            ScaffoldMessenger.of(context).showSnackBar(_snackBar());
          }
        },
        builder: (context, state) {
          return StreamBuilder<List<FreeLancePosition>>(
            stream: BlocProvider.of<FreelanceAdsBloc>(context)
                .freeLanceAdsController
                .stream,
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data!.isNotEmpty
                  ? SliverList.builder(
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data!.length) {
                          return state is FetchingMoreFreelanceAdsState
                              ? _loadingAdsWidget()
                              : state is NoMoreFreelanceAdsState
                                  ? _noMoreAdsWidget()
                                  : const SizedBox();
                        }
                        return FreelanceAdsTile(
                            enabled: _enableListTap,
                            freeLancePosition: snapshot.data![index]);
                      },
                      //separatorBuilder: (context, index) => _listDivider(),
                    )
                  : _noAdsWidget();
            },
          );
        },
      );

  Widget _listDivider() => Divider(
        color: Theme.of(context).dividerColor,
        indent: 8,
        endIndent: 8,
        thickness: 2,
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

  Widget _divider() => Row(
        children: [
          Container(
            height: 2,
            width: 210,
            color: Theme.of(context).primaryColorDark,
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width - 220,
            color: Colors.grey.shade400,
          ),
        ],
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

  Widget adsCard() => Container(
        height: 80,
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38, width: 0),
          borderRadius: BorderRadius.circular(12),
        ),
      );

  Widget _loadingAdsWidget() => Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: CupertinoActivityIndicator(
              radius: 16, color: Theme.of(context).dividerColor),
        ),
      );

  Widget _fab() => FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _adsListController.animateTo(0.0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
        child: const Icon(
          Icons.arrow_upward_rounded,
          color: Colors.white,
        ),
      );

  SnackBar _snackBar() => SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
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
                  fontSize: 20,
                  color: Colors.white),
            ),
          ],
        ),
      );

  void _showField() {
    setState(() {
      _showTextFiled = true;
      _enableListTap = false;
      _searchFiledFocusNode.requestFocus();
    });
    _actionBarController.animateTo(MediaQuery.of(context).size.width + 80,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _remTextField() {
    setState(() {
      _showTextFiled = false;
      _enableListTap = true;
      _searchFiledFocusNode.unfocus();
      _searchFieldController.clear();
      BlocProvider.of<FreelanceAdsBloc>(context)
          .freeLanceAdsController
          .stopSearch();
    });
    _actionBarController.animateTo(0.0,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }
}
