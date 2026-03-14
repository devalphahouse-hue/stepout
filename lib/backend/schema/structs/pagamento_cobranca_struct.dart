// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PagamentoCobrancaStruct extends BaseStruct {
  PagamentoCobrancaStruct({
    String? nome,
    String? email,
    String? telefone,
    String? cep,
    String? endereco,
    String? bairro,
    String? cidade,
    String? cpfAluno,
    String? numero,
    String? uf,
    String? plano,
    String? idFranquiaIndicou,
    double? valor,
    double? valorParcelas,
    int? numParcelas,
    String? formaPagamento,
    String? imagemQr,
    String? pixCopiaCola,
    String? status,
    String? idClienteAsaas,
    String? walletFranquiaAluno,
    String? idpagamentoAsaas,
    DateTime? validadePlano,
    String? visibilidadePagamento,
  })  : _nome = nome,
        _email = email,
        _telefone = telefone,
        _cep = cep,
        _endereco = endereco,
        _bairro = bairro,
        _cidade = cidade,
        _cpfAluno = cpfAluno,
        _numero = numero,
        _uf = uf,
        _plano = plano,
        _idFranquiaIndicou = idFranquiaIndicou,
        _valor = valor,
        _valorParcelas = valorParcelas,
        _numParcelas = numParcelas,
        _formaPagamento = formaPagamento,
        _imagemQr = imagemQr,
        _pixCopiaCola = pixCopiaCola,
        _status = status,
        _idClienteAsaas = idClienteAsaas,
        _walletFranquiaAluno = walletFranquiaAluno,
        _idpagamentoAsaas = idpagamentoAsaas,
        _validadePlano = validadePlano,
        _visibilidadePagamento = visibilidadePagamento;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "telefone" field.
  String? _telefone;
  String get telefone => _telefone ?? '';
  set telefone(String? val) => _telefone = val;

  bool hasTelefone() => _telefone != null;

  // "cep" field.
  String? _cep;
  String get cep => _cep ?? '';
  set cep(String? val) => _cep = val;

  bool hasCep() => _cep != null;

  // "endereco" field.
  String? _endereco;
  String get endereco => _endereco ?? '';
  set endereco(String? val) => _endereco = val;

  bool hasEndereco() => _endereco != null;

  // "bairro" field.
  String? _bairro;
  String get bairro => _bairro ?? '';
  set bairro(String? val) => _bairro = val;

  bool hasBairro() => _bairro != null;

  // "cidade" field.
  String? _cidade;
  String get cidade => _cidade ?? '';
  set cidade(String? val) => _cidade = val;

  bool hasCidade() => _cidade != null;

  // "cpfAluno" field.
  String? _cpfAluno;
  String get cpfAluno => _cpfAluno ?? '';
  set cpfAluno(String? val) => _cpfAluno = val;

  bool hasCpfAluno() => _cpfAluno != null;

  // "numero" field.
  String? _numero;
  String get numero => _numero ?? '';
  set numero(String? val) => _numero = val;

  bool hasNumero() => _numero != null;

  // "uf" field.
  String? _uf;
  String get uf => _uf ?? '';
  set uf(String? val) => _uf = val;

  bool hasUf() => _uf != null;

  // "plano" field.
  String? _plano;
  String get plano => _plano ?? '';
  set plano(String? val) => _plano = val;

  bool hasPlano() => _plano != null;

  // "id_franquia_indicou" field.
  String? _idFranquiaIndicou;
  String get idFranquiaIndicou => _idFranquiaIndicou ?? '';
  set idFranquiaIndicou(String? val) => _idFranquiaIndicou = val;

  bool hasIdFranquiaIndicou() => _idFranquiaIndicou != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  set valor(double? val) => _valor = val;

  void incrementValor(double amount) => valor = valor + amount;

  bool hasValor() => _valor != null;

  // "valorParcelas" field.
  double? _valorParcelas;
  double get valorParcelas => _valorParcelas ?? 0.0;
  set valorParcelas(double? val) => _valorParcelas = val;

  void incrementValorParcelas(double amount) =>
      valorParcelas = valorParcelas + amount;

  bool hasValorParcelas() => _valorParcelas != null;

  // "NumParcelas" field.
  int? _numParcelas;
  int get numParcelas => _numParcelas ?? 0;
  set numParcelas(int? val) => _numParcelas = val;

  void incrementNumParcelas(int amount) => numParcelas = numParcelas + amount;

  bool hasNumParcelas() => _numParcelas != null;

  // "FormaPagamento" field.
  String? _formaPagamento;
  String get formaPagamento => _formaPagamento ?? '';
  set formaPagamento(String? val) => _formaPagamento = val;

  bool hasFormaPagamento() => _formaPagamento != null;

  // "imagemQr" field.
  String? _imagemQr;
  String get imagemQr => _imagemQr ?? '';
  set imagemQr(String? val) => _imagemQr = val;

  bool hasImagemQr() => _imagemQr != null;

  // "pixCopiaCola" field.
  String? _pixCopiaCola;
  String get pixCopiaCola => _pixCopiaCola ?? '';
  set pixCopiaCola(String? val) => _pixCopiaCola = val;

  bool hasPixCopiaCola() => _pixCopiaCola != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "idClienteAsaas" field.
  String? _idClienteAsaas;
  String get idClienteAsaas => _idClienteAsaas ?? '';
  set idClienteAsaas(String? val) => _idClienteAsaas = val;

  bool hasIdClienteAsaas() => _idClienteAsaas != null;

  // "walletFranquiaAluno" field.
  String? _walletFranquiaAluno;
  String get walletFranquiaAluno => _walletFranquiaAluno ?? '';
  set walletFranquiaAluno(String? val) => _walletFranquiaAluno = val;

  bool hasWalletFranquiaAluno() => _walletFranquiaAluno != null;

  // "idpagamentoAsaas" field.
  String? _idpagamentoAsaas;
  String get idpagamentoAsaas => _idpagamentoAsaas ?? '';
  set idpagamentoAsaas(String? val) => _idpagamentoAsaas = val;

  bool hasIdpagamentoAsaas() => _idpagamentoAsaas != null;

  // "validadePlano" field.
  DateTime? _validadePlano;
  DateTime? get validadePlano => _validadePlano;
  set validadePlano(DateTime? val) => _validadePlano = val;

  bool hasValidadePlano() => _validadePlano != null;

  // "VisibilidadePagamento" field.
  String? _visibilidadePagamento;
  String get visibilidadePagamento => _visibilidadePagamento ?? '';
  set visibilidadePagamento(String? val) => _visibilidadePagamento = val;

  bool hasVisibilidadePagamento() => _visibilidadePagamento != null;

  static PagamentoCobrancaStruct fromMap(Map<String, dynamic> data) =>
      PagamentoCobrancaStruct(
        nome: data['nome'] as String?,
        email: data['email'] as String?,
        telefone: data['telefone'] as String?,
        cep: data['cep'] as String?,
        endereco: data['endereco'] as String?,
        bairro: data['bairro'] as String?,
        cidade: data['cidade'] as String?,
        cpfAluno: data['cpfAluno'] as String?,
        numero: data['numero'] as String?,
        uf: data['uf'] as String?,
        plano: data['plano'] as String?,
        idFranquiaIndicou: data['id_franquia_indicou'] as String?,
        valor: castToType<double>(data['valor']),
        valorParcelas: castToType<double>(data['valorParcelas']),
        numParcelas: castToType<int>(data['NumParcelas']),
        formaPagamento: data['FormaPagamento'] as String?,
        imagemQr: data['imagemQr'] as String?,
        pixCopiaCola: data['pixCopiaCola'] as String?,
        status: data['status'] as String?,
        idClienteAsaas: data['idClienteAsaas'] as String?,
        walletFranquiaAluno: data['walletFranquiaAluno'] as String?,
        idpagamentoAsaas: data['idpagamentoAsaas'] as String?,
        validadePlano: data['validadePlano'] as DateTime?,
        visibilidadePagamento: data['VisibilidadePagamento'] as String?,
      );

  static PagamentoCobrancaStruct? maybeFromMap(dynamic data) => data is Map
      ? PagamentoCobrancaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'email': _email,
        'telefone': _telefone,
        'cep': _cep,
        'endereco': _endereco,
        'bairro': _bairro,
        'cidade': _cidade,
        'cpfAluno': _cpfAluno,
        'numero': _numero,
        'uf': _uf,
        'plano': _plano,
        'id_franquia_indicou': _idFranquiaIndicou,
        'valor': _valor,
        'valorParcelas': _valorParcelas,
        'NumParcelas': _numParcelas,
        'FormaPagamento': _formaPagamento,
        'imagemQr': _imagemQr,
        'pixCopiaCola': _pixCopiaCola,
        'status': _status,
        'idClienteAsaas': _idClienteAsaas,
        'walletFranquiaAluno': _walletFranquiaAluno,
        'idpagamentoAsaas': _idpagamentoAsaas,
        'validadePlano': _validadePlano,
        'VisibilidadePagamento': _visibilidadePagamento,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'telefone': serializeParam(
          _telefone,
          ParamType.String,
        ),
        'cep': serializeParam(
          _cep,
          ParamType.String,
        ),
        'endereco': serializeParam(
          _endereco,
          ParamType.String,
        ),
        'bairro': serializeParam(
          _bairro,
          ParamType.String,
        ),
        'cidade': serializeParam(
          _cidade,
          ParamType.String,
        ),
        'cpfAluno': serializeParam(
          _cpfAluno,
          ParamType.String,
        ),
        'numero': serializeParam(
          _numero,
          ParamType.String,
        ),
        'uf': serializeParam(
          _uf,
          ParamType.String,
        ),
        'plano': serializeParam(
          _plano,
          ParamType.String,
        ),
        'id_franquia_indicou': serializeParam(
          _idFranquiaIndicou,
          ParamType.String,
        ),
        'valor': serializeParam(
          _valor,
          ParamType.double,
        ),
        'valorParcelas': serializeParam(
          _valorParcelas,
          ParamType.double,
        ),
        'NumParcelas': serializeParam(
          _numParcelas,
          ParamType.int,
        ),
        'FormaPagamento': serializeParam(
          _formaPagamento,
          ParamType.String,
        ),
        'imagemQr': serializeParam(
          _imagemQr,
          ParamType.String,
        ),
        'pixCopiaCola': serializeParam(
          _pixCopiaCola,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'idClienteAsaas': serializeParam(
          _idClienteAsaas,
          ParamType.String,
        ),
        'walletFranquiaAluno': serializeParam(
          _walletFranquiaAluno,
          ParamType.String,
        ),
        'idpagamentoAsaas': serializeParam(
          _idpagamentoAsaas,
          ParamType.String,
        ),
        'validadePlano': serializeParam(
          _validadePlano,
          ParamType.DateTime,
        ),
        'VisibilidadePagamento': serializeParam(
          _visibilidadePagamento,
          ParamType.String,
        ),
      }.withoutNulls;

  static PagamentoCobrancaStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PagamentoCobrancaStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        telefone: deserializeParam(
          data['telefone'],
          ParamType.String,
          false,
        ),
        cep: deserializeParam(
          data['cep'],
          ParamType.String,
          false,
        ),
        endereco: deserializeParam(
          data['endereco'],
          ParamType.String,
          false,
        ),
        bairro: deserializeParam(
          data['bairro'],
          ParamType.String,
          false,
        ),
        cidade: deserializeParam(
          data['cidade'],
          ParamType.String,
          false,
        ),
        cpfAluno: deserializeParam(
          data['cpfAluno'],
          ParamType.String,
          false,
        ),
        numero: deserializeParam(
          data['numero'],
          ParamType.String,
          false,
        ),
        uf: deserializeParam(
          data['uf'],
          ParamType.String,
          false,
        ),
        plano: deserializeParam(
          data['plano'],
          ParamType.String,
          false,
        ),
        idFranquiaIndicou: deserializeParam(
          data['id_franquia_indicou'],
          ParamType.String,
          false,
        ),
        valor: deserializeParam(
          data['valor'],
          ParamType.double,
          false,
        ),
        valorParcelas: deserializeParam(
          data['valorParcelas'],
          ParamType.double,
          false,
        ),
        numParcelas: deserializeParam(
          data['NumParcelas'],
          ParamType.int,
          false,
        ),
        formaPagamento: deserializeParam(
          data['FormaPagamento'],
          ParamType.String,
          false,
        ),
        imagemQr: deserializeParam(
          data['imagemQr'],
          ParamType.String,
          false,
        ),
        pixCopiaCola: deserializeParam(
          data['pixCopiaCola'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        idClienteAsaas: deserializeParam(
          data['idClienteAsaas'],
          ParamType.String,
          false,
        ),
        walletFranquiaAluno: deserializeParam(
          data['walletFranquiaAluno'],
          ParamType.String,
          false,
        ),
        idpagamentoAsaas: deserializeParam(
          data['idpagamentoAsaas'],
          ParamType.String,
          false,
        ),
        validadePlano: deserializeParam(
          data['validadePlano'],
          ParamType.DateTime,
          false,
        ),
        visibilidadePagamento: deserializeParam(
          data['VisibilidadePagamento'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PagamentoCobrancaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PagamentoCobrancaStruct &&
        nome == other.nome &&
        email == other.email &&
        telefone == other.telefone &&
        cep == other.cep &&
        endereco == other.endereco &&
        bairro == other.bairro &&
        cidade == other.cidade &&
        cpfAluno == other.cpfAluno &&
        numero == other.numero &&
        uf == other.uf &&
        plano == other.plano &&
        idFranquiaIndicou == other.idFranquiaIndicou &&
        valor == other.valor &&
        valorParcelas == other.valorParcelas &&
        numParcelas == other.numParcelas &&
        formaPagamento == other.formaPagamento &&
        imagemQr == other.imagemQr &&
        pixCopiaCola == other.pixCopiaCola &&
        status == other.status &&
        idClienteAsaas == other.idClienteAsaas &&
        walletFranquiaAluno == other.walletFranquiaAluno &&
        idpagamentoAsaas == other.idpagamentoAsaas &&
        validadePlano == other.validadePlano &&
        visibilidadePagamento == other.visibilidadePagamento;
  }

  @override
  int get hashCode => const ListEquality().hash([
        nome,
        email,
        telefone,
        cep,
        endereco,
        bairro,
        cidade,
        cpfAluno,
        numero,
        uf,
        plano,
        idFranquiaIndicou,
        valor,
        valorParcelas,
        numParcelas,
        formaPagamento,
        imagemQr,
        pixCopiaCola,
        status,
        idClienteAsaas,
        walletFranquiaAluno,
        idpagamentoAsaas,
        validadePlano,
        visibilidadePagamento
      ]);
}

PagamentoCobrancaStruct createPagamentoCobrancaStruct({
  String? nome,
  String? email,
  String? telefone,
  String? cep,
  String? endereco,
  String? bairro,
  String? cidade,
  String? cpfAluno,
  String? numero,
  String? uf,
  String? plano,
  String? idFranquiaIndicou,
  double? valor,
  double? valorParcelas,
  int? numParcelas,
  String? formaPagamento,
  String? imagemQr,
  String? pixCopiaCola,
  String? status,
  String? idClienteAsaas,
  String? walletFranquiaAluno,
  String? idpagamentoAsaas,
  DateTime? validadePlano,
  String? visibilidadePagamento,
}) =>
    PagamentoCobrancaStruct(
      nome: nome,
      email: email,
      telefone: telefone,
      cep: cep,
      endereco: endereco,
      bairro: bairro,
      cidade: cidade,
      cpfAluno: cpfAluno,
      numero: numero,
      uf: uf,
      plano: plano,
      idFranquiaIndicou: idFranquiaIndicou,
      valor: valor,
      valorParcelas: valorParcelas,
      numParcelas: numParcelas,
      formaPagamento: formaPagamento,
      imagemQr: imagemQr,
      pixCopiaCola: pixCopiaCola,
      status: status,
      idClienteAsaas: idClienteAsaas,
      walletFranquiaAluno: walletFranquiaAluno,
      idpagamentoAsaas: idpagamentoAsaas,
      validadePlano: validadePlano,
      visibilidadePagamento: visibilidadePagamento,
    );
