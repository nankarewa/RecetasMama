import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yumm/Utils/costInput.dart';

class AddRecipetab extends StatefulWidget {
  const AddRecipetab({Key? key}) : super(key: key);

  @override
  _AddRecipetabState createState() => _AddRecipetabState();
}

class _AddRecipetabState extends State<AddRecipetab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  List<String> _selectedCategories = [];
  List<Map<String, String>> _ingredients = [];
  int _dificultad = 0; // Nivel de dificultad (1 a 5)
  final List<TextEditingController> _stepControllers = [];

  final List<String> _categories = [
    'Vegetariana',
    'Vegana',
    'Aperitivo',
    'Bebida',
    'Healthy',
    'Postre',
  ];

  void _addIngredient(String name) {
    setState(() {
      _ingredients.add({'name': name, 'quantity': ''});
    });
  }

  // Función para añadir un nuevo paso
  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  // Función para eliminar un paso
  void _removeStep(int index) {
    setState(() {
      _stepControllers[index].dispose(); // Limpia el controlador
      _stepControllers.removeAt(index);
    });
  }

  void _showCupertinoTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm, // Selector de horas y minutos
            onTimerDurationChanged: (Duration duration) {
              setState(() {
                _timeController.text =
                    "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Proporciones responsivas
    final padding = screenWidth * 0.04; // 4% del ancho para padding
    final spacing = screenHeight * 0.02; // 2% del alto para espaciado
    final iconSize = screenWidth * 0.07; // 7% del ancho para iconos
    final chipFontSize = screenWidth * 0.04; // 4% del ancho para texto en chips

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Receta')),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre de la receta
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la receta',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: spacing),
              // tiempo
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _showCupertinoTimePicker(context),
                      child: Text(
                        _timeController.text.isEmpty
                            ? 'Seleccionar tiempo'
                            : _timeController.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing),
                  const Text('h:min',
                      style: TextStyle(fontSize: 16)), // Indica el formato
                ],
              ),
              SizedBox(height: spacing),

              // dificultad
              const Text('Dificultad'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _dificultad =
                            index + 1; // Guardar el nivel de dificultad
                      });
                    },
                    icon: Icon(
                      index < _dificultad
                          ? Icons.local_fire_department // Fuego relleno
                          : Icons.local_fire_department, // Fuego vacío (gris)
                      color: index < _dificultad ? Colors.orange : Colors.grey,
                      size: iconSize, // Usa el tamaño que ya tienes definido
                    ),
                  );
                }),
              ),
              SizedBox(height: spacing),

              // Costo
              CostInputField(controller: _costController),
              SizedBox(height: spacing),

              // Categorías
              const Text('Categorías'),
              Wrap(
                spacing: spacing,
                children: _categories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(fontSize: chipFontSize),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: spacing),

              // Ingredientes
              const Text('Ingredientes'),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Buscar ingrediente',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _addIngredient(value);
                  }
                },
              ),
              SizedBox(height: spacing),

              // Lista de ingredientes
              Wrap(
                spacing: spacing,
                children: _ingredients.map((ingredient) {
                  return Chip(
                    label: Text(
                      ingredient['name']!,
                      style: TextStyle(fontSize: chipFontSize),
                    ),
                    onDeleted: () {
                      setState(() {
                        _ingredients.remove(ingredient);
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: spacing),

              // Lista de pasos
              const Text(
                "Pasos de la receta:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _stepControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Número del paso
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.yellow[700],
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Campo de texto para el paso
                        Expanded(
                          child: TextField(
                            controller: _stepControllers[index],
                            maxLines:
                                null, // Permite que el campo crezca dinámicamente
                            keyboardType: TextInputType
                                .multiline, // Habilita varias líneas
                            decoration: InputDecoration(
                              hintText: "Escribe el paso ${index + 1}",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onChanged: (text) {
                              setState(
                                  () {}); // Actualiza el estado si es necesario
                            },
                          ),
                        ),

                        // Botón para eliminar el paso
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeStep(index),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Botón para añadir paso
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: _addStep,
                  icon: const Icon(Icons.add),
                  label: const Text("Añadir paso"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                  ),
                ),
              ),

              SizedBox(height: spacing * 2),

              // Botón para guardar la receta
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica para guardar la receta
                    print('Nivel de dificultad: $_dificultad');
                  },
                  child: const Text('Guardar Receta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
