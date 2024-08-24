import 'package:flutter/material.dart';
import '../../models/treino_model/treino.dart';

class MultiSelectWorkoutDropdown extends StatefulWidget {
  final List<Treino> workoutList;
  final Function(List<Treino>) onChanged;

  const MultiSelectWorkoutDropdown({
    super.key,
    required this.workoutList,
    required this.onChanged,
  });

  @override
  _MultiSelectWorkoutDropdownState createState() => _MultiSelectWorkoutDropdownState();
}

class _MultiSelectWorkoutDropdownState extends State<MultiSelectWorkoutDropdown> {
  final List<Treino> _selectedWorkouts = [];
  final TextEditingController _searchController = TextEditingController();
  List<Treino> _filteredWorkouts = [];

  @override
  void initState() {
    super.initState();
    _filteredWorkouts = widget.workoutList;
    _searchController.addListener(_filterWorkouts);
  }

  void _filterWorkouts() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredWorkouts = widget.workoutList
          .where((workout) => workout.nome.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          leading: const Icon(Icons.fitness_center),
          title: const Text('Tipo de Treino'),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar treino',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 150,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = _filteredWorkouts[index];
                  return CheckboxListTile(
                    title: Text(workout.nome),
                    value: _selectedWorkouts.contains(workout),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedWorkouts.add(workout);
                        } else {
                          _selectedWorkouts.remove(workout);
                        }
                        widget.onChanged(_selectedWorkouts);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
        if (_selectedWorkouts.isEmpty)
          const Center(
            child: Text('Selecione ao menos um treino', style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}
