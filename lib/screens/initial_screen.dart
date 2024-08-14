import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import '../blocs/message/message_bloc.dart';
import '../blocs/message/message_event.dart';
import '../blocs/message/message_state.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_state.dart';
import '../models/message_model.dart';
import '../blocs/user/user_bloc.dart';
import '../widgets/custom_embed_builder.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MessageBloc>().add(LoadMessages());

    return Scaffold(
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MessageLoaded) {
            return ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        quill.QuillEditor(
                          controller: quill.QuillController(
                            document: quill.Document.fromJson(jsonDecode(message.content)),
                            selection: const TextSelection.collapsed(offset: 0),
                            readOnly: true,
                          ),
                          scrollController: ScrollController(),
                          focusNode: FocusNode(),
                          configurations: quill.QuillEditorConfigurations(
                            autoFocus: false,
                            scrollable: true,
                            padding: EdgeInsets.zero,
                            expands: false,
                            embedBuilders: [CustomEmbedBuilder()],
                          ),
                        ),
                        if (message.imageUrl != null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                              child: Image.memory(base64Decode(message.imageUrl!)),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildMessageActions(context, message),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is MessageError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Nenhuma mensagem encontrada.'));
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final userState = context.read<UserBloc>().state;

    if (userState is UserLoaded) {
      final user = userState.user;
      if (user.accountType == 'treinador' || user.accountType == 'admin') {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () => _showAddMessageDialog(context),
              backgroundColor: state.themeData.appBarTheme.backgroundColor,
              child: Icon(
                Icons.add,
                color: state.themeData.iconTheme.color,
              ),
            );
          },
        );
      }
    }
    
    return Container();
  }

  Widget _buildMessageActions(BuildContext context, Message message) {
    final userState = context.read<UserBloc>().state;

    if (userState is UserLoaded) {
      final user = userState.user;
      if (user.accountType == 'treinador' && user.id == message.userId) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (BuildContext context, ThemeState state) {
            return IconButton(
              icon: Icon(
                Icons.edit,
                color: state.themeData.iconTheme.color,
              ),
              onPressed: () => _showEditMessageDialog(context, message),
            );
          }
        );
      } else if (user.accountType == 'admin') {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (BuildContext context, ThemeState state) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: state.themeData.primaryIconTheme.color,
                  onPressed: () => _showEditMessageDialog(context, message),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: state.themeData.primaryIconTheme.color,
                  onPressed: () => _confirmDeleteMessage(context, message.id!),
                ),
              ],
            );
          },
        );
      }
    }
    return Container();
  }

  void _showAddMessageDialog(BuildContext context) {
    final quill.QuillController quillController = quill.QuillController.basic();
    final ImagePicker imagePicker = ImagePicker();
    XFile? selectedImage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, stateTheme) {
            return AlertDialog(
              title: const Text('Adicionar Mensagem'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  quill.QuillToolbar.simple(
                    controller: quillController,
                    configurations: const quill.QuillSimpleToolbarConfigurations(
                      showBoldButton: true,
                      showItalicButton: true,
                      showUnderLineButton: true,
                      showListBullets: true,
                      showListNumbers: true,
                      showListCheck: true,
                      showFontFamily: false,
                      showFontSize: false,
                      showStrikeThrough: false,
                      showInlineCode: false,
                      showColorButton: false,
                      showBackgroundColorButton: false,
                      showClearFormat: false,
                      showAlignmentButtons: false,
                      showHeaderStyle: false,
                      showCodeBlock: false,
                      showQuote: false,
                      showIndent: false,
                      showLink: false,
                      showUndo: false,
                      showRedo: false,
                      showSearchButton: false,
                      showSubscript: false,
                      showSuperscript: false,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: quill.QuillEditor(
                      controller: quillController,
                      scrollController: ScrollController(),
                      focusNode: FocusNode(),
                      configurations: quill.QuillEditorConfigurations(
                        autoFocus: true,
                        scrollable: true,
                        padding: EdgeInsets.zero,
                        expands: false,
                        embedBuilders: [CustomEmbedBuilder()],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        selectedImage = pickedFile;
                      }
                    },
                    style: stateTheme.themeData.elevatedButtonTheme.style,
                    child: const Text('Selecionar Imagem'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ButtonStyle(         
                    backgroundColor: stateTheme.isLightTheme ? WidgetStateProperty.all(Colors.red) : null,
                    foregroundColor: stateTheme.isLightTheme ? WidgetStateProperty.all(Colors.white) : null,
                  ),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final userState = context.read<UserBloc>().state;
                    if (userState is UserLoaded) {
                      final user = userState.user;
                      final content = jsonEncode(quillController.document.toDelta().toJson());
                      String? imageUrl;
            
                      if (selectedImage != null) {
                        imageUrl = base64Encode(File(selectedImage!.path).readAsBytesSync());
                      }
            
                      if (content.isNotEmpty) {
                        final message = Message(
                          content: content,
                          imageUrl: imageUrl,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          userId: user.id!,
                        );
                        context.read<MessageBloc>().add(AddMessage(message));
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  style: ButtonStyle(         
                    backgroundColor: stateTheme.isLightTheme ? WidgetStateProperty.all(Colors.green) : null,
                    foregroundColor: stateTheme.isLightTheme ? WidgetStateProperty.all(Colors.white) : null,
                  ),
                  child: const Text('Adicionar'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showEditMessageDialog(BuildContext context, Message message) {
    final quill.QuillController quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(message.content)),
      selection: const TextSelection.collapsed(offset: 0),
    );
    final ImagePicker imagePicker = ImagePicker();
    XFile? selectedImage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Mensagem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              quill.QuillToolbar.simple(
                controller: quillController,
                configurations: const quill.QuillSimpleToolbarConfigurations(
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showListBullets: true,
                  showListNumbers: true,
                  showListCheck: true,
                  showFontFamily: false,
                  showFontSize: false,
                  showStrikeThrough: false,
                  showInlineCode: false,
                  showColorButton: false,
                  showBackgroundColorButton: false,
                  showClearFormat: false,
                  showAlignmentButtons: false,
                  showHeaderStyle: false,
                  showCodeBlock: false,
                  showQuote: false,
                  showIndent: false,
                  showLink: false,
                  showUndo: false,
                  showRedo: false,
                  showSearchButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: quill.QuillEditor(
                  controller: quillController,
                  scrollController: ScrollController(),
                  focusNode: FocusNode(),
                  configurations: quill.QuillEditorConfigurations(
                    autoFocus: true,
                    scrollable: true,
                    padding: EdgeInsets.zero,
                    expands: false,
                    embedBuilders: [CustomEmbedBuilder()],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    selectedImage = pickedFile;
                    final bytes = await pickedFile.readAsBytes();
                    final image = quill.BlockEmbed.image(base64Encode(bytes));
                    final index = quillController.selection.baseOffset;
                    quillController.document.insert(index, image);
                  }
                },
                child: const Text('Selecionar Nova Imagem'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final content = jsonEncode(quillController.document.toDelta().toJson());

                if (content.isNotEmpty) {
                  final updatedMessage = Message(
                    id: message.id,
                    content: content,
                    imageUrl: selectedImage != null ? base64Encode(File(selectedImage!.path).readAsBytesSync()) : message.imageUrl,
                    createdAt: message.createdAt,
                    updatedAt: DateTime.now(),
                    userId: message.userId,
                  );
                  context.read<MessageBloc>().add(UpdateMessage(updatedMessage));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteMessage(BuildContext context, int messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar Mensagem'),
          content: const Text('Tem certeza que deseja deletar esta mensagem?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<MessageBloc>().add(DeleteMessage(messageId));
                Navigator.of(context).pop();
              },
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }
}
