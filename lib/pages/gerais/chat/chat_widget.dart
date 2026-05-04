import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/nova_conversa/nova_conversa_widget.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
export 'chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key, this.route});

  final String? route;

  static String routeName = 'Chat';
  static String routePath = '/chat';

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const String _avatarFallback =
      'https://qmfitknztvxvzpgjyvxf.supabase.co/storage/v1/object/public/geral/Ellipse%2051.png';

  Future<ApiCallResponse>? _chatsFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());
    _refreshChats();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _refreshChats() {
    _chatsFuture = SupabaseGroup.listaChatsAbertosCall.call(
      pUserId: currentUserUid,
      token: currentJwtToken,
    );
  }

  void _ensureMessagesStream(String chatId) {
    if (_model.currentStreamChatId == chatId && _model.messagesStream != null) {
      return;
    }
    _model.currentStreamChatId = chatId;
    _model.messagesStream = SupaFlow.client
        .from('mensagens_chats')
        .stream(primaryKey: ['id'])
        .eqOrNull('chat_id', chatId)
        .order('created_at', ascending: true)
        .map((data) => data.map((item) => MensagensChatsRow(item)).toList());
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_model.messagesScrollController.hasClients) return;
    final position = _model.messagesScrollController.position;
    final target = position.maxScrollExtent;
    if (animated) {
      _model.messagesScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    } else {
      _model.messagesScrollController.jumpTo(target);
    }
  }

  Future<void> _sendMessage(String chatId) async {
    final text = _model.messageController.text.trim();
    if (text.isEmpty || _model.sending) return;

    safeSetState(() => _model.sending = true);
    try {
      await MensagensChatsTable().insert({
        'sender_id': currentUserUid,
        'chat_id': chatId,
        'conteudo': text,
      });
      _model.messageController.clear();
      _model.messageFocusNode.requestFocus();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } finally {
      if (mounted) safeSetState(() => _model.sending = false);
    }
  }

  Future<void> _openNovaConversa() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        final width = MediaQuery.sizeOf(context).width;
        final dialogWidth = width < kBreakpointSmall
            ? width * 0.92
            : width < kBreakpointMedium
                ? width * 0.7
                : width * 0.45;
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(dialogContext).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.75,
              width: dialogWidth,
              child: const NovaConversaWidget(),
            ),
          ),
        );
      },
    );
    if (mounted) {
      safeSetState(_refreshChats);
    }
  }

  void _selectChat(String chatId) {
    FocusScope.of(context).unfocus();
    FFAppState().chatId = chatId;
    FFAppState().update(() {});
    _ensureMessagesStream(chatId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
    });
  }

  void _clearSelection() {
    FFAppState().chatId = '';
    FFAppState().update(() {});
    _model.currentStreamChatId = null;
    _model.messagesStream = null;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= kBreakpointMedium;
    final selectedChatId = FFAppState().chatId;
    final hasSelection = selectedChatId.isNotEmpty;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondaryBackground,
        drawer: Drawer(
          elevation: 0.0,
          width: 300.0,
          backgroundColor: theme.primaryBackground,
          child: const SidebarWidget(route: 'Chat'),
        ),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWide)
                const SizedBox(
                  width: 300.0,
                  child: SidebarWidget(route: 'Chat'),
                ),
              Expanded(
                child: FutureBuilder<ApiCallResponse>(
                  future: _chatsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          width: 36.0,
                          height: 36.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(theme.primary),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _ErrorState(onRetry: () {
                        safeSetState(_refreshChats);
                      });
                    }

                    final chats = (snapshot.data!.jsonBody.toList())
                        .map<ChatAtivoStruct?>(ChatAtivoStruct.maybeFromMap)
                        .whereType<ChatAtivoStruct>()
                        .toList();

                    ChatAtivoStruct? selectedChat;
                    for (final c in chats) {
                      if (c.chatId == selectedChatId) {
                        selectedChat = c;
                        break;
                      }
                    }

                    if (selectedChat == null && hasSelection) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _clearSelection();
                          safeSetState(() {});
                        }
                      });
                    }

                    if (isWide) {
                      final ChatAtivoStruct? sel = selectedChat;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 340.0,
                            child: _ChatListPanel(
                              chats: chats,
                              selectedChatId: selectedChatId,
                              avatarFallback: _avatarFallback,
                              onSelect: _selectChat,
                              onNew: _openNovaConversa,
                              onMenu: null,
                            ),
                          ),
                          Container(
                            width: 1.0,
                            color: theme.alternate,
                          ),
                          Expanded(
                            child: sel == null
                                ? const _EmptyConversationPlaceholder()
                                : _ConversationPanel(
                                    chat: sel,
                                    avatarFallback: _avatarFallback,
                                    showBackButton: false,
                                    messagesStream: _bindStream(sel),
                                    scrollController:
                                        _model.messagesScrollController,
                                    messageController:
                                        _model.messageController,
                                    messageFocusNode:
                                        _model.messageFocusNode,
                                    sending: _model.sending,
                                    onSend: () =>
                                        _sendMessage(sel.chatId),
                                    onBack: _clearSelection,
                                    onScrollNeeded: () =>
                                        _scrollToBottom(animated: true),
                                  ),
                          ),
                        ],
                      );
                    }

                    if (selectedChat != null) {
                      final ChatAtivoStruct sel = selectedChat;
                      return _ConversationPanel(
                        chat: sel,
                        avatarFallback: _avatarFallback,
                        showBackButton: true,
                        messagesStream: _bindStream(sel),
                        scrollController: _model.messagesScrollController,
                        messageController: _model.messageController,
                        messageFocusNode: _model.messageFocusNode,
                        sending: _model.sending,
                        onSend: () => _sendMessage(sel.chatId),
                        onBack: _clearSelection,
                        onScrollNeeded: () => _scrollToBottom(animated: true),
                      );
                    }

                    return _ChatListPanel(
                      chats: chats,
                      selectedChatId: selectedChatId,
                      avatarFallback: _avatarFallback,
                      onSelect: _selectChat,
                      onNew: _openNovaConversa,
                      onMenu: () => scaffoldKey.currentState?.openDrawer(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<MensagensChatsRow>> _bindStream(ChatAtivoStruct chat) {
    _ensureMessagesStream(chat.chatId);
    return _model.messagesStream!;
  }
}

class _ChatListPanel extends StatelessWidget {
  const _ChatListPanel({
    required this.chats,
    required this.selectedChatId,
    required this.avatarFallback,
    required this.onSelect,
    required this.onNew,
    required this.onMenu,
  });

  final List<ChatAtivoStruct> chats;
  final String selectedChatId;
  final String avatarFallback;
  final ValueChanged<String> onSelect;
  final VoidCallback onNew;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      color: theme.primaryBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(20.0, 20.0, 12.0, 12.0),
            child: Row(
              children: [
                if (onMenu != null) ...[
                  _IconAction(
                    icon: Icons.menu_open_rounded,
                    onTap: onMenu!,
                    tooltip: 'Abrir menu',
                  ),
                  const SizedBox(width: 8.0),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conversas',
                        style: theme.headlineSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700,
                          ),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: theme.primaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        chats.isEmpty
                            ? 'Nenhuma conversa por aqui'
                            : '${chats.length} ${chats.length == 1 ? 'conversa' : 'conversas'}',
                        style: theme.bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
                _IconAction(
                  icon: Icons.add_comment_rounded,
                  filled: true,
                  onTap: onNew,
                  tooltip: 'Iniciar nova conversa',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(height: 1.0, color: theme.alternate),
          ),
          Expanded(
            child: chats.isEmpty
                ? _EmptyChatList(onNew: onNew)
                : ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: chats.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 2.0),
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return _ChatListItem(
                        chat: chat,
                        active: chat.chatId == selectedChatId,
                        avatarFallback: avatarFallback,
                        onTap: () => onSelect(chat.chatId),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChatListItem extends StatefulWidget {
  const _ChatListItem({
    required this.chat,
    required this.active,
    required this.avatarFallback,
    required this.onTap,
  });

  final ChatAtivoStruct chat;
  final bool active;
  final String avatarFallback;
  final VoidCallback onTap;

  @override
  State<_ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<_ChatListItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final accent = theme.primary;
    final bg = widget.active
        ? accent.withOpacity(0.12)
        : (_hovered ? theme.alternate.withOpacity(0.4) : Colors.transparent);
    final nome = widget.chat.otherUser.nome;
    final role = widget.chat.otherUser.role;
    final turma = widget.chat.turma;
    final image = (widget.chat.otherUser.imagemPerfil.isNotEmpty)
        ? widget.chat.otherUser.imagemPerfil
        : widget.avatarFallback;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14.0),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(14.0),
            splashColor: accent.withOpacity(0.12),
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(
                  color: widget.active
                      ? accent.withOpacity(0.4)
                      : Colors.transparent,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  _Avatar(url: image, size: 46.0),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                            ),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: theme.primaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Row(
                          children: [
                            _RolePill(role: role),
                            if (turma.isNotEmpty) ...[
                              const SizedBox(width: 6.0),
                              Flexible(
                                child: Text(
                                  turma,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.bodySmall.override(
                                    font: GoogleFonts.inter(),
                                    fontSize: 12.0,
                                    color: theme.secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  const _RolePill({required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isProf = role.toLowerCase().contains('professor');
    final color = isProf ? theme.primary : theme.secondaryText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Text(
        role,
        style: theme.labelSmall.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
          fontSize: 11.0,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _ConversationPanel extends StatefulWidget {
  const _ConversationPanel({
    required this.chat,
    required this.avatarFallback,
    required this.showBackButton,
    required this.messagesStream,
    required this.scrollController,
    required this.messageController,
    required this.messageFocusNode,
    required this.sending,
    required this.onSend,
    required this.onBack,
    required this.onScrollNeeded,
  });

  final ChatAtivoStruct chat;
  final String avatarFallback;
  final bool showBackButton;
  final Stream<List<MensagensChatsRow>> messagesStream;
  final ScrollController scrollController;
  final TextEditingController messageController;
  final FocusNode messageFocusNode;
  final bool sending;
  final VoidCallback onSend;
  final VoidCallback onBack;
  final VoidCallback onScrollNeeded;

  @override
  State<_ConversationPanel> createState() => _ConversationPanelState();
}

class _ConversationPanelState extends State<_ConversationPanel> {
  int _lastCount = 0;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      color: theme.secondaryBackground,
      child: Column(
        children: [
          _ChatHeader(
            chat: widget.chat,
            avatarFallback: widget.avatarFallback,
            showBackButton: widget.showBackButton,
            onBack: widget.onBack,
          ),
          Expanded(
            child: StreamBuilder<List<MensagensChatsRow>>(
              stream: widget.messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(theme.primary),
                      ),
                    ),
                  );
                }
                final messages = snapshot.data!;
                if (messages.length != _lastCount) {
                  _lastCount = messages.length;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onScrollNeeded();
                  });
                }
                if (messages.isEmpty) {
                  return _EmptyMessages(name: widget.chat.otherUser.nome);
                }

                return ListView.builder(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isOwn = msg.senderId == currentUserUid;
                    final prev = index > 0 ? messages[index - 1] : null;
                    final isGrouped = prev != null &&
                        prev.senderId == msg.senderId &&
                        _withinSameGroup(prev.createdAt, msg.createdAt);
                    final showDateDivider =
                        prev == null || !_sameDay(prev.createdAt, msg.createdAt);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showDateDivider)
                          _DayDivider(date: msg.createdAt),
                        _MessageBubble(
                          message: msg,
                          isOwn: isOwn,
                          isGrouped: isGrouped,
                          avatarUrl: isOwn
                              ? null
                              : (widget.chat.otherUser.imagemPerfil.isNotEmpty
                                  ? widget.chat.otherUser.imagemPerfil
                                  : widget.avatarFallback),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _ChatInput(
            controller: widget.messageController,
            focusNode: widget.messageFocusNode,
            sending: widget.sending,
            onSend: widget.onSend,
          ),
        ],
      ),
    );
  }

  bool _withinSameGroup(DateTime a, DateTime b) {
    return b.difference(a).inMinutes.abs() <= 2;
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.chat,
    required this.avatarFallback,
    required this.showBackButton,
    required this.onBack,
  });

  final ChatAtivoStruct chat;
  final String avatarFallback;
  final bool showBackButton;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final image = chat.otherUser.imagemPerfil.isNotEmpty
        ? chat.otherUser.imagemPerfil
        : avatarFallback;

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(
          bottom: BorderSide(color: theme.alternate, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          if (showBackButton) ...[
            _IconAction(
              icon: Icons.arrow_back_rounded,
              onTap: onBack,
              tooltip: 'Voltar',
            ),
            const SizedBox(width: 12.0),
          ],
          _Avatar(url: image, size: 44.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.otherUser.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.titleMedium.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontSize: 17.0,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Row(
                  children: [
                    _RolePill(role: chat.otherUser.role),
                    if (chat.turma.isNotEmpty) ...[
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: Text(
                          chat.turma,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: theme.secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isOwn,
    required this.isGrouped,
    required this.avatarUrl,
  });

  final MensagensChatsRow message;
  final bool isOwn;
  final bool isGrouped;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bubbleColor =
        isOwn ? theme.primary : theme.primaryBackground;
    final textColor = isOwn ? theme.info : theme.primaryText;
    final timeColor = isOwn ? theme.info.withOpacity(0.85) : theme.secondaryText;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16.0),
      topRight: const Radius.circular(16.0),
      bottomLeft: Radius.circular(isOwn ? 16.0 : (isGrouped ? 16.0 : 4.0)),
      bottomRight: Radius.circular(isOwn ? (isGrouped ? 16.0 : 4.0) : 16.0),
    );

    final bubble = Flexible(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: radius,
          border: isOwn
              ? null
              : Border.all(color: theme.alternate, width: 1.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.conteudo ?? '',
              style: theme.bodyMedium
                  .override(
                    font: GoogleFonts.inter(),
                    color: textColor,
                    fontSize: 15.0,
                    letterSpacing: 0.0,
                  )
                  .copyWith(height: 1.35),
            ),
            const SizedBox(height: 4.0),
            Text(
              _formatTime(message.createdAt),
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(),
                fontSize: 11.0,
                color: timeColor,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
    );

    final avatarSlot = SizedBox(
      width: 32.0,
      child: !isOwn && !isGrouped && avatarUrl != null
          ? _Avatar(url: avatarUrl!, size: 32.0)
          : const SizedBox.shrink(),
    );

    return Padding(
      padding: EdgeInsets.only(
        top: isGrouped ? 2.0 : 10.0,
        bottom: 0.0,
      ),
      child: Row(
        mainAxisAlignment:
            isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOwn) avatarSlot,
          if (!isOwn) const SizedBox(width: 8.0),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.72,
            ),
            child: bubble,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

class _DayDivider extends StatelessWidget {
  const _DayDivider({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    String label;
    if (d == today) {
      label = 'Hoje';
    } else if (d == today.subtract(const Duration(days: 1))) {
      label = 'Ontem';
    } else {
      label = '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/${d.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
              child: Divider(height: 1.0, color: theme.alternate)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              label,
              style: theme.labelSmall.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                fontSize: 11.0,
                color: theme.secondaryText,
                letterSpacing: 0.4,
              ),
            ),
          ),
          Expanded(
              child: Divider(height: 1.0, color: theme.alternate)),
        ],
      ),
    );
  }
}

class _ChatInput extends StatefulWidget {
  const _ChatInput({
    required this.controller,
    required this.focusNode,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool sending;
  final VoidCallback onSend;

  @override
  State<_ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<_ChatInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  bool get _canSend =>
      widget.controller.text.trim().isNotEmpty && !widget.sending;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(
          top: BorderSide(color: theme.alternate, width: 1.0),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16.0,
        12.0,
        16.0,
        12.0 + MediaQuery.viewInsetsOf(context).bottom * 0.0,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 44.0),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(22.0),
                  border: Border.all(color: theme.alternate, width: 1.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Shortcuts(
                  shortcuts: <ShortcutActivator, Intent>{
                    LogicalKeySet(LogicalKeyboardKey.enter):
                        const _SendIntent(),
                    LogicalKeySet(LogicalKeyboardKey.shift,
                        LogicalKeyboardKey.enter): const _NewLineIntent(),
                  },
                  child: Actions(
                    actions: <Type, Action<Intent>>{
                      _SendIntent: CallbackAction<_SendIntent>(
                        onInvoke: (_) {
                          if (_canSend) widget.onSend();
                          return null;
                        },
                      ),
                      _NewLineIntent: CallbackAction<_NewLineIntent>(
                        onInvoke: (_) {
                          final v = widget.controller;
                          final sel = v.selection;
                          final text = v.text;
                          final start = sel.start < 0 ? text.length : sel.start;
                          final end = sel.end < 0 ? text.length : sel.end;
                          final newText =
                              '${text.substring(0, start)}\n${text.substring(end)}';
                          v.value = TextEditingValue(
                            text: newText,
                            selection: TextSelection.collapsed(
                                offset: start + 1),
                          );
                          return null;
                        },
                      ),
                    },
                    child: TextField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(),
                        fontSize: 15.0,
                        color: theme.primaryText,
                        letterSpacing: 0.0,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                        border: InputBorder.none,
                        hintText: 'Digite sua mensagem',
                        hintStyle: theme.bodyMedium.override(
                          font: GoogleFonts.inter(),
                          fontSize: 15.0,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            _SendButton(
              enabled: _canSend,
              loading: widget.sending,
              onTap: widget.onSend,
            ),
          ],
        ),
      ),
    );
  }
}

class _SendIntent extends Intent {
  const _SendIntent();
}

class _NewLineIntent extends Intent {
  const _NewLineIntent();
}

class _SendButton extends StatefulWidget {
  const _SendButton({
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final base = theme.primary;
    final color = widget.enabled
        ? (_hovered || _pressed ? base.withOpacity(0.88) : base)
        : theme.alternate;
    final iconColor =
        widget.enabled ? theme.info : theme.secondaryText;

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) =>
            widget.enabled ? setState(() => _pressed = true) : null,
        onTapUp: (_) =>
            widget.enabled ? setState(() => _pressed = false) : null,
        onTapCancel: () =>
            widget.enabled ? setState(() => _pressed = false) : null,
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: widget.loading
                ? SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(iconColor),
                    ),
                  )
                : Icon(
                    Icons.send_rounded,
                    color: iconColor,
                    size: 20.0,
                  ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.size});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.alternate,
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(url),
        ),
      ),
    );
  }
}

class _IconAction extends StatefulWidget {
  const _IconAction({
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool filled;

  @override
  State<_IconAction> createState() => _IconActionState();
}

class _IconActionState extends State<_IconAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final accent = theme.primary;
    final bg = widget.filled
        ? (_hovered ? accent.withOpacity(0.88) : accent)
        : (_hovered ? theme.alternate.withOpacity(0.5) : Colors.transparent);
    final iconColor =
        widget.filled ? theme.info : (_hovered ? accent : theme.primaryText);

    final button = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(widget.icon, color: iconColor, size: 22.0),
        ),
      ),
    );
    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}

class _EmptyConversationPlaceholder extends StatelessWidget {
  const _EmptyConversationPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      color: theme.secondaryBackground,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96.0,
            height: 96.0,
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 44.0,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Selecione uma conversa',
            textAlign: TextAlign.center,
            style: theme.headlineSmall.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Escolha uma conversa da lista ou inicie uma nova para começar a trocar mensagens.',
            textAlign: TextAlign.center,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              color: theme.secondaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChatList extends StatelessWidget {
  const _EmptyChatList({required this.onNew});
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 56.0,
            color: theme.secondaryText.withOpacity(0.6),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Nenhuma conversa ainda',
            textAlign: TextAlign.center,
            style: theme.titleMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            'Inicie uma nova conversa para falar com seu professor ou colegas.',
            textAlign: TextAlign.center,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              color: theme.secondaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 16.0),
          OutlinedButton.icon(
            onPressed: onNew,
            icon: const Icon(Icons.add_comment_rounded, size: 18.0),
            label: const Text('Iniciar conversa'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.primary,
              side: BorderSide(color: theme.primary),
              padding: const EdgeInsets.symmetric(
                  horizontal: 18.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMessages extends StatelessWidget {
  const _EmptyMessages({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.waving_hand_rounded,
            size: 48.0,
            color: theme.primary.withOpacity(0.7),
          ),
          const SizedBox(height: 12.0),
          Text(
            'Diga olá para $name',
            textAlign: TextAlign.center,
            style: theme.titleMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            'Esta conversa ainda não tem mensagens. Envie a primeira para começar.',
            textAlign: TextAlign.center,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              color: theme.secondaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 48.0, color: theme.error),
            const SizedBox(height: 12.0),
            Text(
              'Não foi possível carregar suas conversas',
              textAlign: TextAlign.center,
              style: theme.titleMedium.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: theme.primaryText,
                letterSpacing: 0.0,
              ),
            ),
            const SizedBox(height: 12.0),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18.0),
              label: const Text('Tentar novamente'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.primary,
                side: BorderSide(color: theme.primary),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
