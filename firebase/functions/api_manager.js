const axios = require("axios").default;
const qs = require("qs");

/// Start Asaas Group Code

function createAsaasGroup() {
  return {
    baseUrl: `https://api-sandbox.asaas.com/`,
    headers: {
      accept: `application/json`,
      "content-type": `application/json`,
      access_token: `\$aact_hmlg_000MzkwODA2MWY2OGM3MWRlMDU2NWM3MzJlNzZmNGZhZGY6OmQxMTcyNGJkLTJiYTItNGU4My05Y2JkLWUyMGFmN2U3OWI5ZTo6JGFhY2hfMjRkYWRhYjAtZjJlZS00ZTVlLWExNGItMWUyNmFhZmUwMzRm`,
    },
  };
}

async function _criarClienteCall(context, ffVariables) {
  var nome = ffVariables["nome"];
  var cpf = ffVariables["cpf"];
  var email = ffVariables["email"];
  const asaasGroup = createAsaasGroup();

  var url = `${asaasGroup.baseUrl}v3/customers`;
  var headers = {
    accept: `application/json`,
    "content-type": `application/json`,
    access_token: `\$aact_hmlg_000MzkwODA2MWY2OGM3MWRlMDU2NWM3MzJlNzZmNGZhZGY6OmQxMTcyNGJkLTJiYTItNGU4My05Y2JkLWUyMGFmN2U3OWI5ZTo6JGFhY2hfMjRkYWRhYjAtZjJlZS00ZTVlLWExNGItMWUyNmFhZmUwMzRm`,
  };
  var params = {};
  var ffApiRequestBody = `
{
  "name": "${escapeStringForJson(nome)}",
  "cpfCnpj": "${escapeStringForJson(cpf)}",
  "email": "${escapeStringForJson(email)}"
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _gETQRCodeCall(context, ffVariables) {
  var id = ffVariables["id"];
  const asaasGroup = createAsaasGroup();

  var url = `${asaasGroup.baseUrl}/v3/payments/${id}/pixQrCode`;
  var headers = {
    accept: `application/json`,
    "content-type": `application/json`,
    access_token: `\$aact_hmlg_000MzkwODA2MWY2OGM3MWRlMDU2NWM3MzJlNzZmNGZhZGY6OmQxMTcyNGJkLTJiYTItNGU4My05Y2JkLWUyMGFmN2U3OWI5ZTo6JGFhY2hfMjRkYWRhYjAtZjJlZS00ZTVlLWExNGItMWUyNmFhZmUwMzRm`,
  };
  var params = {};
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _gETStatusPixCall(context, ffVariables) {
  var id = ffVariables["id"];
  const asaasGroup = createAsaasGroup();

  var url = `${asaasGroup.baseUrl}v3/payments/${id}/status`;
  var headers = {
    accept: `application/json`,
    "content-type": `application/json`,
    access_token: `\$aact_hmlg_000MzkwODA2MWY2OGM3MWRlMDU2NWM3MzJlNzZmNGZhZGY6OmQxMTcyNGJkLTJiYTItNGU4My05Y2JkLWUyMGFmN2U3OWI5ZTo6JGFhY2hfMjRkYWRhYjAtZjJlZS00ZTVlLWExNGItMWUyNmFhZmUwMzRm`,
  };
  var params = {};
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _criarCobrancaCartaoComSplitCall(context, ffVariables) {
  var clienteid = ffVariables["clienteid"];
  var valortotal = ffVariables["valortotal"];
  var datacobranca = ffVariables["datacobranca"];
  var valorsplit = ffVariables["valorsplit"];
  var descricao = ffVariables["descricao"];
  var walletFranqueadoExecutor = ffVariables["walletFranqueadoExecutor"];
  var nomecartao = ffVariables["nomecartao"];
  var numerocartao = ffVariables["numerocartao"];
  var mesexpiracartao = ffVariables["mesexpiracartao"];
  var anoexpira = ffVariables["anoexpira"];
  var cvv = ffVariables["cvv"];
  var ip = ffVariables["ip"];
  var nome = ffVariables["nome"];
  var email = ffVariables["email"];
  var cpf = ffVariables["cpf"];
  var telefone = ffVariables["telefone"];
  var cep = ffVariables["cep"];
  var endereco = ffVariables["endereco"];
  var numero = ffVariables["numero"];
  var bairro = ffVariables["bairro"];
  var parcelas = ffVariables["parcelas"];
  var valorParcela = ffVariables["valorParcela"];
  var walletFranquiaIndicador = ffVariables["walletFranquiaIndicador"];
  const asaasGroup = createAsaasGroup();

  var url = `${asaasGroup.baseUrl}v3/payments`;
  var headers = {
    accept: `application/json`,
    "content-type": `application/json`,
    access_token: `\$aact_hmlg_000MzkwODA2MWY2OGM3MWRlMDU2NWM3MzJlNzZmNGZhZGY6OmQxMTcyNGJkLTJiYTItNGU4My05Y2JkLWUyMGFmN2U3OWI5ZTo6JGFhY2hfMjRkYWRhYjAtZjJlZS00ZTVlLWExNGItMWUyNmFhZmUwMzRm`,
  };
  var params = {};
  var ffApiRequestBody = `
{
  "billingType": "CREDIT_CARD",
  "customer": "${escapeStringForJson(clienteid)}",
  "value": ${valortotal},
  "dueDate": "${escapeStringForJson(datacobranca)}",
  "installmentCount": ${parcelas},
  "installmentValue": ${valorParcela},
  "description": "Teste",
  "split": [
    {
      "walletId": "${escapeStringForJson(walletFranqueadoExecutor)}",
      "percentualValue": 80
    },
    {
      "walletId": "${escapeStringForJson(walletFranquiaIndicador)}",
      "percentualValue": 5
    }
  ],
  "creditCard": {
    "holderName": "${escapeStringForJson(nomecartao)}",
    "number": "${escapeStringForJson(numerocartao)}",
    "expiryMonth": "${escapeStringForJson(mesexpiracartao)}",
    "expiryYear": "${escapeStringForJson(anoexpira)}",
    "ccv": "${escapeStringForJson(cvv)}"
  },
  "creditCardHolderInfo": {
    "name": "${escapeStringForJson(nomecartao)}",
    "email": "${escapeStringForJson(email)}",
    "cpfCnpj": "${escapeStringForJson(cpf)}",
    "postalCode": "${escapeStringForJson(cep)}",
    "addressNumber": "${escapeStringForJson(endereco)}",
    "phone": "${escapeStringForJson(telefone)}"
  },
  "remoteIp": "${escapeStringForJson(ip)}"
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _criarCobrancaCartaoSemSplitCall(context, ffVariables) {
  var clienteid = ffVariables["clienteid"];
  var valortotal = ffVariables["valortotal"];
  var datacobranca = ffVariables["datacobranca"];
  var valorsplit = ffVariables["valorsplit"];
  var descricao = ffVariables["descricao"];
  var walletsplit = ffVariables["walletsplit"];
  var nomecartao = ffVariables["nomecartao"];
  var numerocartao = ffVariables["numerocartao"];
  var mesexpiracartao = ffVariables["mesexpiracartao"];
  var anoexpira = ffVariables["anoexpira"];
  var cvv = ffVariables["cvv"];
  var ip = ffVariables["ip"];
  var nome = ffVariables["nome"];
  var email = ffVariables["email"];
  var cpf = ffVariables["cpf"];
  var telefone = ffVariables["telefone"];
  var cep = ffVariables["cep"];
  var endereco = ffVariables["endereco"];
  var numero = ffVariables["numero"];
  var bairro = ffVariables["bairro"];
  var parcelas = ffVariables["parcelas"];
  var valorParcela = ffVariables["valorParcela"];
  var walletfranquiaAluno = ffVariables["walletfranquiaAluno"];
  const asaasGroup = createAsaasGroup();

  var url = `${asaasGroup.baseUrl}v3/payments`;
  var headers = {
    accept: `application/json`,
    "content-type": `application/json`,
    access_token: `\$aact_hmlg_000MzkwODA2MWY2OGM3MWRlMDU2NWM3MzJlNzZmNGZhZGY6OmQxMTcyNGJkLTJiYTItNGU4My05Y2JkLWUyMGFmN2U3OWI5ZTo6JGFhY2hfMjRkYWRhYjAtZjJlZS00ZTVlLWExNGItMWUyNmFhZmUwMzRm`,
  };
  var params = {};
  var ffApiRequestBody = `
{
  "billingType": "CREDIT_CARD",
  "customer": "${escapeStringForJson(clienteid)}",
  "value": ${valortotal},
  "dueDate": "${escapeStringForJson(datacobranca)}",
  "installmentCount": ${parcelas},
  "installmentValue": ${valorParcela},
  "description": "Teste",
  "creditCard": {
    "holderName": "${escapeStringForJson(nomecartao)}",
    "number": "${escapeStringForJson(numerocartao)}",
    "expiryMonth": "${escapeStringForJson(mesexpiracartao)}",
    "expiryYear": "${escapeStringForJson(anoexpira)}",
    "ccv": "${escapeStringForJson(cvv)}"
  },
  "split": [
    {
      "walletId": "${escapeStringForJson(walletfranquiaAluno)}",
      "percentualValue": 80
    }],
  "creditCardHolderInfo": {
    "name": "${escapeStringForJson(nomecartao)}",
    "email": "${escapeStringForJson(email)}",
    "cpfCnpj": "${escapeStringForJson(cpf)}",
    "postalCode": "${escapeStringForJson(cep)}",
    "addressNumber": "${escapeStringForJson(endereco)}",
    "phone": "${escapeStringForJson(telefone)}"
  },
  "remoteIp": "${escapeStringForJson(ip)}"
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _criarCobrancaPixComSplitCall(context, ffVariables) {
  var clienteid = ffVariables["clienteid"];
  var valortotal = ffVariables["valortotal"];
  var datacobranca = ffVariables["datacobranca"];
  var valorsplit = ffVariables["valorsplit"];
  var descricao = ffVariables["descricao"];
  var walletsplit = ffVariables["walletsplit"];
  var walletfranquiaAluno = ffVariables["walletfranquiaAluno"];
  const asaasGroup = createAsaasGroup();

  var url = `${asaasGroup.baseUrl}v3/payments`;
  var headers = {
    accept: `application/json`,
    "content-type": `application/json`,
    access_token: `\$aact_hmlg_000MzkwODA2MWY2OGM3MWRlMDU2NWM3MzJlNzZmNGZhZGY6OmQxMTcyNGJkLTJiYTItNGU4My05Y2JkLWUyMGFmN2U3OWI5ZTo6JGFhY2hfMjRkYWRhYjAtZjJlZS00ZTVlLWExNGItMWUyNmFhZmUwMzRm`,
  };
  var params = {};
  var ffApiRequestBody = `
{
  "customer": "${escapeStringForJson(clienteid)}",
  "billingType": "PIX",
  "value": ${valortotal},
  "dueDate": "${escapeStringForJson(datacobranca)}",
  "description": "Descrição do Pagamento",
  "split": [
    {
      "walletId": "${escapeStringForJson(walletsplit)}",
      "percentualValue": 10
    },
    {
      "walletId": "${escapeStringForJson(walletfranquiaAluno)}",
      "percentualValue": 70
    }
  ]
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _criarCobrancaPixSemSplitCall(context, ffVariables) {
  var clienteid = ffVariables["clienteid"];
  var valortotal = ffVariables["valortotal"];
  var datacobranca = ffVariables["datacobranca"];
  var valorsplit = ffVariables["valorsplit"];
  var descricao = ffVariables["descricao"];
  var walletsplit = ffVariables["walletsplit"];
  var walletfranquiaAluno = ffVariables["walletfranquiaAluno"];
  const asaasGroup = createAsaasGroup();

  var url = `${asaasGroup.baseUrl}v3/payments`;
  var headers = {
    accept: `application/json`,
    "content-type": `application/json`,
    access_token: `\$aact_hmlg_000MzkwODA2MWY2OGM3MWRlMDU2NWM3MzJlNzZmNGZhZGY6OmQxMTcyNGJkLTJiYTItNGU4My05Y2JkLWUyMGFmN2U3OWI5ZTo6JGFhY2hfMjRkYWRhYjAtZjJlZS00ZTVlLWExNGItMWUyNmFhZmUwMzRm`,
  };
  var params = {};
  var ffApiRequestBody = `
{
  "customer": "${escapeStringForJson(clienteid)}",
  "billingType": "PIX",
  "value": ${valortotal},
  "dueDate": "${escapeStringForJson(datacobranca)}",
  "description": "Descrição do Pagamento",
  "split": [
    {
      "walletId": "${escapeStringForJson(walletfranquiaAluno)}",
      "percentualValue": 80
    }
  ]
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _gETClienteCall(context, ffVariables) {
  var email = ffVariables["email"];
  const asaasGroup = createAsaasGroup();

  var url = `${asaasGroup.baseUrl}v3/customers`;
  var headers = {
    accept: `application/json`,
    "content-type": `application/json`,
    access_token: `\$aact_hmlg_000MzkwODA2MWY2OGM3MWRlMDU2NWM3MzJlNzZmNGZhZGY6OmQxMTcyNGJkLTJiYTItNGU4My05Y2JkLWUyMGFmN2U3OWI5ZTo6JGFhY2hfMjRkYWRhYjAtZjJlZS00ZTVlLWExNGItMWUyNmFhZmUwMzRm`,
  };
  var params = { email: email };
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}

/// End Asaas Group Code

/// Helper functions to route to the appropriate API Call.

async function makeApiCall(context, data) {
  var callName = data["callName"] || "";
  var variables = data["variables"] || {};

  const callMap = {
    CriarClienteCall: _criarClienteCall,
    GETQRCodeCall: _gETQRCodeCall,
    GETStatusPixCall: _gETStatusPixCall,
    CriarCobrancaCartaoComSplitCall: _criarCobrancaCartaoComSplitCall,
    CriarCobrancaCartaoSemSplitCall: _criarCobrancaCartaoSemSplitCall,
    CriarCobrancaPixComSplitCall: _criarCobrancaPixComSplitCall,
    CriarCobrancaPixSemSplitCall: _criarCobrancaPixSemSplitCall,
    GETClienteCall: _gETClienteCall,
  };

  if (!(callName in callMap)) {
    return {
      statusCode: 400,
      error: `API Call "${callName}" not defined as private API.`,
    };
  }

  var apiCall = callMap[callName];
  var response = await apiCall(context, variables);
  return response;
}

async function makeApiRequest({
  method,
  url,
  headers,
  params,
  body,
  returnBody,
  isStreamingApi,
}) {
  return axios
    .request({
      method: method,
      url: url,
      headers: headers,
      params: params,
      responseType: isStreamingApi ? "stream" : "json",
      ...(body && { data: body }),
    })
    .then((response) => {
      return {
        statusCode: response.status,
        headers: response.headers,
        ...(returnBody && { body: response.data }),
        isStreamingApi: isStreamingApi,
      };
    })
    .catch(function (error) {
      return {
        statusCode: error.response.status,
        headers: error.response.headers,
        ...(returnBody && { body: error.response.data }),
        error: error.message,
      };
    });
}

const _unauthenticatedResponse = {
  statusCode: 401,
  headers: {},
  error: "API call requires authentication",
};

function createBody({ headers, params, body, bodyType }) {
  switch (bodyType) {
    case "JSON":
      headers["Content-Type"] = "application/json";
      return body;
    case "TEXT":
      headers["Content-Type"] = "text/plain";
      return body;
    case "X_WWW_FORM_URL_ENCODED":
      headers["Content-Type"] = "application/x-www-form-urlencoded";
      return qs.stringify(params);
  }
}
function escapeStringForJson(val) {
  if (typeof val !== "string") {
    return val;
  }
  return val
    .replace(/[\\]/g, "\\\\")
    .replace(/["]/g, '\\"')
    .replace(/[\n]/g, "\\n")
    .replace(/[\t]/g, "\\t");
}

module.exports = { makeApiCall };
