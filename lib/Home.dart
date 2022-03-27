import 'dart:convert';
import 'package:crud_desafio/Formulario.dart';
import 'package:crud_desafio/tratamentoTextTelefone.dart';
import 'package:flutter/services.dart';
import 'utils/ClienteHelpers.dart';
import 'package:crud_desafio/model/Cliente.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // chama o petodo para listar clientes
    recuperarClientes();
  }

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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Formulario()));
          //limparTela();
          //exibirTelaCadastro();
        },
      ),
    );
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                const SizedBox(
                  height: 10,
                ),
                _buildPhone(),
                const SizedBox(
                  height: 10,
                ),
                _buildConsultaCep(),
                const SizedBox(
                  height: 10,
                ),
                _buildEndereco(),
              ],
            ),
          )),
          actions: [
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
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text(
                "$textobotao",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // background
                //onPrimary: Colors.red, // foreground
              ),
              onPressed: () {
                salvarCliente(clienteSelecionado: cliente);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

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

  Widget _buildName() {
    return TextField(
      controller: txtnome,
      decoration: const InputDecoration(
        labelText: 'Nome',
      ),
    );
  }

  Widget _buildPhone() {
    return TextField(
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter()
      ],
      controller: txttelefone,
      decoration: const InputDecoration(
        labelText: 'Telefone*',
      ),
    );
  }

  Widget _buildConsultaCep() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextField(
            maxLength: 8,
            controller: txtcep,
            decoration: const InputDecoration(
              counterText: "",
              labelText: 'Digite o CEP',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Container(
          height: 40,
          width: 60,
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
            child: const Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Widget _buildEndereco() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Cidade: ',
                ),
                controller: txtcidade,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 80,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'UF',
                ),
                controller: txtuf,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Rua',
                ),
                controller: txtrua,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 80,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Nº',
                ),
                controller: txtnumerocasa,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                ),
                controller: txtbairro,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        )
      ],
    );
  }
}
