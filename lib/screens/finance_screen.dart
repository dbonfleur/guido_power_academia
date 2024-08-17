import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guido_power_academia/blocs/theme/theme_state.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../blocs/contract/contract_bloc.dart';
import '../blocs/payment/payment_bloc.dart';
import '../models/contract_model.dart';
import '../models/payment_model.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  Contract? _selectedContract;
  final Map<int, bool> _expandedStates = {};
  final Map<int, String?> _selectedPaymentMethods = {};

  @override
  void initState() {
    super.initState();
    // Carrega o contrato válido automaticamente ao abrir a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userBloc = context.read<UserBloc>();
      if (userBloc.state is UserLoaded) {
        final user = (userBloc.state as UserLoaded).user;
        context.read<ContractBloc>().add(LoadContractsByUser(userId: user.id!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = context.watch<UserBloc>();
    final userState = userBloc.state;

    if (userState is UserLoaded) {
      final user = userState.user;
      return Scaffold(
        body: Column(
          children: [
            if (user.accountType == 'aluno') ...[
              Expanded(
                child: _buildStudentView(context, user.id!),
              ),
            ] else ...[
              Expanded(
                child: _buildAdminOrTrainerView(context),
              ),
            ],
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildStudentView(BuildContext context, int userId) {
    return BlocBuilder<ContractBloc, ContractState>(
      builder: (context, state) {
        if (state is ContractsLoaded) {
          final contracts = state.contracts;
          if (contracts.isEmpty) {
            return const Center(child: Text('Nenhum contrato encontrado.'));
          }
          _selectedContract ??= contracts.firstWhere((contract) => contract.isValid, orElse: () => contracts.first);
          context.read<PaymentBloc>().add(LoadPaymentsByContract(contractId: _selectedContract!.id!));
          return _buildContractSelection(context, contracts);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
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
            value: _selectedContract,
            onChanged: (Contract? newValue) {
              setState(() {
                _selectedContract = newValue;
              });
              if (_selectedContract != null) {
                context.read<PaymentBloc>().add(LoadPaymentsByContract(contractId: _selectedContract!.id!));
              }
            },
            items: contracts.map<DropdownMenuItem<Contract>>((Contract contract) {
              return DropdownMenuItem<Contract>(
                value: contract,
                child: Text('Contrato ${contract.id}'),
              );
            }).toList(),
          ),
        ),
        if (_selectedContract != null)
          BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, paymentState) {
              if (paymentState is PaymentsLoaded) {
                return _buildPaymentList(context, paymentState.payments);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
      ],
    );
  }

  Widget _buildPaymentList(BuildContext context, List<Payment> payments) {
    return Expanded(
      child: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return _buildPaymentCard(context, payment);
        },
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Payment payment) {
    final bool isExpanded = _expandedStates[payment.id!] ?? false;
    final String selectedPaymentMethod = _selectedPaymentMethods[payment.id!] ?? payment.paymentMethod;

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
                : IconButton(
                    icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expandedStates[payment.id!] = !isExpanded;
                      });
                    },
                  ),
          ),
          if (!payment.wasPaid && isExpanded) 
            _buildPaymentDetails(context, payment, selectedPaymentMethod),
        ],
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
              if (selectedPaymentMethod == 'Dinheiro')
                const Text('Por favor, pague com um treinador.'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.read<PaymentBloc>().add(MarkPaymentAsPaid(paymentId: payment.id!));
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
        }
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildAdminOrTrainerView(BuildContext context) {
    return const Center(
      child: Text('Visualizar pagamentos de alunos'),
    );
  }
}
