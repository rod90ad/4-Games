class BlockOpen {

  static BlockOpen _instance;
  bool _blocked;

  BlockOpen(){
    _blocked = false;
  }

  bool isBlocked(){
    return _blocked;
  }

  void setBlocked(bool value){
    _blocked = value;
  }

  static BlockOpen getInstance(){
    if(_instance==null)
      _instance = BlockOpen();
    return _instance;
  }
}