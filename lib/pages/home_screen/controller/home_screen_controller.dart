import 'package:get/get.dart';
import 'package:jsps_depo/jsps_depom_icons.dart';
import 'package:jsps_depo/pages/adli_kolluk/adli_kolluk.dart';
import 'package:jsps_depo/pages/ceviri/translator_feature.dart';
import 'package:jsps_depo/pages/deneme_sorulari/deneme_sorular_ekrani.dart';
import 'package:jsps_depo/pages/gemini/chat_screen.dart';
import 'package:jsps_depo/pages/home_screen/widgets/colors.dart';
import 'package:jsps_depo/pages/jsps_konular/first_page.dart';
import 'package:jsps_depo/pages/koordinat/location_widget.dart';
import 'package:jsps_depo/pages/mevzuat_arama/mevzuat_page.dart';
import 'package:jsps_depo/pages/notes/not_list_screen.dart';
import 'package:jsps_depo/pages/quiz_app/screens/sinif_secmek_ekrani.dart';
import 'package:jsps_depo/pages/resmi_gazete/resmi_gazete.dart';
import 'package:jsps_depo/pages/sozluk/format_json.dart';
import 'package:jsps_depo/pages/web_sites/web_view_screen.dart';

class HomeScreenController extends GetxController {
  final List<Map<String, dynamic>> icons = [
    {
      'icon': JspsDepom.jspskonular,
      'colorDark': AppColors.blueDark,
      'colorLight': AppColors.blueLight,
      'page': () => const FirstPage(),
    },
    {
      'icon': JspsDepom.s_navekrani,
      'colorDark': AppColors.redDark,
      'colorLight': AppColors.redLight,
      'page': () => const SinifSecmekEkrani(),
    },
    {
      'icon': JspsDepom.denemesorulari,
      'colorDark': AppColors.greenDark,
      'colorLight': AppColors.greenLight,
      'page': () => const DenemeSorularEkrani(),
    },
    {
      'icon': JspsDepom.adlikollukbilgileri,
      'colorDark': AppColors.orangeDark,
      'colorLight': AppColors.orangeLight,
      'page': () => const AdliKolluk(),
    },
    {
      'icon': JspsDepom.mevzuat,
      'colorDark': AppColors.purpleDark,
      'colorLight': AppColors.purpleLight,
      'page': () => const MevzuatEkrani(),
    },
    {
      'icon': JspsDepom.yararlisiteler,
      'colorDark': AppColors.yellowDark,
      'colorLight': AppColors.yellowLight,
      'page': () => const YararliSiteler(),
    },
    {
      'icon': JspsDepom.resmigazete,
      'colorDark': AppColors.tealDark,
      'colorLight': AppColors.tealLight,
      'page': () => const ResmiGazete(),
    },
    {
      'icon': JspsDepom.yzekran,
      'colorDark': AppColors.indigoDark,
      'colorLight': AppColors.indigoLight,
      'page': () => const ChatScreen(title: ''),
    },
    {
      'icon': JspsDepom.koordinatal,
      'colorDark': AppColors.brownDark,
      'colorLight': AppColors.brownLight,
      'page': () => const LocationWidget(),
    },
    {
      'icon': JspsDepom.sozluk,
      'colorDark': AppColors.blueDark,
      'colorLight': AppColors.blueLight,
      'page': () => const DictionaryScreen(),
    },
    {
      'icon': JspsDepom.c_eviri,
      'colorDark': AppColors.redDark,
      'colorLight': AppColors.redLight,
      'page': () => const TranslatorFeature(),
    },
    {
      'icon': JspsDepom.notal,
      'colorDark': AppColors.greenDark,
      'colorLight': AppColors.greenLight,
      'page': () => const NotListScreen(),
    },
    // Diğer kartlarınızı buraya ekleyin
  ];
}
