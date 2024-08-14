import 'package:flutter/material.dart';
import '../../models/treino_model.dart';

class MultiSelectTreinoDropdown extends StatefulWidget {
  final List<Treino> treinos;
  final Function(List<Treino>) onChanged;

  const MultiSelectTreinoDropdown({
    super.key,
    required this.treinos,
    required this.onChanged,
  });

  @override
  _MultiSelectTreinoDropdownState createState() => _MultiSelectTreinoDropdownState();
}

class _MultiSelectTreinoDropdownState extends State<MultiSelectTreinoDropdown> {
  final List<Treino> _selectedTreinos = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: widget.treinos.map((treino) {
            return FilterChip(
              label: Text(treino.nome),
              selected: _selectedTreinos.contains(treino),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedTreinos.add(treino);
                  } else {
                    _selectedTreinos.remove(treino);
                  }
                  widget.onChanged(_selectedTreinos);
                });
              },
            );
          }).toList(),
        ),
        if (_selectedTreinos.isEmpty)
          const Text('Selecione ao menos um treino', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
