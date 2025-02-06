import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CostInputField extends StatefulWidget {
  final TextEditingController controller;

  const CostInputField({Key? key, required this.controller}) : super(key: key);

  @override
  _CostInputFieldState createState() => _CostInputFieldState();
}

class _CostInputFieldState extends State<CostInputField> {
  final NumberFormat _currencyFormat = NumberFormat("#,##0.00", "es_ES");
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _formatCurrency(); // Aplica formato al perder el foco
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _formatCurrency() {
    String text = widget.controller.text;

    // Reemplazar punto por coma si el usuario usa el formato inglés
    text = text.replaceAll(',', '.');

    double? value = double.tryParse(text);
    if (value != null) {
      setState(() {
        widget.controller.text = "${_currencyFormat.format(value)} €";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true), // Solo números y decimales
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d{0,2}')), // Máx. 2 decimales
      ],
      decoration: const InputDecoration(
        labelText: 'Costo',
        border: OutlineInputBorder(),
      ),
      onEditingComplete: _formatCurrency, // Aplica formato al presionar OK en teclado
    );
  }
}
