class Giac {
  String _articolo;
  String _magazzino;
  String _descrMag;
  String _unmisura;
  double _esistenza;

  Giac(
    this._articolo,
    this._magazzino,
    this._descrMag,
    this._unmisura,
    this._esistenza
  );

  String get articolo => _articolo;
  String get magazzino => _magazzino;
  String get descrMag => _descrMag;
  String get unmisura => _unmisura;
  double get esistenza => _esistenza;
  
  Giac.fromJson(Map<String, dynamic> json){
    _articolo = json['articolo'].trim();
    _magazzino = json['magazzino'].trim();
    _descrMag = json['magdesc'].trim();
    _unmisura = json['unmisura'].trim();
    _esistenza = json['esistenza'].toDouble();
  }

}