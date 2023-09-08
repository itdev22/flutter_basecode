import '../rekap_harga_model.dart';

class TradeModel {
  int? id;
  int? komoditasId;
  String? nama;
  String? tanggal;
  List<RekapHargaModel>? rekapharga;
  Map? indicator;

  TradeModel(
      {this.id, this.komoditasId, this.nama, this.tanggal, this.rekapharga});

  TradeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    komoditasId = json['komoditas_id'];
    nama = json['nama'];
    tanggal = json['tanggal'];
    rekapharga = List<RekapHargaModel>.generate(json['rekapharga'].length,
        (index) => RekapHargaModel.fromJson(json['rekapharga'][index]));
    indicator = json['indicator'];
  }
}
