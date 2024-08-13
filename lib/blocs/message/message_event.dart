import 'package:equatable/equatable.dart';
import '../../models/message_model.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends MessageEvent {}

class AddMessage extends MessageEvent {
  final Message message;

  const AddMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateMessage extends MessageEvent {
  final Message message;

  const UpdateMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteMessage extends MessageEvent {
  final int messageId;

  const DeleteMessage(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
