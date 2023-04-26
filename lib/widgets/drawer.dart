import 'package:annunci_lavoro_flutter/widgets/dialog_and_bottomsheet/link_error_dialog.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        children: [
          _header(context),
          const SizedBox(height: 16),
          _menuButton(context,
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              text: 'Lista preferiti',
              onTap: () => Navigator.pushNamed(context, 'favourite')),
          const Divider(thickness: 2, indent: 8, endIndent: 8),
          _menuButton(context,
              icon: Icon(
                FontAwesomeIcons.envelope,
                color: Theme.of(context).primaryColor,
              ),
              text: 'Newsletter',
              onTap: () => _goToNewsletter(context)),
          _menuButton(context,
              icon: Icon(
                FontAwesomeIcons.school,
                color: Colors.amber.shade700,
              ),
              text: 'I nostri corsi',
              onTap: () => _goToFudeoCourse(context)),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 4),
        height: 180,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.only(bottomRight: Radius.circular(12)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              const Color(0x061D5C).withOpacity(1),
              const Color(0x027DFD).withOpacity(1),
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Image(
                fit: BoxFit.cover,
                width: 80,
                height: 110,
                image: AssetImage('assets/images/flutter_logo_classic.png'),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 6.0, bottom: 6),
                child: EasyRichText(
                  'Bacheca di annunci di \n lavoro per assunzioni e \n progetti freelance \n\n completamente gratuito',
                  defaultStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                  patternList: [
                    EasyRichTextPattern(
                      targetString: 'assunzioni',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).highlightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    EasyRichTextPattern(
                      targetString: 'progetti freelance',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).highlightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    EasyRichTextPattern(
                      targetString: 'completamente gratuito',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget _menuButton(BuildContext context,
          {required Icon icon,
          required String text,
          required Function() onTap}) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).focusColor),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          leading: icon,
          title: Text(
            text,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
          ),
        ),
      );

  Future<void> _goToFudeoCourse(BuildContext context) async {
    final Uri _url = Uri.parse("https://www.fudeo.it/#InternalCourses");
    if (!await launchUrl(_url)) {
      showDialog(
          context: context, builder: (context) => const LinkErrorDialog());
    }
  }

  Future<void> _goToNewsletter(BuildContext context) async {
    final Uri _url = Uri.parse(
        "https://offertelavoroflutter.it/ricevi-offerte-lavoro-flutter");
    if (!await launchUrl(_url)) {
      showDialog(
          context: context, builder: (context) => const LinkErrorDialog());
    }
  }
}
