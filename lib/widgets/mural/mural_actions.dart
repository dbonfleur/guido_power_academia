import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import '../../blocs/mural/mural_bloc.dart';
import '../../blocs/mural/mural_event.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../blocs/theme/theme_state.dart';
import '../../models/mural_model.dart';
import '../../blocs/user/user_bloc.dart';
import '../custom_embed_builder.dart';

class MuralActions extends StatelessWidget {
  final Mural? mural;

  const MuralActions({
    super.key,
    this.mural,
  });

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserBloc>().state;

    if (userState is UserLoaded) {
      final user = userState.user;
      if (mural == null || (user.accountType == 'treinador' && user.id == mural!.userId)) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (BuildContext context, ThemeState state) {
            return IconButton(
              icon: Icon(
                Icons.edit,
                color: state.themeData.iconTheme.color,
              ),
              onPressed: () => mural == null
                  ? showAddMuralDialog(context)
                  : _showEditMuralDialog(context, mural!),
            );
          },
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
                  onPressed: () => mural == null
                      ? showAddMuralDialog(context)
                      : _showEditMuralDialog(context, mural!),
                ),
                if (mural != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: state.themeData.primaryIconTheme.color,
                    onPressed: () => _confirmDeleteMural(context, mural!.id!),
                  ),
              ],
            );
          },
        );
      }
    }
    return Container();
  }

  void showAddMuralDialog(BuildContext context) {
    final quill.QuillController quillController = quill.QuillController.basic();
    final ImagePicker imagePicker = ImagePicker();
    XFile? selectedImage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, stateTheme) {
                return AlertDialog(
                  title: const Text('Adicionar Mural'),
                  content: SingleChildScrollView(
                    child: Column(
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
                        if (selectedImage != null)
                          Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Image.memory(
                                  File(selectedImage!.path).readAsBytesSync(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 16,
                                bottom: 16,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        selectedImage = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                selectedImage = pickedFile;
                              });
                            }
                          },
                          style: stateTheme.themeData.elevatedButtonTheme.style,
                          child: const Text('Selecionar Imagem'),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ButtonStyle(
                        backgroundColor: stateTheme.isLightTheme
                            ? WidgetStateProperty.all(Colors.red)
                            : null,
                        foregroundColor: stateTheme.isLightTheme
                            ? WidgetStateProperty.all(Colors.white)
                            : null,
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
                            final mural = Mural(
                              content: content,
                              image: imageUrl,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                              userId: user.id!,
                            );
                            context.read<MuralBloc>().add(AddMural(mural));
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: stateTheme.isLightTheme
                            ? WidgetStateProperty.all(Colors.green)
                            : null,
                        foregroundColor: stateTheme.isLightTheme
                            ? WidgetStateProperty.all(Colors.white)
                            : null,
                      ),
                      child: const Text('Adicionar'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _showEditMuralDialog(BuildContext context, Mural mural) {
    final quill.QuillController quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(mural.content)),
      selection: const TextSelection.collapsed(offset: 0),
    );
    final ImagePicker imagePicker = ImagePicker();
    Uint8List? selectedImageBytes;

    if (mural.image != null) {
      selectedImageBytes = base64Decode(mural.image!);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, stateTheme) {
                return AlertDialog(
                  title: const Text('Editar Mural'),
                  content: SingleChildScrollView(
                    child: Column(
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
                        if (selectedImageBytes != null)
                          Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Image.memory(
                                  selectedImageBytes!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 16,
                                bottom: 16,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        selectedImageBytes = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              final bytes = await pickedFile.readAsBytes(); // Corrigido para aguardar o Future
                              setState(() {
                                selectedImageBytes = bytes;
                              });
                            }
                          },
                          style: stateTheme.themeData.elevatedButtonTheme.style,
                          child: const Text('Selecionar Nova Imagem'),
                        ),
                      ],
                    ),
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
                          final updatedMural = Mural(
                            id: mural.id,
                            content: content,
                            image: selectedImageBytes != null
                                ? base64Encode(selectedImageBytes!)
                                : mural.image,
                            createdAt: mural.createdAt,
                            updatedAt: DateTime.now(),
                            userId: mural.userId,
                          );
                          context.read<MuralBloc>().add(UpdateMural(updatedMural));
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _confirmDeleteMural(BuildContext context, int muralId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar Mural'),
          content: const Text('Tem certeza que deseja deletar este mural?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<MuralBloc>().add(DeleteMural(muralId));
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
