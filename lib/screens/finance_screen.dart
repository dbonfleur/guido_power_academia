import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guido_power_academia/blocs/theme/theme_state.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../blocs/contract/contract_bloc.dart';
import '../blocs/payment/payment_bloc.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_state.dart';
import '../models/contract_model.dart';
import '../models/payment_model.dart';
import '../models/user_model.dart';
import 'dart:convert';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  Contract? _selectedContract;
  User? _selectedUser;
  final Map<int, bool> _expandedStates = {};
  final Map<int, String?> _selectedPaymentMethods = {};

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
          _selectedContract = null;
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
                  ] else if (user.accountType == 'treinador' ||
                      user.accountType == 'admin') ...[
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
    return BlocBuilder<ContractBloc, ContractState>(
      builder: (context, state) {
        if (state is ContractsLoaded) {
          final contracts = state.contracts;
          if (contracts.isEmpty) {
            return const Center(child: Text('Nenhum contrato encontrado.'));
          }

          _selectedContract ??= contracts.lastWhere(
              (contract) => !contract.isCompleted,
              orElse: () => Contract(
                  userId: -1,
                  contractDurationMonths: 0,
                  createdAt: DateTime.now(),
                  isValid: false,
                  isCompleted: true));

          if (_selectedContract!.userId != -1) {
            context.read<PaymentBloc>().add(LoadPaymentsByContract(contractId: _selectedContract!.id!, context: context));
          }

          return _buildContractSelection(context, contracts);
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
              if (state is SearchUsersLoaded) {
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
                      _selectedContract = null;
                    });
                    if (_selectedUser != null) {
                      context.read<ContractBloc>().add(LoadContractsByUser(userId: _selectedUser!.id!));
                    }
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
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
                  return ListView.builder(
                    itemCount: contracts.length,
                    itemBuilder: (context, index) {
                      final contract = contracts[index];
                      context.read<PaymentBloc>().add(LoadPaymentsByContract(contractId: contract.id!, context: context));
                      return Card(
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Contrato ${contract.id}'),
                              _buildContractStatusBanner(contract.isCompleted, contract.isValid),
                            ],
                          ),
                          subtitle: Text(
                              'Duração: ${contract.contractDurationMonths} meses\nValor total: R\$${contract.contractDurationMonths * 150}'),
                          children: _buildPaymentListForAdmin(context, contract.id!),
                        ),
                      );
                    },
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

  Widget _buildContractSelection(BuildContext context, List<Contract> contracts) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Contract>(
            decoration: InputDecoration(
              labelText: 'Selecione um contrato',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            value: contracts.contains(_selectedContract) ? _selectedContract : null,
            onChanged: (Contract? newValue) {
              setState(() {
                _selectedContract = newValue;
              });
              if (_selectedContract != null && _selectedContract!.id != -1) {
                context.read<PaymentBloc>().add(LoadPaymentsByContract(contractId: _selectedContract!.id!, context: context));
              }
            },
            items: contracts.map<DropdownMenuItem<Contract>>((Contract contract) {
              return DropdownMenuItem<Contract>(
                value: contract,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Contrato ${contract.id}'),
                    _buildContractStatusBanner(contract.isCompleted, contract.isValid),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        if (_selectedContract == null || _selectedContract!.userId == -1)
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Nenhum contrato ativo. Converse com um treinador para verificar seu contrato.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),
        if (_selectedContract != null && _selectedContract!.userId != -1)
          Expanded(
            child: BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, paymentState) {
                if (paymentState is PaymentsLoaded) {
                  return _buildPaymentList(context, paymentState.payments);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
      ],
    );
  }

  List<Widget> _buildPaymentListForAdmin(BuildContext context, int contractId) {
    context.read<PaymentBloc>().add(LoadPaymentsByContract(contractId: contractId, context: context));

    return [
      BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, paymentState) {
          if (paymentState is PaymentsLoaded) {
            final payments = paymentState.payments.where((payment) => payment.contractId == contractId).toList();

            if (payments.isEmpty) {
              return const ListTile(
                title: Text('Nenhuma parcela encontrada.'),
              );
            }

            return Column(
              children: payments.map((payment) {
                return ListTile(
                  title: Text('Parcela ${payment.numberOfParcel}'),
                  subtitle: Text('Valor: R\$${payment.value}\nVencimento: ${_formatDate(payment.dueDate)}'),
                  trailing: payment.wasPaid
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.transparent,
                              ),
                              child: Text(
                                'Pago em ${_formatDateTime(payment.updatedAt)}',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Método: ${payment.paymentMethod}',
                              style: const TextStyle(color: Colors.green, fontSize: 12.0),
                            ),
                          ],
                        )
                      : const Text(
                          'Pendente',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12.0),
                        ),
                );
              }).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    ];
  }

  Widget _buildPaymentList(BuildContext context, List<Payment> payments) {
    return ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return _buildPaymentCard(context, payment);
      },
    );
  }

  Widget _buildPaymentCard(BuildContext context, Payment payment) {
    final bool isExpanded = _expandedStates[payment.id!] ?? false;
    final String selectedPaymentMethod = _selectedPaymentMethods[payment.id!] ?? payment.paymentMethod;

    final bool isContractValid = _selectedContract?.isValid ?? true;

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Parcela ${payment.numberOfParcel}'),
            subtitle: Text('Valor: R\$${payment.value}\nVencimento: ${_formatDate(payment.dueDate)}'),
            trailing: payment.wasPaid
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.transparent,
                        ),
                        child: Text(
                          'Pago em ${_formatDateTime(payment.updatedAt)}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Método: ${payment.paymentMethod}',
                        style: const TextStyle(color: Colors.green, fontSize: 12.0),
                      ),
                    ],
                  )
                : isContractValid
                    ? IconButton(
                        icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _expandedStates[payment.id!] = !isExpanded;
                          });
                        },
                      )
                    : null,
          ),
          if (!payment.wasPaid && isExpanded) _buildPaymentDetails(context, payment, selectedPaymentMethod),
        ],
      ),
    );
  }

  Widget _buildContractStatusBanner(bool isCompleted, bool isValid) {
    String statusText;
    Color borderColor;
    Color textColor;

    if (!isValid) {
      statusText = 'Cancelado';
      borderColor = Colors.red;
      textColor = Colors.red;
    } else if (isCompleted) {
      statusText = 'Concluído';
      borderColor = Colors.green;
      textColor = Colors.green;
    } else {
      statusText = 'Em andamento';
      borderColor = Colors.blue;
      textColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.transparent,
      ),
      child: Text(
        statusText,
        style: TextStyle(color: textColor, fontSize: 10),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildPaymentDetails(BuildContext context, Payment payment, String? selectedPaymentMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (themeContext, themeState) {
          return Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Método de Pagamento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: selectedPaymentMethod,
                onChanged: (String? newValue) {
                  context.read<PaymentBloc>().add(UpdatePaymentMethod(paymentId: payment.id!, paymentMethod: newValue!));
                },
                items: ['Dinheiro', 'Crédito', 'Débito', 'PIX'].map<DropdownMenuItem<String>>((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              if (selectedPaymentMethod == 'PIX')
                Column(
                  children: [
                    const Text('Chave PIX: 123e4567-e89b-12d3-a456-426614174000'),
                    const SizedBox(height: 10),
                    QrImageView(
                      data: '123e4567-e89b-12d3-a456-426614174000',
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
                      size: 150.0,
                    ),
                  ],
                ),
              if (selectedPaymentMethod == 'Crédito' || selectedPaymentMethod == 'Débito')
                const Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Nome no Cartão'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Número do Cartão'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(labelText: 'Validade (MM/AA)'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(labelText: 'CVV'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (selectedPaymentMethod == 'Dinheiro') const Text('Por favor, pague com um treinador.'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.read<PaymentBloc>().add(MarkPaymentAsPaid(paymentId: payment.id!, context: context));
                  setState(() {
                    _expandedStates[payment.id!] = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeState.themeData.primaryColor,
                ),
                child: const Text('Confirmar Pagamento'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}