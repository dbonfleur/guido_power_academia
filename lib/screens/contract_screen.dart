import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_state.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../blocs/contract/contract_bloc.dart';
import '../blocs/payment/payment_bloc.dart';
import '../models/contract_model.dart';
import '../models/payment_model.dart';
import '../models/user_model.dart';
import 'dart:convert';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  _ContractScreenState createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAuthenticatedUser(context);
    });
  }

  Future<void> _loadAuthenticatedUser(BuildContext context) async {
    final authBloc = context.read<AuthenticationBloc>();
    final userBloc = context.read<UserBloc>();

    final authState = authBloc.state;
    if (authState is AuthenticationSuccess) {
      final authenticatedUser = authState.user;
      if (userBloc.state is! UserLoaded) {
        userBloc.add(LoadUser(authenticatedUser.id!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          final user = state.user;
          if (user.accountType == 'aluno') {
            context.read<ContractBloc>().add(LoadContractsByUser(userId: user.id!));
          }
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            final user = state.user;
            return Scaffold(
              body: Column(
                children: [
                  if (user.accountType == 'aluno') ...[
                    Expanded(
                      child: _buildStudentView(context, user.id!),
                    ),
                  ] else if (user.accountType == 'treinador' || user.accountType == 'admin') ...[
                    Expanded(
                      child: _buildAdminOrTrainerView(context),
                    ),
                  ],
                ],
              ),
            );
          } else if (state is UserInitial || state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Erro ao carregar usuário.'));
          }
        },
      ),
    );
  }

  Widget _buildStudentView(BuildContext context, int userId) {
    context.read<ContractBloc>().add(LoadContractsByUser(userId: userId));
    return BlocBuilder<ContractBloc, ContractState>(
      builder: (context, state) {
        if (state is ContractsLoaded) {
          final contracts = state.contracts;
          if (contracts.isEmpty) {
            return const Center(child: Text('Nenhum contrato encontrado.'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: contracts.length,
                  itemBuilder: (context, index) {
                    final contract = contracts[index];
                    return _buildContractCard(context, contract);
                  },
                ),
              ),
              if (contracts.isNotEmpty &&
                  (contracts.last.isCompleted || !contracts.last.isValid))
                _buildAddContractButton(context),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildAdminOrTrainerView(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchUsersLoaded) {
                return DropdownButtonFormField<User>(
                  decoration: InputDecoration(
                    labelText: 'Selecione um aluno',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: state.users.map<DropdownMenuItem<User>>((user) {
                    return DropdownMenuItem<User>(
                      value: user,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: MemoryImage(base64Decode(user.imageUrl)),
                            radius: 20,
                          ),
                          const SizedBox(width: 10),
                          Text('${user.fullName} (${user.email})'),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (User? newValue) {
                    setState(() {
                      _selectedUser = newValue;
                    });
                    if (_selectedUser != null) {
                      context.read<ContractBloc>().add(LoadContractsByUser(userId: _selectedUser!.id!));
                    }
                  },
                );
              } else if (state is SearchError) {
                return Center(child: Text('Erro ao carregar alunos: ${state.message}'));
              } else {
                return const Center(child: Text('Nenhum aluno encontrado.'));
              }
            },
          ),
        ),
        if (_selectedUser != null)
          Expanded(
            child: BlocBuilder<ContractBloc, ContractState>(
              builder: (context, state) {
                if (state is ContractsLoaded) {
                  final contracts = state.contracts;
                  if (contracts.isEmpty) {
                    return const Center(child: Text('Nenhum contrato encontrado.'));
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: contracts.length,
                          itemBuilder: (context, index) {
                            final contract = contracts[index];
                            return _buildContractCard(context, contract);
                          },
                        ),
                      ),
                      if (contracts.isNotEmpty &&
                          (contracts.last.isCompleted || !contracts.last.isValid))
                        _buildAddContractButton(context),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildContractCard(BuildContext context, Contract contract) {
    final startDate = contract.createdAt;
    final endDate = DateTime(startDate.year, startDate.month + contract.contractDurationMonths, startDate.day);
    final userState = context.read<UserBloc>().state;
    final contractState = context.read<ContractBloc>().state;

    final isMostRecent = contractState is ContractsLoaded
        ? (contractState.contracts.last.id == contract.id)
        : false;

    return Card(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Contrato ${contract.id}'),
            if (!contract.isValid && !isMostRecent)
              _buildCanceledBanner(), // Exibe o banner de Cancelado para contratos não válidos que não são os mais recentes
            if (userState is UserLoaded && userState.user.accountType == 'admin' && !contract.isCompleted && isMostRecent)
              _buildValidationButton(context, contract),
          ],
        ),
        children: [
          ListTile(
            title: Text('Duração: ${_formatDate(startDate)} - ${_formatDate(endDate)}'),
            subtitle: Row(
              children: [
                _buildContractStatusBanner(contract.isCompleted),
                const SizedBox(width: 8),
                _buildValidityBanner(contract.isValid),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanceledBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.transparent,
      ),
      child: const Text(
        'Cancelado',
        style: TextStyle(color: Colors.red, fontSize: 10),
      ),
    );
  }

  Widget _buildContractStatusBanner(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: isCompleted ? Colors.green : Colors.blue),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.transparent,
      ),
      child: Text(
        isCompleted ? 'Concluído' : 'Em andamento',
        style: TextStyle(color: isCompleted ? Colors.green : Colors.blue, fontSize: 10),
      ),
    );
  }

  Widget _buildValidityBanner(bool isValid) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: isValid ? Colors.green : Colors.red),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.transparent,
      ),
      child: Text(
        isValid ? 'Válido' : 'Inválido',
        style: TextStyle(color: isValid ? Colors.green : Colors.red, fontSize: 10),
      ),
    );
  }

  Widget _buildValidationButton(BuildContext context, Contract contract) {
    return ElevatedButton(
      onPressed: () {
        if (contract.isValid) {
          context.read<ContractBloc>().add(MarkContractInvalidOrValid(contractId: contract.id!, isValid: false));
        } else {
          context.read<ContractBloc>().add(MarkContractInvalidOrValid(contractId: contract.id!, isValid: true));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: contract.isValid ? Colors.red : Colors.green,
        foregroundColor: Colors.white,
      ),
      child: Text(contract.isValid ? 'Invalidar' : 'Validar'),
    );
  }

  Widget _buildAddContractButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _showAddContractDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: BlocProvider.of<ThemeBloc>(context).state.themeData.primaryColor,
        ),
        child: const Text('Adicionar Novo Contrato'),
      ),
    );
  }

  Future<void> _showAddContractDialog(BuildContext context) async {
    final TextEditingController monthsController = TextEditingController(text: '1');
    String selectedPaymentMethod = 'Dinheiro';

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Adicionar Novo Contrato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: monthsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Quantidade de Meses',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      int currentValue = int.parse(monthsController.text);
                      if (currentValue < 12) {
                        monthsController.text = (currentValue + 1).toString();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      int currentValue = int.parse(monthsController.text);
                      if (currentValue > 1) {
                        monthsController.text = (currentValue - 1).toString();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Método de Pagamento',
                  border: OutlineInputBorder(),
                ),
                value: selectedPaymentMethod,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedPaymentMethod = newValue;
                  }
                },
                items: ['Dinheiro', 'Crédito', 'Débito', 'PIX']
                    .map<DropdownMenuItem<String>>((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () async {
                final int? months = int.tryParse(monthsController.text);
                if (months != null && months > 0) {
                  final userId = _selectedUser!.id!;

                  final newContract = Contract(
                    userId: userId,
                    contractDurationMonths: months,
                    createdAt: DateTime.now(),
                    isValid: true,
                    isCompleted: false,
                  );

                  context.read<ContractBloc>().add(CreateContract(contract: newContract));

                  await for (final state in context.read<ContractBloc>().stream) {
                    if (state is ContractCreated) {
                      final contractId = state.id;
                      final payments = _generatePayments(contractId, months, selectedPaymentMethod);
                      for (final payment in payments) {
                        context.read<PaymentBloc>().add(CreatePayment(payment: payment));
                      }
                      context.read<ContractBloc>().add(LoadContractsByUser(userId: userId));
                      break;
                    }
                  }

                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<Payment> _generatePayments(int contractId, int months, String paymentMethod) {
    return List<Payment>.generate(
      months,
      (index) => Payment(
        contractId: contractId,
        numberOfParcel: index + 1,
        value: 150,
        dueDate: DateTime.now().add(Duration(days: (index + 1) * 30)),
        updatedAt: DateTime.now(),
        wasPaid: false,
        paymentMethod: paymentMethod,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
