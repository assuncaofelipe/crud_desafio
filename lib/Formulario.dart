import 'dart:convert';

import 'package:crud_desafio/Home.dart';
import 'package:crud_desafio/model/Cliente.dart';
import 'package:crud_desafio/tratamentoTextTelefone.dart';
import 'package:crud_desafio/utils/ClienteHelpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Formulario extends StatefulWidget {
  const Formulario({Key? key}) : super(key: key);

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  // CONTROLADORES
  TextEditingController txtnome = TextEditingController();
  TextEditingController txttelefone = TextEditingController();
  TextEditingController txtcep = TextEditingController();
  TextEditingController txtuf = TextEditingController();
  TextEditingController txtcidade = TextEditingController();
  TextEditingController txtbairro = TextEditingController();
  TextEditingController txtrua = TextEditingController();
  TextEditingController txtnumerocasa = TextEditingController();

  String? resultado;

  // O objeto que salvar no banco de dados
  final ClienteHelpers _db = ClienteHelpers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulário"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(
                height: 60,
              ),
              const SizedBox(
                height: 40,
                width: 110,
              ),
              ElevatedButton(
                child: const Text(
                  "Salvar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                  salvarCliente();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

// funções e metodos

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
            onTap: consultaCep,
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
            onPressed: consultaCep,
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

  consultaCep() async {
    // Variáveis que receberão os dados do WebService
    String cep = txtcep.text;
    String url = "https://viacep.com.br/ws/{$cep}/json/";
    http.Response response;
    response = await http.get(Uri.parse(url));

    Map<String, dynamic> retorno = json.decode(response.body);

    // variáveis recebendo os dados em JSON da API
    String logradouro = retorno["logradouro"];
    String localidade = retorno["localidade"];
    String bairro = retorno["bairro"];
    String uf = retorno["uf"];

    setState(() {
      String resultado =
          "Rua: $logradouro, Bairro: $bairro, Cidade: $localidade, Estado: $uf";

      print(resultado);
    });
  }

  //Implementando o metodo para salvar no bando de dados
  void salvarCliente() {
    setState(() async {
      int? aidi;
      Cliente obj = Cliente(
          aidi,
          txtnome.text,
          txttelefone.text,
          txtcep.text,
          txtuf.text,
          txtcidade.text,
          txtbairro.text,
          txtrua.text,
          txtnumerocasa.text);

      int resultado = await _db.inserirCliente(obj);
    });
  }
}
