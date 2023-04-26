import 'package:annunci_lavoro_flutter/blocs/jobAds/bloc/job_ads_bloc.dart';
import 'package:annunci_lavoro_flutter/cubits/dark_mode_cubit.dart';
import 'package:annunci_lavoro_flutter/models/job_positions_model.dart';
import 'package:annunci_lavoro_flutter/pages/freelance_ads_page.dart';
import 'package:annunci_lavoro_flutter/pages/job_ads_page.dart';
import 'package:annunci_lavoro_flutter/widgets/drawer.dart';
import 'package:annunci_lavoro_flutter/widgets/list_tile/job_ads_tile.dart';
import 'package:annunci_lavoro_flutter/widgets/shimmers/shimmed_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DarkModeCubit, bool>(
      builder: (context, state) {
        return Scaffold(
          drawer: const MyDrawer(),
          appBar: _appBar(state),
          body: OfflineBuilder(
            connectivityBuilder: (context, connectivity, child) =>
                connectivity == ConnectivityResult.none
                    ? _offlineBody(context)
                    : child,
            child: _connectedBody(),
          ),
        );
      },
    );
  }

  Widget _connectedBody() => BlocConsumer<JobAdsBloc, JobAdsState>(
        listener: (context, state) {},
        buildWhen: (previous, current) =>
            current is FetchInitialJobAdsEvent || current is FetchedJobAdsState,
        builder: (context, state) {
          if (state is InitJobAdsState) {
            return ShimmedList(child: JobAdsTile.shimmed());
          } else if (state is ErrorJobAdsState) {
            return _errorWidget();
          } else if (state is FetchedJobAdsState) {
            return TabView(
              tabController: _tabController,
            );
          }
          return const SizedBox();
        },
      );

  Widget _offlineBody(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 100,
              color: Colors.black38,
            ),
            Text(
              'Sei offline',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ],
        ),
      );

  PreferredSizeWidget _appBar(bool darkMode) => AppBar(
        backgroundColor: !darkMode
            ? Colors.transparent
            : Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        shadowColor:
            !darkMode ? Colors.transparent : Theme.of(context).primaryColorDark,
        elevation: 5,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu, size: 30),
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.maxFinite, 52),
          child: Container(
            decoration: BoxDecoration(
              gradient: !darkMode
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        Theme.of(context).primaryColorDark,
                        Theme.of(context).primaryColor,
                      ],
                    )
                  : null,
            ),
            child: TabBar(
              unselectedLabelColor: Colors.white,
              labelPadding: const EdgeInsets.all(4),
              labelColor: Colors.black87,
              indicatorPadding:
                  const EdgeInsets.only(bottom: 3, left: 4, right: 4),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).highlightColor.withOpacity(0.9),
              ),
              labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              controller: _tabController,
              tabs: const [
                Text('Assunzioni'),
                Text('Freelance'),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            highlightColor: Colors.transparent,
            onPressed: () => BlocProvider.of<DarkModeCubit>(context).toggle(),
            icon: Icon(
              darkMode
                  ? CupertinoIcons.brightness_solid
                  : CupertinoIcons.moon_fill,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
                width: 40,
                height: 40,
                color: !darkMode ? Colors.black38 : null,
                alignment: Alignment.topLeft,
                colorBlendMode: !darkMode ? BlendMode.darken : null,
                image:
                    const AssetImage('assets/images/flutter_logo_classic.png')),
            Text(
              'FUDEO JOBS',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: !darkMode
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      Theme.of(context).primaryColorDark,
                      Theme.of(context).primaryColor,
                    ],
                  )
                : null,
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

  void openBottomSheet(JobPosition jobPosition) =>
      showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => Container(
                height: double.maxFinite,
                width: double.maxFinite,
              ));
}

class TabView extends StatefulWidget {
  final TabController tabController;

  const TabView({
    super.key,
    required this.tabController,
  });

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  void initState() {
    widget.tabController
        .addListener(() => _handleTabChange(widget.tabController.index));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController,
      children: const [
        JobAdsPage(),
        FreeLanceAdsPage(),
      ],
    );
  }

  void _handleTabChange(int index) {
    if (index == 1) {
      BlocProvider.of<JobAdsBloc>(context).jobAdsController.resetFilter();
    } else if (index == 0) {
      //TODO implementare il reset per l'altro tab.
    }
  }
}
