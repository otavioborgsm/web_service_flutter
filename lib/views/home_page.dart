import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:web_service/services/via_cep_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  String? _result;
  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'CONSULTA CEP',
            style: TextStyle(
              color: Color.fromARGB(255, 70, 70, 70),
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: 2
            ),  
          )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultForm()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(labelText: 'Cep'),
      style: const TextStyle(fontSize: 22, color: Colors.black),
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child:  ElevatedButton(
        onPressed: _searchCep,
        child: _loading ? _circularLoading() : const Text('Consultar'),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 15.0,
      width: 15.0,
      child: const CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    try{
      if (cep.length == 8) {
        final resultCep = await ViaCepService.fetchCep(cep: cep);

        setState(() {
          _result = resultCep.toJson();
        });

        _searching(false);
      }else{
        await Flushbar(
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 30
          ),
          message: 'O CEP deve conter 8 digitos.',
          messageSize: 20,
          duration: const Duration(seconds: 3),
        ).show(context);
        _searching(false);
      }
    }catch(e){
        await Flushbar(
          icon: const Icon(
            Icons.error,
            color: Colors.white,
            size: 30
          ),
          message: e.toString(),
          messageSize: 20,
          duration: const Duration(seconds: 3),
        ).show(context);
        _searching(false);
      }
  }

  Widget _buildResultForm() {
      return Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(_result ?? ''),
      );
  }


}