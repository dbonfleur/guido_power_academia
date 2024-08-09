import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../blocs/registration/registration_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contractDurationController = TextEditingController(text: "1");

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedPaymentMethod;
  File? _imageFile;

  final List<String> days = List<String>.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));

  final Map<String, String> monthNames = {
    "Janeiro": "01",
    "Fevereiro": "02",
    "Março": "03",
    "Abril": "04",
    "Maio": "05",
    "Junho": "06",
    "Julho": "07",
    "Agosto": "08",
    "Setembro": "09",
    "Outubro": "10",
    "Novembro": "11",
    "Dezembro": "12",
  };

  final List<String> years = List<String>.generate(100, (index) => (DateTime.now().year - index).toString());

  final List<String> paymentMethods = ["Dinheiro", "Crédito", "Débito", "Boleto"];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuário'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        if (_imageFile != null)
                          InkWell(
                            onTap: _removeImage,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.white, 
                              ),
                            ),
                          ),
                        const SizedBox(width: 40),
                        InkWell(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nome de Usuário',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              cursorColor: Colors.purple,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Nome Completo',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              cursorColor: Colors.purple,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Dia',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    value: _selectedDay,
                    items: days.map((day) {
                      return DropdownMenuItem(value: day, child: Text(day));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDay = value;
                      });
                    },
                    iconEnabledColor: Colors.purple,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Mês',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    value: _selectedMonth,
                    items: monthNames.keys.map((month) {
                      return DropdownMenuItem(value: month, child: Text(month));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value;
                      });
                    },
                    iconEnabledColor: Colors.purple,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Ano',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    value: _selectedYear,
                    items: years.map((year) {
                      return DropdownMenuItem(value: year, child: Text(year));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                      });
                    },
                    iconEnabledColor: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              cursorColor: Colors.purple,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              cursorColor: Colors.purple,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Método de Pagamento',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              value: _selectedPaymentMethod,
              items: paymentMethods.map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              iconEnabledColor: Colors.purple,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _contractDurationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Duração do Contrato (meses)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    cursorColor: Colors.purple,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    int currentValue = int.parse(_contractDurationController.text);
                    if (currentValue < 12) {
                      setState(() {
                        _contractDurationController.text = (currentValue + 1).toString();
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    int currentValue = int.parse(_contractDurationController.text);
                    if (currentValue > 1) {
                      setState(() {
                        _contractDurationController.text = (currentValue - 1).toString();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocConsumer<RegistrationBloc, RegistrationState>(
              listener: (context, state) {
                if (state is RegistrationSuccess) {
                  Navigator.pop(context);
                } else if (state is RegistrationFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                if (state is RegistrationLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    final username = _usernameController.text;
                    final fullName = _fullNameController.text;
                    final dateOfBirth = '$_selectedDay/${monthNames[_selectedMonth]}/$_selectedYear';
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    final paymentMethod = _selectedPaymentMethod;
                    final contractDuration = int.parse(_contractDurationController.text);

                    BlocProvider.of<RegistrationBloc>(context).add(
                      RegisterUser(
                        username: username,
                        fullName: fullName,
                        dateOfBirth: dateOfBirth,
                        email: email,
                        password: password,
                        paymentMethod: paymentMethod!,
                        contractDuration: contractDuration,
                        accountType: 'aluno',
                        imageUrl: _imageFile?.path,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.purple, 
                      foregroundColor: Colors.white, 
                  ),
                  child: const Text('Registrar'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
