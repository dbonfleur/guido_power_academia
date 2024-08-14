import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../blocs/theme/theme_bloc.dart';
import '../../blocs/theme/theme_state.dart';
import '../../models/mural_model.dart';
import 'mural_header.dart';
import 'mural_actions.dart';
import '../custom_embed_builder.dart';

class MuralCard extends StatelessWidget {
  final Mural mural;

  const MuralCard({
    super.key,
    required this.mural,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MuralHeader(mural: mural),
            const SizedBox(height: 8),
            quill.QuillEditor(
              controller: quill.QuillController(
                document: quill.Document.fromJson(jsonDecode(mural.content)),
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
            if (mural.image != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Image.memory(base64Decode(mural.image!)),
                ),
              ),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MuralActions(mural: mural),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
