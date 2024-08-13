import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/message_repository.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository messageRepository;

  MessageBloc({required this.messageRepository}) : super(MessageLoading()) {
    on<LoadMessages>(_onLoadMessages);
    on<AddMessage>(_onAddMessage);
    on<UpdateMessage>(_onUpdateMessage);
    on<DeleteMessage>(_onDeleteMessage);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<MessageState> emit) async {
    emit(MessageLoading());
    try {
      final messages = await messageRepository.getAllMessages();
      emit(MessageLoaded(messages: messages));
    } catch (e) {
      emit(MessageError('Erro ao carregar mensagens: ${e.toString()}'));
    }
  }

  Future<void> _onAddMessage(AddMessage event, Emitter<MessageState> emit) async {
    try {
      await messageRepository.insertMessage(event.message);
      final messages = await messageRepository.getAllMessages();
      emit(MessageLoaded(messages: messages));
    } catch (e) {
      emit(MessageError('Erro ao adicionar mensagem: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateMessage(UpdateMessage event, Emitter<MessageState> emit) async {
    try {
      await messageRepository.updateMessage(event.message);
      final messages = await messageRepository.getAllMessages();
      emit(MessageLoaded(messages: messages));
    } catch (e) {
      emit(MessageError('Erro ao atualizar mensagem: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteMessage(DeleteMessage event, Emitter<MessageState> emit) async {
    try {
      await messageRepository.deleteMessage(event.messageId);
      final messages = await messageRepository.getAllMessages();
      emit(MessageLoaded(messages: messages));
    } catch (e) {
      emit(MessageError('Erro ao deletar mensagem: ${e.toString()}'));
    }
  }
}
