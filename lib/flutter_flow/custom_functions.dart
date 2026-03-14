import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

List<dynamic> removeJsonItem(
  List<dynamic> list,
  int index,
) {
  final newList = List<Map<String, dynamic>>.from(list);
  if (index >= 0 && index < newList.length) {
    newList.removeAt(index);
  }
  return newList;
}

List<dynamic> addJsonItem(
  String? dia,
  String? horarioInicio,
  String? horarioFinal,
  List<dynamic> list,
) {
  final newList = List<Map<String, dynamic>>.from(list);

  final newItem = {
    "dia": dia,
    "horarioInicio": horarioInicio,
    "horarioFinal": horarioFinal,
  };

  newList.add(newItem);

  return newList;
}

List<DiaCalendarioAulasStruct>? gerarLista7Dias(DateTime? dataInicial) {
  // Função que recebe a data de hoje e cria uma lista de 7 itens para salvar em App State como datatype. Cada item representa um dia consecutivo a partir da data recebida, com dois campos: dia_hora_inicio (00:00) e dia_hora_termino (23:59), considerando o timezone de Brasília. Ex.: se a data é 04/09/2025, a lista terá {04/09/2025 00:00, 04/09/2025 23:59}, {05/09/2025 00:00, 05/09/2025 23:59}… até 10/09/2025
  if (dataInicial == null) return null;

  List<DiaCalendarioAulasStruct> listaDias = [];
  DateTime dataAtual = dataInicial;

  for (int i = 0; i < 7; i++) {
    DateTime inicio = DateTime(
        dataAtual.year, dataAtual.month, dataAtual.day, 0, 0, 0, 0, 0); // 00:00
    DateTime fim = DateTime(dataAtual.year, dataAtual.month, dataAtual.day, 23,
        59, 59, 999, 999); // 23:59
    listaDias.add(
        DiaCalendarioAulasStruct(diaHoraInicio: inicio, diaHoraTermino: fim));
    dataAtual = dataAtual.add(Duration(days: 1));
  }

  return listaDias;
}

String? datetimeToString(DateTime? date) {
  // convert datetime do string
  if (date == null) return null; // Check if date is null
  return DateFormat('yyyy-MM-dd HH:mm:ss')
      .format(date); // Format date to string
}

DateTime? stringToDatetime(String? date) {
  // conver string to datetime
  if (date == null) return null; // Check for null input
  try {
    return DateTime.parse(date); // Attempt to parse the date string
  } catch (e) {
    return null; // Return null if parsing fails
  }
}

String? datetimeToDiaSemana(DateTime? dia) {
  // receba um timestamp e retorne o dia da seman da data em pt-br. Exemplo 2025-09-06 23:00:00+00 é Sábado
  if (dia == null) return null;
  List<String> diasDaSemana = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo'
  ];
  return diasDaSemana[dia.weekday - 1];
}

DateTime? calcula7diasFrente(DateTime? data) {
  if (data == null) return null; // Verifica se a data é nula
  return data.add(const Duration(days: 7)); // Adiciona 7 dias à data
}

DateTime? calcula7diasTras(DateTime? data) {
  // recebe uma data e calcula uma data 7 dias para trás dessa data
  if (data == null) return null; // Verifica se a data é nula
  return data.subtract(const Duration(days: 7)); // Subtrai 7 dias da data
}

List<String>? addItemToList(
  List<String>? listaAtual,
  String item,
) {
  // recebe uma lista de strings, e adiciona uma nova string, se a lista estiver vazia, crie uma nova apenas com o item adicionado
  if (listaAtual == null || listaAtual.isEmpty) {
    return [
      item
    ]; // Create a new list with the item if the current list is null or empty
  } else {
    listaAtual.add(item); // Add the item to the existing list
    return listaAtual; // Return the updated list
  }
}

List<String> remofromListinIndex(
  int itemIndex,
  List<String> list,
) {
  // remova um item da lista que está no index itemIndex
  if (itemIndex < 0 || itemIndex >= list.length) {
    return list; // Return the original list if index is out of bounds
  }
  list.removeAt(itemIndex); // Remove the item at the specified index
  return list; // Return the modified list
}

Color funColorTable(int index) {
  // de acordo com o meu index pinta de cores sendo #FFFFFFF e #f1f4f8 intercalando como uma tabela
  List<Color> colors = [
    Color(0xFFFFFFFF),
    Color(0xFFF1F4F8),
  ];

  return colors[index % 2];
}

DateTime? inicioMenos5Min(DateTime? inicio) {
  if (inicio == null) return null;

  return inicio.subtract(const Duration(minutes: 5));
}

String normalizacaoUTC() {
  // cria uma funcao pra converter o current time do dispositov no tempo do utc e retorn Formato YYYY-MM-DD que o Asaas espera.
  DateTime now = DateTime.now().toUtc(); // Get current time in UTC
  return DateFormat('yyyy-MM-dd').format(now); // Format to YYYY-MM-DD
}
