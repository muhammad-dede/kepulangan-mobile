import 'package:get/get.dart';
import 'package:kepulangan/app/modules/create_koordinator/bindings/create_koordinator_binding.dart';
import 'package:kepulangan/app/modules/create_koordinator/views/create_koordinator_view.dart';
import 'package:kepulangan/app/modules/edit_koordinator/bindings/edit_koordinator_binding.dart';
import 'package:kepulangan/app/modules/edit_koordinator/views/edit_koordinator_view.dart';
import 'package:kepulangan/app/modules/koordinator/bindings/koordinator_binding.dart';
import 'package:kepulangan/app/modules/koordinator/views/koordinator_view.dart';

import '../middlewares/auth_middleware.dart';
import '../middlewares/introduction_middleware.dart';
import '../modules/alamat/bindings/alamat_binding.dart';
import '../modules/alamat/views/alamat_view.dart';
import '../modules/bast_darat/views/bast_darat_view.dart';
import '../modules/bast_makan/views/bast_makan_view.dart';
import '../modules/bast_pihak_lain/views/bast_pihak_lain_view.dart';
import '../modules/bast_udara/views/bast_udara_view.dart';
import '../modules/create_alamat/bindings/create_alamat_binding.dart';
import '../modules/create_alamat/views/create_alamat_view.dart';
import '../modules/create_bast_darat/bindings/create_bast_darat_binding.dart';
import '../modules/create_bast_darat/views/create_bast_darat_view.dart';
import '../modules/create_bast_makan/bindings/create_bast_makan_binding.dart';
import '../modules/create_bast_makan/views/create_bast_makan_view.dart';
import '../modules/create_bast_pihak_lain/bindings/create_bast_pihak_lain_binding.dart';
import '../modules/create_bast_pihak_lain/views/create_bast_pihak_lain_view.dart';
import '../modules/create_bast_udara/bindings/create_bast_udara_binding.dart';
import '../modules/create_bast_udara/views/create_bast_udara_view.dart';
import '../modules/create_imigran/bindings/create_imigran_binding.dart';
import '../modules/create_imigran/views/create_imigran_view.dart';
import '../modules/create_pengguna/bindings/create_pengguna_binding.dart';
import '../modules/create_pengguna/views/create_pengguna_view.dart';
import '../modules/create_penyedia_jasa/bindings/create_penyedia_jasa_binding.dart';
import '../modules/create_penyedia_jasa/views/create_penyedia_jasa_view.dart';
import '../modules/create_pihak_kedua/bindings/create_pihak_kedua_binding.dart';
import '../modules/create_pihak_kedua/views/create_pihak_kedua_view.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/detail_bast_darat/bindings/detail_bast_darat_binding.dart';
import '../modules/detail_bast_darat/views/detail_bast_darat_view.dart';
import '../modules/detail_bast_makan/bindings/detail_bast_makan_binding.dart';
import '../modules/detail_bast_makan/views/detail_bast_makan_view.dart';
import '../modules/detail_bast_pihak_lain/bindings/detail_bast_pihak_lain_binding.dart';
import '../modules/detail_bast_pihak_lain/views/detail_bast_pihak_lain_view.dart';
import '../modules/detail_bast_udara/bindings/detail_bast_udara_binding.dart';
import '../modules/detail_bast_udara/views/detail_bast_udara_view.dart';
import '../modules/detail_imigran/bindings/detail_imigran_binding.dart';
import '../modules/detail_imigran/views/detail_imigran_view.dart';
import '../modules/edit_alamat/bindings/edit_alamat_binding.dart';
import '../modules/edit_alamat/views/edit_alamat_view.dart';
import '../modules/edit_bast_darat/bindings/edit_bast_darat_binding.dart';
import '../modules/edit_bast_darat/views/edit_bast_darat_view.dart';
import '../modules/edit_bast_makan/bindings/edit_bast_makan_binding.dart';
import '../modules/edit_bast_makan/views/edit_bast_makan_view.dart';
import '../modules/edit_bast_pihak_lain/bindings/edit_bast_pihak_lain_binding.dart';
import '../modules/edit_bast_pihak_lain/views/edit_bast_pihak_lain_view.dart';
import '../modules/edit_bast_udara/bindings/edit_bast_udara_binding.dart';
import '../modules/edit_bast_udara/views/edit_bast_udara_view.dart';
import '../modules/edit_imigran/bindings/edit_imigran_binding.dart';
import '../modules/edit_imigran/views/edit_imigran_view.dart';
import '../modules/edit_pengguna/bindings/edit_pengguna_binding.dart';
import '../modules/edit_pengguna/views/edit_pengguna_view.dart';
import '../modules/edit_penyedia_jasa/bindings/edit_penyedia_jasa_binding.dart';
import '../modules/edit_penyedia_jasa/views/edit_penyedia_jasa_view.dart';
import '../modules/edit_pihak_kedua/bindings/edit_pihak_kedua_binding.dart';
import '../modules/edit_pihak_kedua/views/edit_pihak_kedua_view.dart';
import '../modules/fasilitas/views/fasilitas_view.dart';
import '../modules/imigran/views/imigran_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/keamanan/bindings/keamanan_binding.dart';
import '../modules/keamanan/views/keamanan_view.dart';
import '../modules/kepulangan/bindings/kepulangan_binding.dart';
import '../modules/kepulangan/views/kepulangan_view.dart';
import '../modules/laporan/bindings/laporan_binding.dart';
import '../modules/laporan/views/laporan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/pdf/bindings/pdf_binding.dart';
import '../modules/pdf/views/pdf_view.dart';
import '../modules/pengaturan/views/pengaturan_view.dart';
import '../modules/pengguna/bindings/pengguna_binding.dart';
import '../modules/pengguna/views/pengguna_view.dart';
import '../modules/penyedia_jasa/bindings/penyedia_jasa_binding.dart';
import '../modules/penyedia_jasa/views/penyedia_jasa_view.dart';
import '../modules/pihak_kedua/bindings/pihak_kedua_binding.dart';
import '../modules/pihak_kedua/views/pihak_kedua_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/spu/bindings/spu_binding.dart';
import '../modules/spu/views/spu_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.main;

  static final routes = [
    GetPage(
      name: _Paths.introduction,
      page: () => const IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    // Main
    GetPage(
      name: _Paths.main,
      page: () => const MainView(),
      binding: MainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.dashboard,
      page: () => const DashboardView(),
      binding: MainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.imigran,
      page: () => const ImigranView(),
      binding: MainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.fasilitas,
      page: () => const FasilitasView(),
      binding: MainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.pengaturan,
      page: () => const PengaturanView(),
      binding: MainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    // Imigran
    GetPage(
      name: _Paths.detailImigran,
      page: () => const DetailImigranView(),
      binding: DetailImigranBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.createImigran,
      page: () => const CreateImigranView(),
      binding: CreateImigranBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.editImigran,
      page: () => const EditImigranView(),
      binding: EditImigranBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.kepulangan,
      page: () => const KepulanganView(),
      binding: KepulanganBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
// Bast Makan
    GetPage(
      name: _Paths.bastMakan,
      page: () => const BastMakanView(),
      binding: MainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.createBastMakan,
      page: () => const CreateBastMakanView(),
      binding: CreateBastMakanBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.editBastMakan,
      page: () => const EditBastMakanView(),
      binding: EditBastMakanBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.detailBastMakan,
      page: () => const DetailBastMakanView(),
      binding: DetailBastMakanBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
// Bast Darat
    GetPage(
      name: _Paths.bastDarat,
      page: () => const BastDaratView(),
      binding: MainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.createBastDarat,
      page: () => const CreateBastDaratView(),
      binding: CreateBastDaratBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.editBastDarat,
      page: () => const EditBastDaratView(),
      binding: EditBastDaratBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.detailBastDarat,
      page: () => const DetailBastDaratView(),
      binding: DetailBastDaratBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
// Bast Duara
    GetPage(
      name: _Paths.bastUdara,
      page: () => const BastUdaraView(),
      binding: MainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.createBastUdara,
      page: () => const CreateBastUdaraView(),
      binding: CreateBastUdaraBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.editBastUdara,
      page: () => const EditBastUdaraView(),
      binding: EditBastUdaraBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.detailBastUdara,
      page: () => const DetailBastUdaraView(),
      binding: DetailBastUdaraBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.spu,
      page: () => const SpuView(),
      binding: SpuBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
// Bast Pihak Lain
    GetPage(
      name: _Paths.bastPihakLain,
      page: () => const BastPihakLainView(),
      binding: MainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.createBastPihakLain,
      page: () => const CreateBastPihakLainView(),
      binding: CreateBastPihakLainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.editBastPihakLain,
      page: () => const EditBastPihakLainView(),
      binding: EditBastPihakLainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.detailBastPihakLain,
      page: () => const DetailBastPihakLainView(),
      binding: DetailBastPihakLainBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
// Pengaturan
    GetPage(
      name: _Paths.profil,
      page: () => const ProfilView(),
      binding: ProfilBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.pihakKedua,
      page: () => const PihakKeduaView(),
      binding: PihakKeduaBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.createPihakKedua,
      page: () => const CreatePihakKeduaView(),
      binding: CreatePihakKeduaBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.editPihakKedua,
      page: () => const EditPihakKeduaView(),
      binding: EditPihakKeduaBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.alamat,
      page: () => const AlamatView(),
      binding: AlamatBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.createAlamat,
      page: () => const CreateAlamatView(),
      binding: CreateAlamatBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.editAlamat,
      page: () => const EditAlamatView(),
      binding: EditAlamatBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.penyediaJasa,
      page: () => const PenyediaJasaView(),
      binding: PenyediaJasaBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.createPenyediaJasa,
      page: () => const CreatePenyediaJasaView(),
      binding: CreatePenyediaJasaBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.editPenyediaJasa,
      page: () => const EditPenyediaJasaView(),
      binding: EditPenyediaJasaBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.koordinator,
      page: () => const KoordinatorView(),
      binding: KoordinatorBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.createKoordinator,
      page: () => const CreateKoordinatorView(),
      binding: CreateKoordinatorBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.editKoordinator,
      page: () => const EditKoordinatorView(),
      binding: EditKoordinatorBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.pengguna,
      page: () => const PenggunaView(),
      binding: PenggunaBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.createPengguna,
      page: () => const CreatePenggunaView(),
      binding: CreatePenggunaBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.editPengguna,
      page: () => const EditPenggunaView(),
      binding: EditPenggunaBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.keamanan,
      page: () => const KeamananView(),
      binding: KeamananBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.pdf,
      page: () => const PdfView(),
      binding: PdfBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
    GetPage(
      name: _Paths.laporan,
      page: () => const LaporanView(),
      binding: LaporanBinding(),
      middlewares: [
        IntroductionMiddleware(priority: 0),
        AuthMiddleware(priority: 1)
      ],
    ),
  ];
}
