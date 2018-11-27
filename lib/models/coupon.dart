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
    _idterm = int.parse(json['id_term']);
    _isWarn = json['warn'].toBoolean();
  }

}