---
name: project_responsiveness_audit
description: Complete responsiveness audit results — all files reviewed, fixes applied, recurring patterns and rules discovered
type: project
---

# Responsiveness Audit — Stepout Aluno (completed 2026-03-11)

## Files Fixed

### lib/pages/gerais/financeiro/financeiro_widget.dart
- Container fixed `height * 0.85` → `constraints: BoxConstraints(minHeight: 300.0)`
- `Expanded` wrapping `ListView.builder` inside `SingleChildScrollView` → replaced with `Padding`
- `ListView.builder` with `shrinkWrap: true` → added `physics: NeverScrollableScrollPhysics()`
- Container row item `width: 700.0` → wrapped in `Flexible`
- List item `width: 100.0, height: 43.0` → `width: double.infinity, constraints: BoxConstraints(minHeight: 43.0)`

### lib/pages/gerais/chat/chat_widget.dart (atualizado 2026-03-11 — revisão mobile)
- Dialog container `width * 0.45` → responsive (92% mobile / 70% tablet / 45% desktop)
- Sidebar chat panel `height * 1.0` → `SizedBox(height: mediaQuery.height - 100)`
- `Expanded` inside horizontal `SingleChildScrollView` → `SizedBox` with responsive width (65% mobile / 45% desktop)
- Card interno nos chats horizontais: `width * 0.6, height: 150` → `width: double.infinity, height: 130` (SizedBox pai controla largura)
- Avatar nos cards: condicional `56/72` → uniforme `52.0` (consistência)
- Painel de conversa mobile (phone/tablet): `width * 0.6, height * 0.6` → `width: double.infinity, constraints: BoxConstraints(minHeight: height * 0.5)`
- Padding painel conversa mobile: `fromSTEB(8,0,0,12)` → `fromSTEB(0,0,0,12)` (simétrico)
- Padding seção principal: `fromSTEB(0,0,12,0)` → `fromSTEB(12,0,12,0)` (simétrico)
- Botão "Iniciar novo chat" no header: `padding: fromSTEB(0,0,0,12)` → `EdgeInsets.zero` (sem deslocamento vertical)
- Bolhas de mensagem em ambos os painéis: sem `maxWidth` → `ConstrainedBox(maxWidth: width * 0.78)` mobile / `width * 0.35` desktop
- `padding: EdgeInsets.all(16.0)` nas bolhas → `EdgeInsets.all(12.0)` (mais compacto)
- Campo de texto mobile: padding `fromSTEB(8,0,8,0)` → `fromSTEB(0,0,8,0)` (sem padding esquerdo desnecessário)

### lib/pages/gerais/dashboard/dashboard_widget.dart
- Banner PageView `height * 0.45` → responsive (28% mobile / 35% tablet / 45% desktop)

### lib/pages/gerais/login/login_widget.dart
- Logo image `width: 200, height: 200` → responsive (45% of screen on mobile, 200 on larger)

### lib/components/modal_pagamento_widget.dart
- Container `width: 600.0` → responsive (95% mobile / 85% tablet / 600 desktop)

### lib/pages/aulas/sala_aula/sala_aula_widget.dart
- Desktop side panel `height * 1.0` → removed (fills parent naturally)
- Desktop "Conteúdos" card `height: 200.0` → `constraints: BoxConstraints(minHeight: 200.0)`
- Desktop "Mural" card `height: 200.0` → `constraints: BoxConstraints(minHeight: 200.0)`, `Column(mainAxisSize: MainAxisSize.min)`
- `Expanded(child: Container(width: 200.0))` in desktop panel → `Container(width: double.infinity)` (removed Expanded)
- Mobile panel Mural `Expanded(child: Container(width: 200.0))` → `Container(width: double.infinity)` inside Expanded
- Both ListViews with `shrinkWrap: true` inside `SingleChildScrollView` → added `physics: NeverScrollableScrollPhysics()`

### lib/pages/gerais/esqueceu_senha/esqueceu_senha_widget.dart
- Logo `width: 200, height: 200` → responsive (45% on mobile, 200 on larger)

### lib/pages/checkout/checkout_widget.dart
- QR code image `200x200` → responsive (60% mobile, 200 desktop)
- `Container(width: 200.0)` inside `Expanded` → `Container(width: double.infinity)`

## Files Reviewed — No Issues Found
- lib/pages/gerais/mural/mural_widget.dart — already uses `responsivePadding`, no overflow issues
- lib/pages/gerais/perfil/perfil_widget.dart — uses `Row` + `Expanded` pairs correctly
- lib/pages/aulas/calendario_aulas_lista/calendario_aulas_lista_widget.dart — `Flexible` in list, clean
- lib/pages/gerais/termos_de_uso/termos_de_uso_widget.dart — no hardcoded sizes found
- lib/pages/gerais/franquia_inativa/franquia_inativa_widget.dart — no hardcoded sizes found
- lib/pages/gerais/cobranca/cobranca_widget.dart — only `width * 1.0` (fine)
- lib/componentes/nova_conversa/nova_conversa_widget.dart — `200x200` is clipped by parent circle, intentional
- lib/componentes/sidebar/sidebar_widget.dart — already has responsive logo height
- lib/componentes/sidebar_slim/sidebar_slim_widget.dart — icon-only, no layout issues

## Recurring Flutter Responsiveness Rules Learned

### Rule 1: Expanded inside SingleChildScrollView
`Expanded` cannot be used inside `SingleChildScrollView` (either axis).
- In a **vertical** scroll: replace `Expanded` with `Padding` or remove it
- In a **horizontal** scroll: replace `Expanded` with `SizedBox(width: explicit_value)`

### Rule 2: ListView inside SingleChildScrollView
When `ListView.builder` has `shrinkWrap: true` inside a `SingleChildScrollView`, always add `physics: NeverScrollableScrollPhysics()` to prevent scroll conflicts.

### Rule 3: Fixed heights in scrollable columns
Replace `height: fixedValue` with `constraints: BoxConstraints(minHeight: fixedValue)` in Container widgets inside scrollable columns to allow expansion when content is tall.

### Rule 4: Container width inside Expanded
When a `Container` is inside an `Expanded` widget, set its `width: double.infinity` (not a fixed value) — the `Expanded` controls the actual width.

### Rule 5: Logo/image sizing on small screens
For logos and images with fixed sizes (e.g., 200x200), use breakpoint-based responsive sizing:
```dart
width: MediaQuery.sizeOf(context).width < kBreakpointSmall
    ? MediaQuery.sizeOf(context).width * 0.45
    : 200.0,
```

### Rule 6: Drawer Container height
The `height: MediaQuery.sizeOf(context).height * 1.0` pattern in Drawer containers is acceptable — Drawers are already constrained by the system. No change needed.

### Rule 7: Chat message bubbles need maxWidth
Chat message containers without explicit `maxWidth` will stretch to fill the full row on mobile, breaking the visual chat pattern. Always wrap bubble containers in `ConstrainedBox(constraints: BoxConstraints(maxWidth: mediaQuery.width * 0.78))` on mobile and `* 0.35` on the desktop chat panel (which is ~60% of the screen).

### Rule 8: Card inside horizontal ScrollView
When a card is inside a `SizedBox` with explicit width (used inside `SingleChildScrollView(Axis.horizontal)`), always set the inner `Container.width = double.infinity` — never use another fractional width that might conflict with the SizedBox parent.
