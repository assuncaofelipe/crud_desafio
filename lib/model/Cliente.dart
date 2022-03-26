class Cliente {
  // ATRIBUTPS
  int? _id;
  String? _nome;
  String? _telefone;
  String? _cep;
  String? _uf;
  String? _cidade;
  String? _bairro;
  String? _rua;
  String? _numerocasa;

  // CONSTRUTOR
  Cliente(this._id, this._nome, this._telefone, this._cep, this._uf,
      this._cidade, this._bairro, this._rua, this._numerocasa);

  // GETTERS AND SETTERS
  get id => _id;

  set id(value) => _id = value;

  get nome => _nome;

  set nome(value) => _nome = value;

  get telefone => _telefone;

  set telefone(value) => _telefone = value;

  get cep => _cep;

  set cep(value) => _cep = value;

  get uf => _uf;

  set uf(value) => _uf = value;

  get cidade => _cidade;

  set cidade(value) => _cidade = value;

  get bairro => _bairro;

  set bairro(value) => _bairro = value;

  get rua => _rua;

  set rua(value) => _rua = value;

  get numerocasa => _numerocasa;

  set numerocasa(value) => _numerocasa = value;

  // MÉTODO PARA CONVERTER O MODEL PARA MAP
  Map<String, dynamic> toMap() {
    // passo 1 - criando o map
    var dados = Map<String, dynamic>();

    dados['id'] = _id;
    dados['nome'] = _nome;
    dados['telefone'] = _telefone;
    dados['cep'] = _cep;
    dados['uf'] = _uf;
    dados['cidade'] = _cidade;
    dados['bairro'] = _bairro;
    dados['rua'] = _rua;
    dados['numerocasa'] = _numerocasa;

    return dados;
  }

  // MÉTODO PARA CONVERTER O MAP PARA MODEL
  Cliente.deMapParaModel(Map<String, dynamic> dados) {
    _id = dados['id'];
    _nome = dados['nome'];
    _telefone = dados['telefone'];
    _cep = dados['cep'];
    _uf = dados['uf'];
    _cidade = dados['cidade'];
    _bairro = dados['bairro'];
    _rua = dados['rua'];
    _numerocasa = dados['numerocasa'];
  }
}
