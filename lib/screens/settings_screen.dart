import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/user/user_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEditingName = false;
  bool _isEditingDateOfBirth = false;
  bool _isEditingPaymentMethod = false;

  late TextEditingController _nameController;
  late TextEditingController _dateOfBirthController;
  late String _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      final imageBase64 = base64Encode(bytes);

      context.read<UserBloc>().add(UpdateUserImage(imageBase64));
    }
  }

  Future<void> _removeImage(BuildContext context) async {
    context.read<UserBloc>().add(const UpdateUserImage(null));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          _nameController.text = state.user.fullName;
          _dateOfBirthController.text = state.user.dateOfBirth;
          _selectedPaymentMethod = state.user.paymentMethod;

          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          final addPhotoColor = isDarkMode ? const Color.fromARGB(255, 16, 154, 124) : Colors.green;
          final deletePhotoColor = isDarkMode ? const Color.fromARGB(255, 103, 58, 183) : Colors.purple;

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: state.user.imageUrl != null
                            ? MemoryImage(base64Decode(state.user.imageUrl!))
                            : null,
                        child: state.user.imageUrl == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        left: -8,
                        child: IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            color: addPhotoColor,
                          ),
                          onPressed: () => _pickImage(context),
                        ),
                      ),
                      if (state.user.imageUrl != null)
                        Positioned(
                          bottom: 0,
                          right: -8,
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: deletePhotoColor,
                            ),
                            onPressed: () => _removeImage(context),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildEditableField(
                    label: 'Nome Completo',
                    controller: _nameController,
                    isEditing: _isEditingName,
                    onSave: () {
                      setState(() => _isEditingName = false);
                      context.read<UserBloc>().add(UpdateUserName(_nameController.text));
                    },
                    onEdit: () => setState(() => _isEditingName = true),
                  ),
                  _buildEditableField(
                    label: 'Data de Nascimento',
                    controller: _dateOfBirthController,
                    isEditing: _isEditingDateOfBirth,
                    onSave: () {
                      setState(() => _isEditingDateOfBirth = false);
                      context.read<UserBloc>().add(UpdateUserDateOfBirth(_dateOfBirthController.text));
                    },
                    onEdit: () => setState(() => _isEditingDateOfBirth = true),
                  ),
                  _buildEditableDropdown(
                    label: 'Método de Pagamento',
                    value: _selectedPaymentMethod,
                    items: const ['Cartão de Crédito', 'Débito', 'Dinheiro', 'PIX'],
                    isEditing: _isEditingPaymentMethod,
                    onSave: (newValue) {
                      setState(() {
                        _isEditingPaymentMethod = false;
                        _selectedPaymentMethod = newValue!;
                      });
                      context.read<UserBloc>().add(UpdateUserPaymentMethod(_selectedPaymentMethod));
                    },
                    onEdit: () => setState(() => _isEditingPaymentMethod = true),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showChangePasswordDialog(context);
                    },
                    child: const Text('Alterar Senha'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('Erro ao carregar dados do usuário.'));
        }
      },
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onSave,
    required VoidCallback onEdit,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: isEditing,
            decoration: InputDecoration(labelText: label),
          ),
        ),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit),
          onPressed: isEditing ? onSave : onEdit,
          color: Theme.of(context).iconTheme.color,
        ),
      ],
    );
  }

  Widget _buildEditableDropdown({
    required String label,
    required String value,
    required List<String> items,
    required bool isEditing,
    required ValueChanged<String?> onSave,
    required VoidCallback onEdit,
  }) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: isEditing ? onSave : null,
            decoration: InputDecoration(labelText: label),
          ),
        ),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit),
          onPressed: isEditing ? null : onEdit,
          color: Theme.of(context).iconTheme.color,
        ),
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController oldPasswordController = TextEditingController();
        final TextEditingController newPasswordController = TextEditingController();
        final TextEditingController confirmPasswordController = TextEditingController();

        return AlertDialog(
          title: const Text('Alterar Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha Antiga',
                ),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova Senha',
                ),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Nova Senha',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text == confirmPasswordController.text) {
                  context.read<UserBloc>().add(UpdateUserPassword(
                    oldPasswordController.text,
                    newPasswordController.text,
                  ));
                  Navigator.of(context).pop();
                } else {
                  // Show an error message
                }
              },
              child: const Text('Alterar'),
            ),
          ],
        );
      },
    );
  }
}
