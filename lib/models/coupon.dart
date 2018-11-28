class Coupon {
  String _codicearti;
  double _quantita;
  String _magazzino;
  String _lotto;
  int _idterm;
  String _codcart;
  String _esercizio;
  String _ubicaz;
  bool _isWarn;

  Coupon(
    this._codcart,
    [
      this._codicearti='',
      this._magazzino='',
      this._quantita=0.0,
      this._lotto='',
      this._esercizio='',
      this._ubicaz='',
      this._idterm=0,
      this._isWarn=false
    ]
  );

  String get codcart => _codcart;
  String get codicearti => _codicearti;
  String get magazzino => _magazzino;
  double get quantita => _quantita;
  String get lotto => _lotto;
  String get esercizio => _esercizio;
  String get ubicaz => _ubicaz;
  int get idterm => _idterm;
  bool get isWart => _isWarn;
  
  Coupon.fromJson(Map<String, dynamic> json){
    _codcart = json['codcart'];
    _codicearti = json['codicearti'];
    _magazzino = json['magazzino'];
    _quantita = json['quantita'].toDouble();
    _lotto = json['lotto'];
    _esercizio = json['esercizio'];
    _ubicaz = json['ubicaz'];
    _idterm = (json['id_term'] is String) ? int.parse(json['id_term']) : json['id_term'];
    _isWarn = json['warn'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["coupon"] = _codcart;
    map["codart"] = _codicearti;
    map["codmag"] = _magazzino;
    map["qta"] = _quantita.toString();
    map["codlot"] = _lotto;
    map["esercizio"] = _esercizio;
    map["ubicaz"] = _ubicaz;
    map["idterm"] = _idterm.toString();
    return map;
  }
}