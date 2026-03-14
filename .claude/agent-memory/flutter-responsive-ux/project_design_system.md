---
name: project_design_system
description: FlutterFlow app design system — theme colors, typography, breakpoints, and responsive utilities available in the codebase
type: project
---

# Design System — Stepout Aluno

## Theme (FlutterFlowTheme)
- Primary color: `Color(0xFF0C5854)` (dark teal)
- Secondary color: `Color(0xFFF68F05)` (amber/orange)
- Font headings: Inter Tight (`GoogleFonts.interTight`)
- Font body: Inter (`GoogleFonts.inter`)
- Typography sizes: 12.0 to 64.0

## Breakpoint Constants (flutter_flow/flutter_flow_util.dart)
```dart
kBreakpointSmall  = 479.0   // mobile
kBreakpointMedium = 767.0   // tablet portrait
kBreakpointLarge  = 991.0   // tablet landscape
```

## Responsive Utilities
- `responsiveVisibility(context, phone, tablet, tabletLandscape, desktop)` — show/hide per breakpoint
- `responsivePadding(context)` — returns 12.0 / 24.0 / 48.0 by breakpoint

## Navigation Pattern
- Mobile (< kBreakpointSmall): `Drawer` with `scaffoldKey.currentState!.openDrawer()`
- Tablet: `SidebarSlimWidget` (icon-only sidebar, ~72px wide)
- Desktop: `SidebarWidget` (full sidebar, max 300px wide)
- All pages use `responsiveVisibility` to show/hide the appropriate nav widget

**Why:** The nav pattern is consistent across all pages — never change it, it's working correctly.
**How to apply:** When adding new pages, replicate this exact drawer/slim/full sidebar three-way pattern.
