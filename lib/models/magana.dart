class Magana {
  String _codice;
  String _descrizion;
  bool _isFiscale;
  bool _isLock;

  Magana(
    this._codice,
    [
      this._descrizion='',
      this._isFiscale=false,
      this._isLock=false
    ]
  );

  String get codice => _codice;
  String get descrizion => _descrizion;
  bool get isFiscale => _isFiscale;
  bool get isLock => _isLock;
  
  Magana.fromJson(Map<String, dynamic> json){
    _codice = json['codice'].trim();
    _descrizion = json['descrizion'].trim();
    _isFiscale = json['fiscale'];
    _isLock = json['u_lock'];
  }
}