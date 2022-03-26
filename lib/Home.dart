import 'dart:ui';
import 'package:test/expect.dart';
import 'package:http/http.dart' as http;
import 'utils/ClienteHelpers.dart';
import 'package:crud_desafio/model/Cliente.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? resultadoCep;
  // variavel global para validação
  final formKey = GlobalKey<FormState>();

  // CONTROLERS DOS CAMPOS DE TEXTO
  TextEditingController txtnome = TextEditingController();
  TextEditingController txttelefone = TextEditingController();
  TextEditingController txtcep = TextEditingController();
  TextEditingController txtuf = TextEditingController();
  TextEditingController txtcidade = TextEditingController();
  TextEditingController txtbairro = TextEditingController();
  TextEditingController txtrua = TextEditingController();
  TextEditingController txtnumerocasa = TextEditingController();

  // criando o listview
  List<Cliente> listadeClientes = [];

  // O objeto que salvar no banco de dados
  final ClienteHelpers _db = ClienteHelpers();

  //Implementando o metodo para salvar no bando de dados
  void salvarCliente({Cliente? clienteSelecionado}) {
    setState(() async {
      // verifica se o clienteSelecionado eh null ou nao
      // esta cadastrando um contato novo
      if (clienteSelecionado == null) {
        // passo 1 - criar um obj da classe contato para guardar as informações
        Cliente obj = Cliente(
            null,
            txtnome.text,
            txttelefone.text,
            txtcep.text,
            txtuf.text,
            txtcidade.text,
            txtbairro.text,
            txtrua.text,
            txtnumerocasa.text);

        int resultado = await _db.inserirCliente(obj);

        if (resultado != null) {
          print("Cadastrado com sucesso!" + resultado.toString());
        } else {
          print("Erro ao cadastrar!");
        }
      }
      // caso o obj clienteSelecionado esteja com dados
      // significa que esta alterando um contato existente
      else {
        // 1 passo eh armazenar os dados dos campos de texto e salvar
        // no objeto um clienteSelecionado existente
        clienteSelecionado.nome = txtnome.text;
        clienteSelecionado.telefone = txttelefone.text;
        clienteSelecionado.cep = txtcep.text;
        clienteSelecionado.uf = txtuf.text;
        clienteSelecionado.cidade = txtcidade.text;
        clienteSelecionado.bairro = txtbairro.text;
        clienteSelecionado.rua = txtrua.text;
        clienteSelecionado.numerocasa = txtnumerocasa.text;

        // 2 passo eh chamar o metodo de alterar dados
        int resultado = await _db.alterarCliente(clienteSelecionado);
        if (resultado != null) {
          print("Dados alteras com sucesso!" + resultado.toString());
        } else {
          print("Erro ao alterar!");
        }
      }

      // EXIBIR O NOVO ITEM ADD APOS CLICAR NO BOTAO SALVAR
      limparTela();
      recuperarClientes();
    });
  }

  void limparTela() {
    txtnome.clear();
    txttelefone.clear();
    txtcep.clear();
    txtuf.clear();
    txtcidade.clear();
    txtbairro.clear();
    txtrua.clear();
    txtnumerocasa.clear();
  }

  void recuperarClientes() async {
    // passo 1 - criar a lista
    List clientesRecuperados = await _db.listarClientes();
    //print("Contatos cadastrados: " + clientesRecuperados.toString());

    List<Cliente> listatemporaria = [];
    for (var item in clientesRecuperados) {
      Cliente cc = Cliente.deMapParaModel(item);
      listatemporaria.add(cc);
    }

    setState(() {
      listadeClientes = listatemporaria;
    });

    listatemporaria;
  }

  void removerCliente(int id) async {
    int resultado = await _db.excluirCliente(id);
    recuperarClientes();
  }

  void exibirTelaConfirma(id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Excluir Cliente"),
            content: const Text("Tem certeza que deseja excluir?"),
            backgroundColor: Colors.white,
            actions: <Widget>[
              ElevatedButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  //onPrimary: Colors.red, // foreground
                ),
                onPressed: () {
                  print("clicou no cancelar!");
                  Navigator.pop(context);
                },
              ),

              /// botao
              ElevatedButton(
                child: const Text(
                  "Sim",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  print("clicou no sim!");
                  removerCliente(id);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void exibirTelaCadastro({Cliente? cliente}) async {
    /// variaveis de titulo
    String textoTitulo = "";
    String textobotao = "";
    // cadastrando novo usuário
    if (cliente == null) {
      textoTitulo = "Adicionar um cliente";
      textobotao = "Salvar";
    } else {
      textoTitulo = "Editar um cliente";
      textobotao = "Editar";

      txtnome.text = cliente.nome;
      txttelefone.text = cliente.telefone;
      txtcep.text = cliente.cep;
      txtuf.text = cliente.uf;
      txtcidade.text = cliente.cidade;
      txtbairro.text = cliente.bairro;
      txtrua.text = cliente.rua;
      txtnumerocasa.text = cliente.numerocasa;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: Text("$textoTitulo"),
//-------------------------------------------------

          content: SingleChildScrollView(
            child: Center(
              child: Form(
                // variavel para validação de campos
                key: formKey,

                child: Column(
                  // tamanho do forms no alert dialog
                  // mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // -------------------------------------------------
                    /** CAMPO DO NOME */
                    TextFormField(
                      controller: txtnome,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório!';
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: "Nome",
                          hintText: "Exemplo: Felipe",
                          prefixIcon: Icon(Icons.perm_identity)),
                    ),

                    /** CAMPO DO TELEFONE */
                    TextFormField(
                      controller: txttelefone,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: const InputDecoration(
                          labelText: "Telefone",
                          hintText: "Exemplo: (92) 9 9999-9999",
                          prefixIcon: Icon(Icons.phone)),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório!';
                        }
                      },
                    ),

                    /** CEP */
                    TextFormField(
                      controller: txtcep,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: const InputDecoration(
                          labelText: "CEP",
                          hintText: "Exemplo: 69103108",
                          suffixIcon: Icon(Icons.search),
                          prefixIcon: Icon(Icons.add_location_rounded)),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório!';
                        }
                      },
                    ),

                    /** CAMPO DO UF */
                    TextFormField(
                      controller: txtuf,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório!';
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "UF",
                        hintText: "Exemplo: Amazonas",
                        prefixIcon: Icon(Icons.home),
                      ),
                    ),

                    /** CAMPO DO CIDADE */
                    TextFormField(
                      controller: txtcidade,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório!';
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "Cidade",
                        hintText: "Exemplo: Itacoatiara",
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),

                    /** CAMPO DO BAIRRO */
                    TextFormField(
                      controller: txtbairro,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório!';
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "Bairro",
                        hintText: "Exemplo: Tiradentes",
                        prefixIcon: Icon(Icons.emoji_flags),
                      ),
                    ),

                    /** CAMPO DO RUA */
                    TextFormField(
                      controller: txtrua,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório!';
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "Rua",
                        hintText: "Exemplo: Acácio Leite",
                        prefixIcon: Icon(Icons.streetview),
                      ),
                    ),

                    /** CAMPO DO NUMERO DA CASA */
                    TextFormField(
                      controller: txtnumerocasa,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório!';
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "Nº da casa",
                        hintText: "Exemplo: Apt 42B5",
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              style: TextButton.styleFrom(
                primary: Colors.red, // background
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("$textobotao"),
              onPressed: () {
                // chama a funcao para validar formulario
                // valida o formulario mas ainda cria no banco de dados
                formKey.currentState?.validate();

                // chama a funcao para criar no banco
                salvarCliente(clienteSelecionado: cliente);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // chama o petodo para listar clientes
    recuperarClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de clientes"),
      ),

      ///---------------------------------------------------
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: listadeClientes.length,
                itemBuilder: (context, index) {
                  final Cliente obj = listadeClientes[index];

                  return Card(
                    child: ListTile(
                        title: Text(obj.nome),
                        subtitle: Text("CEP: " + obj.cep),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    exibirTelaConfirma(obj.id);
                                    print("Clicou em Delete!");
                                  },
                                  child: const Padding(
                                      padding: EdgeInsets.only(right: 16),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    /// PASSO O OBJETO MAS NÃO PUXA OS DADOS QUANDO CLICO EM EDITAR
                                    exibirTelaCadastro(cliente: obj);
                                  },
                                  child: const Padding(
                                      padding: EdgeInsets.only(right: 16),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ))),
                            ])),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          limparTela();
          exibirTelaCadastro();
        },
      ),
    );
  }
}
