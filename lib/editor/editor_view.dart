import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mailapp/ai/ai_button.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

ExecutionInstruction cmdEnterToSubmit({
  required SuperEditorContext editContext,
  required KeyEvent keyEvent,
  VoidCallback? onSubmitted,
}) {
  if (keyEvent is! KeyDownEvent && keyEvent is! KeyRepeatEvent) {
    return ExecutionInstruction.continueExecution;
  }

  if (!keyEvent.isPrimaryShortcutKeyPressed ||
      keyEvent.logicalKey != LogicalKeyboardKey.enter) {
    return ExecutionInstruction.continueExecution;
  }

  onSubmitted?.call();
  return ExecutionInstruction.haltExecution;
}

class EmailEditorView extends StatefulWidget {
  const EmailEditorView({
    super.key,
    required this.onUpdate,
    required this.initialContent,
    required this.onSubmit,
    required this.scrollController,
  });

  final void Function(BuildContext context, String content) onUpdate;
  final void Function(BuildContext context) onSubmit;
  final String initialContent;
  final ScrollController scrollController;

  @override
  State<EmailEditorView> createState() => _EmailEditorViewState();
}

class _EmailEditorViewState extends State<EmailEditorView> {
  final GlobalKey _docLayoutKey = GlobalKey();

  late MutableDocument _document;
  late Editor _docEditor;
  late MutableDocumentComposer _composer;

  late FocusNode _editorFocusNode;

  String _content = '';

  @override
  void initState() {
    super.initState();
    _document = deserializeMarkdownToDocument(widget.initialContent)
      ..addListener(_onDocumentChange);
    _content = widget.initialContent;
    _composer = MutableDocumentComposer();
    _docEditor =
        createDefaultDocumentEditor(document: _document, composer: _composer);
    _editorFocusNode = FocusNode();
  }

  void _onDocumentChange(DocumentChangeLog changelog) {
    final mkdown = serializeDocumentToMarkdown(_document);
    widget.onUpdate(context, mkdown);
    _content = mkdown;
  }

  void type(String content) {
    final lastNode = _document.nodes.lastOrNull;
    final position = lastNode?.endPosition;
    if (lastNode == null || position == null) {
      return;
    }
    _docEditor.execute([
      InsertTextRequest(
        documentPosition: DocumentPosition(
          nodeId: lastNode.id,
          nodePosition: position,
        ),
        textToInsert: content,
        attributions: {},
      ),
    ]);
  }

  @override
  void dispose() {
    _document.dispose();
    _docEditor.dispose();
    _composer.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: widget.scrollController,
          child: SuperEditor(
            editor: _docEditor,
            document: _document,
            composer: _composer,
            focusNode: _editorFocusNode,
            scrollController: widget.scrollController,
            documentLayoutKey: _docLayoutKey,
            stylesheet: getStylesheet(MediaQuery.platformBrightnessOf(context)),
            selectionStyle: defaultSelectionStyle,
            documentOverlayBuilders: [
              DefaultCaretOverlayBuilder(
                caretStyle: const CaretStyle().copyWith(
                  color: MacosTheme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  width: 2.5,
                ),
              ),
              FunctionalSuperEditorLayerBuilder(
                (context, editContext) {
                  if (_content.isEmpty) {
                    return ContentLayerProxyWidget(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'No content',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: CupertinoColors.placeholderText,
                          ),
                        ),
                      ),
                    );
                  }
                  return EmptyContentLayer();
                },
              ),
            ],
            keyboardActions: [
              ({
                required SuperEditorContext editContext,
                required KeyEvent keyEvent,
              }) =>
                  cmdEnterToSubmit(
                    editContext: editContext,
                    keyEvent: keyEvent,
                    onSubmitted: () {
                      widget.onSubmit(context);
                    },
                  ),
              ...defaultKeyboardActions,
            ],
          ),
        ),
        // TODO(dominik): 7. Enable AI
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: AiButton(
        //     onContent: (content) {
        //       type(content);
        //     },
        //   ),
        // )
      ],
    );
  }
}

Stylesheet getStylesheet(Brightness mode) {
  final textColor = mode.isDark ? Colors.white : const Color(0xFF333333);
  return _mailViewStylesheet(textColor);
}

/// Stylesheet applied to all [SuperEditor]s by default.
Stylesheet _mailViewStylesheet(Color textColor) => Stylesheet(
      rules: [
        StyleRule(
          BlockSelector.all,
          (doc, docNode) {
            return {
              Styles.maxWidth: 1440.0,
              Styles.padding: const CascadingPadding.symmetric(horizontal: 24),
              Styles.textStyle: TextStyle(
                color: textColor,
                fontSize: 18,
                height: 1.4,
              ),
            };
          },
        ),
        StyleRule(
          const BlockSelector("header1"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 40),
              Styles.textStyle: TextStyle(
                color: textColor,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            };
          },
        ),
        StyleRule(
          const BlockSelector("header2"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 32),
              Styles.textStyle: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            };
          },
        ),
        StyleRule(
          const BlockSelector("header3"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 28),
              Styles.textStyle: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            };
          },
        ),
        StyleRule(
          const BlockSelector("paragraph"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 24),
            };
          },
        ),
        StyleRule(
          const BlockSelector("paragraph").after("header1"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 0),
            };
          },
        ),
        StyleRule(
          const BlockSelector("paragraph").after("header2"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 0),
            };
          },
        ),
        StyleRule(
          const BlockSelector("paragraph").after("header3"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 0),
            };
          },
        ),
        StyleRule(
          const BlockSelector("listItem"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 24),
            };
          },
        ),
        StyleRule(
          const BlockSelector("blockquote"),
          (doc, docNode) {
            return {
              Styles.textStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            };
          },
        ),
        StyleRule(
          BlockSelector.all.last(),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(bottom: 96),
            };
          },
        ),
      ],
      inlineTextStyler: defaultInlineTextStyler,
    );

