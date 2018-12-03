class Article {
  String _codice;
  String _descrizion;
  String _gruppo;
  double _pesounit;
  double _misural;
  double _misurah;
  double _misuras;
  String _unmisura;
  String _unmisura2;
  String _unmisura3;
  double _fatt2;
  double _fatt3;
  bool _isLotto;

  Article(
    this._codice,
    [
      this._descrizion='',
      this._gruppo='',
      this._pesounit=0.0,
      this._misural=0.0,
      this._misurah=0.0,
      this._misuras=0.0,
      this._unmisura='',
      this._unmisura2='',
      this._unmisura3='',
      this._fatt2=0.0,
      this._fatt3=0.0,
      this._isLotto=false,
    ]
  );

  String get codice => _codice;
  String get descrizion => _descrizion;
  String get gruppo => _gruppo;
  double get pesounit => _pesounit;
  double get misural => _misural;
  double get misurah => _misurah;
  double get misuras => _misuras;
  String get unmisura => _unmisura;
  String get unmisura2 => _unmisura2;
  String get unmisura3 => _unmisura3;
  double get fatt2 => _fatt2;
  double get fatt3 => _fatt3;
  bool get isLotto => _isLotto;
  
  Article.fromJson(Map<String, dynamic> json){
    _codice = json['codice'].trim();
    _descrizion = json['descrizion'].trim();
    _gruppo = json['gruppo'].trim();
    _pesounit = json['pesounit'].toDouble();
    _misural = json['u_misural'].toDouble();
    _misurah = json['u_misurah'].toDouble();
    _misuras = json['u_misuras'].toDouble();
    _unmisura = json['unmisura'].trim();
    _unmisura2 = json['unmisura2'].trim();
    _unmisura3 = json['unmisura3'].trim();
    _fatt2 = json['fatt2'].toDouble();
    _fatt3 = json['fatt3'].toDouble();
    _isLotto = json['lotti'];
  }

}