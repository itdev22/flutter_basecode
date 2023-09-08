import '../jenis_pasar_model.dart';
import '../komoditas_model.dart';
import '../kota_model.dart';
import '../sub_komoditas_model.dart';

class HomeModel {
  List<KomoditasModel>? komoditas;
  List<SubKomoditasModel>? subKomoditas;
  List<KotaModel>? kota;
  List<JenisPasarModel>? jenisPasar;

  HomeModel({
    this.komoditas,
    this.subKomoditas,
    this.kota,
    this.jenisPasar,
  });

  factory HomeModel.fromJson(Map<String, dynamic> data) => HomeModel(
      komoditas: List.generate(
        data['komoditas'].length,
        (index) => KomoditasModel.fromJson(data['komoditas'][index]),
      ),
      kota: List.generate(data['kota'].length,
          (index) => KotaModel.fromJson(data['kota'][index])),
      subKomoditas: List.generate(data['subkomoditas'].length,
          (index) => SubKomoditasModel.fromJson(data['subkomoditas'][index])),
      jenisPasar: List.generate(data['jenispasar'].length,
          (index) => JenisPasarModel.fromJson(data['jenispasar'][index])));
}