TextStyle defaultInlineTextStyler(
    Set<Attribution> attributions, TextStyle existingStyle) {
  return existingStyle.merge(defaultStyleBuilder(attributions));
}

/// Creates [TextStyles] for the standard [SuperEditor].
TextStyle defaultStyleBuilder(Set<Attribution> attributions) {
  TextStyle newStyle = const TextStyle();

  for (final attribution in attributions) {
    if (attribution == boldAttribution) {
      newStyle = newStyle.copyWith(
        fontWeight: FontWeight.bold,
      );
    } else if (attribution == italicsAttribution) {
      newStyle = newStyle.copyWith(
        fontStyle: FontStyle.italic,
      );
    } else if (attribution == underlineAttribution) {
      newStyle = newStyle.copyWith(
        decoration: newStyle.decoration == null
            ? TextDecoration.underline
            : TextDecoration.combine(
                [TextDecoration.underline, newStyle.decoration!]),
      );
    } else if (attribution == strikethroughAttribution) {
      newStyle = newStyle.copyWith(
        decoration: newStyle.decoration == null
            ? TextDecoration.lineThrough
            : TextDecoration.combine(
                [TextDecoration.lineThrough, newStyle.decoration!]),
      );
    } else if (attribution is ColorAttribution) {
      newStyle = newStyle.copyWith(
        color: attribution.color,
      );
    } else if (attribution is LinkAttribution) {
      newStyle = newStyle.copyWith(
        color: Colors.lightBlue,
        decoration: TextDecoration.underline,
      );
    }
  }
  return newStyle;
}

/// Default visual styles related to content selection.
const defaultSelectionStyle = SelectionStyles(
  selectionColor: Color(0xFFACCEF7),
);

typedef SuperEditorContentTapDelegateFactory = ContentTapDelegate Function(
    SuperEditorContext editContext);

SuperEditorLaunchLinkTapHandler superEditorLaunchLinkTapHandlerFactory(
        SuperEditorContext editContext) =>
    SuperEditorLaunchLinkTapHandler(editContext.document, editContext.composer);

/// A [ContentTapDelegate] that opens links when the user taps text with
/// a [LinkAttribution].
///
/// This delegate only opens links when [composer.isInInteractionMode] is
/// `true`.
class SuperEditorLaunchLinkTapHandler extends ContentTapDelegate {
  SuperEditorLaunchLinkTapHandler(this.document, this.composer) {
    composer.isInInteractionMode.addListener(notifyListeners);
  }

  @override
  void dispose() {
    composer.isInInteractionMode.removeListener(notifyListeners);
    super.dispose();
  }

  final Document document;
  final DocumentComposer composer;

  @override
  MouseCursor? mouseCursorForContentHover(DocumentPosition hoverPosition) {
    if (!composer.isInInteractionMode.value) {
      // The editor isn't in "interaction mode". We don't want a special cursor
      return null;
    }

    final link = _getLinkAtPosition(hoverPosition);
    return link != null ? SystemMouseCursors.click : null;
  }

  @override
  TapHandlingInstruction onTap(DocumentPosition tapPosition) {
    if (!composer.isInInteractionMode.value) {
      // The editor isn't in "interaction mode". We don't want to allow
      // users to open links by tapping on them.
      return TapHandlingInstruction.continueHandling;
    }

    final link = _getLinkAtPosition(tapPosition);
    if (link != null) {
      // The user tapped on a link. Launch it.
      launchUrl(link);

      return TapHandlingInstruction.halt;
    } else {
      // The user didn't tap on a link.
      return TapHandlingInstruction.continueHandling;
    }
  }

  Uri? _getLinkAtPosition(DocumentPosition position) {
    final nodePosition = position.nodePosition;
    if (nodePosition is! TextNodePosition) {
      return null;
    }

    final textNode = document.getNodeById(position.nodeId);
    if (textNode is! TextNode) {
      editorGesturesLog.shout(
          "Received a report of a tap on a TextNodePosition, but the node with that ID is a: $textNode");
      return null;
    }

    final tappedAttributions =
        textNode.text.getAllAttributionsAt(nodePosition.offset);
    for (final tappedAttribution in tappedAttributions) {
      if (tappedAttribution is LinkAttribution) {
        return tappedAttribution.url;
      }
    }

    return null;
  }
}
