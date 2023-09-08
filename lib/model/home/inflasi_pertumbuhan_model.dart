class InflasiPertumbuhanModel {
  Inflasi? inflasi;
  PertumbuhanEkonomi? pertumbuhanEkonomi;

  InflasiPertumbuhanModel({this.inflasi, this.pertumbuhanEkonomi});

  InflasiPertumbuhanModel.fromJson(Map<String, dynamic> json) {
    inflasi =
        json['inflasi'] != null ? Inflasi.fromJson(json['inflasi']) : null;
    pertumbuhanEkonomi = json['pertumbuhan_ekonomi'] != null
        ? PertumbuhanEkonomi.fromJson(json['pertumbuhan_ekonomi'])
        : null;
  }
}

class Inflasi {
  int? id;
  String? tanggal;
  int? prosentase;
  Perubahan? inflasiPerubahan;

  Inflasi({this.id, this.tanggal, this.prosentase, this.inflasiPerubahan});

  Inflasi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tanggal = json['tanggal'];
    prosentase = json['prosentase'];
    inflasiPerubahan = json['inflasi-perubahan'] != null
        ? Perubahan.fromJson(json['inflasi-perubahan'])
        : null;
  }
}

class Perubahan {
  String? status;
  int? nilai;

  Perubahan({this.status, this.nilai});

  Perubahan.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    nilai = json['nilai'];
  }
}

class PertumbuhanEkonomi {
  int? id;
  String? tanggal;
  int? prosentase;
  Perubahan? pertumbuhanEkonomiPerubahan;

  PertumbuhanEkonomi(
      {this.id,
      this.tanggal,
      this.prosentase,
      this.pertumbuhanEkonomiPerubahan});

  PertumbuhanEkonomi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tanggal = json['tanggal'];
    prosentase = json['prosentase'];
    pertumbuhanEkonomiPerubahan = json['pertumbuhan_ekonomi-perubahan'] != null
        ? Perubahan.fromJson(json['pertumbuhan_ekonomi-perubahan'])
        : null;
  }
}
