import 'dart:io';

import 'package:crud_desafio/model/Cliente.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ClienteHelpers {
  // criar e conectar ao banco de dados
  // usa-se o padrão de projeto Singleton para essa conexão
  static ClienteHelpers? _databasehelper;
  static Database? _database;

  // Definindo a estrutura da Tabela
  String nomeTabela = 'tbl_clientes';
  String colId = 'id';
  String colNome = 'nome';
  String colTelefone = 'telefone';
  String colCep = 'cep';
  String colUF = 'uf';
  String colCidade = 'cidade';
  String colBairro = 'bairro';
  String colRua = 'rua';
  String colNumeroCasa = 'numerocasa';

  ClienteHelpers._createInstance();
  factory ClienteHelpers() {
    if (_databasehelper != null) {
      _databasehelper;
    }
    return _databasehelper = ClienteHelpers._createInstance();
  }

  // Métodos cria a tabela clinte
  void _criaBanco(Database db, int versao) async {
    String sql = """CREATE TABLE $nomeTabela (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colNome Text,
          $colTelefone Text,
          $colCep Text,
          $colUF Text,
          $colCidade Text,
          $colBairro Text,
          $colRua Text,
          $colNumeroCasa Text
      )""";

    await db.execute(sql);
  }

  Future<Database> inicializaBanco() async {
    // pega o caminho dos android ou ios para salvar o banco de dados
    Directory pasta = await getApplicationDocumentsDirectory();
    String caminho = pasta.path + 'bdclientes.bd';

    var bancodedados =
        await openDatabase(caminho, version: 1, onCreate: _criaBanco);
    return bancodedados;
  }

  // Criar o metodo que verifica se o banco foi inicializado
  Future<Database> get database async {
    if (_database != null) {
      _database;
    }
    return _database = await inicializaBanco();
  }

  // Método para Cadastrar cliente
  Future<int> inserirCliente(Cliente obj) async {
    // passo 1 - selecionar o banco de dados
    Database db = await database;
    var resultado = await db.insert(nomeTabela, obj.toMap());
    return resultado;
  }

  // Método que lista os clientes
  listarClientes() async {
    // passo 1 - selecionar o banco de dados
    Database db = await database;
    String sql = "SELECT * FROM $nomeTabela";
    List listaclientes = await db.rawQuery(sql);

    return listaclientes;
  }

  // Método para Excluir um cliente
  Future<int> excluirCliente(int id) async {
    // Seleciona o banco de dadas
    Database db = await database;
    return await db.delete(nomeTabela, where: "id = ?", whereArgs: [id]);
  }

  // Método para Editar um cliente
  Future<int> alterarCliente(Cliente obj) async {
    // seleciona o banco de dados
    Database db = await database;

    return await db
        .update(nomeTabela, obj.toMap(), where: "id = ?", whereArgs: [obj.id]);
  }
}
