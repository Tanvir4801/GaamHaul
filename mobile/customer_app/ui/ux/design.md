---
name: Coastal Freight Clarity
colors:
  surface: '#f7f9fe'
  surface-dim: '#d7dadf'
  surface-bright: '#f7f9fe'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f4f9'
  surface-container: '#ebeef3'
  surface-container-high: '#e5e8ed'
  surface-container-highest: '#dfe3e8'
  on-surface: '#181c20'
  on-surface-variant: '#44474f'
  inverse-surface: '#2d3135'
  inverse-on-surface: '#eef1f6'
  outline: '#747780'
  outline-variant: '#c4c6d0'
  surface-tint: '#455e8d'
  primary: '#00183b'
  on-primary: '#ffffff'
  primary-container: '#0f2d59'
  on-primary-container: '#7c95c8'
  inverse-primary: '#adc7fc'
  secondary: '#006398'
  on-secondary: '#ffffff'
  secondary-container: '#5bb8fe'
  on-secondary-container: '#00476e'
  tertiary: '#101a23'
  on-tertiary: '#ffffff'
  tertiary-container: '#252f38'
  on-tertiary-container: '#8c97a2'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d7e2ff'
  primary-fixed-dim: '#adc7fc'
  on-primary-fixed: '#001b3f'
  on-primary-fixed-variant: '#2c4674'
  secondary-fixed: '#cce5ff'
  secondary-fixed-dim: '#93ccff'
  on-secondary-fixed: '#001d31'
  on-secondary-fixed-variant: '#004b73'
  tertiary-fixed: '#d9e4f0'
  tertiary-fixed-dim: '#bdc8d3'
  on-tertiary-fixed: '#121d25'
  on-tertiary-fixed-variant: '#3d4851'
  background: '#f7f9fe'
  on-background: '#181c20'
  surface-variant: '#dfe3e8'
typography:
  headline-xl:
    fontFamily: Epilogue
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
  headline-xl-mobile:
    fontFamily: Epilogue
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
  headline-lg:
    fontFamily: Epilogue
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Epilogue
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Epilogue
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md-mobile:
    fontFamily: Epilogue
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Epilogue
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-mobile: 0.75rem
  margin: 2rem
  margin-mobile: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.25rem
---

## Brand & Style
The design system addresses the logistical landscape of rural and semi-urban freight transit, balancing high-trust reliability with absolute operational clarity. Built for semi-urban shippers, traders, and agricultural distributors, the aesthetic establishes institutional stability without feeling cold or bureaucratic. 

The visual language draws from **Modern Coastal Logistics**: deep, structured maritime blues anchored by cool misty slates and illuminated by vibrant, actionable cerulean accents. It strips away ornamental clutter in favor of high-contrast readability, immediate status verification, and physical affordance that performs under direct sunlight on low-tier mobile screens. The emotional resonance is dependable, crisp, and direct—transforming a chaotic transport booking workflow into a structured, friction-free utility.

## Colors
The palette relies on deliberate contrast ratios between maritime deep tones and airy atmospheric neutrals:

- **Primary Anchor (`#0F2D59`)**: Institutional deep royal navy. Serves as the primary brand identifier, persistent navigation bars, prominent vehicle category headers, and maximum-emphasis textual elements.
- **Secondary Accent (`#0284C7`)**: Vibrant cerulean blue. Reserved exclusively for interactive focus states, primary booking actions, vehicle availability tags, and active map paths.
- **Tertiary Highlight (`#E0EBF7`)**: Soft ice blue. Deployed for chip backgrounds, selected vehicle cards, and notification badge foundations.
- **Neutral Canvas (`#F0F3F8`)**: Tinted slate off-white. The universal background canvas, reducing eye fatigue compared to pure white while retaining crisp separation against containers.
- **Surface Elevation (`#FFFFFF`)**: Pure crisp white. Used strictly for interactive container cards, bottom sheets, and actionable list items.
- **Subtle Surface (`#E9EEF5`)**: Mist grey. Used for input fields, disabled states, and nested summary containers.
- **Border & Dividers (`#D1D9E6`)**: Cool slate structure. Provides visible, hairline separation between data points without visual heaviness.
- **Text Ink (`#1E293B`)**: Slate charcoal. The standard text color, offering high-legibility body contrast with a softer footprint than pure black.

## Typography
Typography creates a clear divide between transactional identity and functional mechanics:

- **Epilogue (Headlines)**: Imparts structural weight and confidence. The geometric, slightly eccentric architecture gives route names, vehicle categories, and numeric cost estimates an unmistakable physical presence.
- **Inter (Body & Labels)**: Carries operational clarity across variable-density screens. Its neutral, systematic geometry prevents fatigue in data-dense manifests, driver details, and tracking timestamps.
- **Scale Usage**: `headline-xl` and `headline-lg` are confined to primary screen titles, splash states, and aggregate billing amounts. Use `label-lg` for button text and tab navigation to maintain strict vertical rhythm. Numeric values indicating payload weight (kg/tons) and price (₹) use tabular figures when paired with Inter.

## Layout & Spacing
The layout follows a fluid-first logic engineered primarily for mobile hand-held use, scaling effortlessly to tablet dispatch consoles:

- **Screen Grids**: Mobile screens utilize a 4-column fluid layout with `0.75rem` gutters and `1rem` safe-margin boundaries. Tablet and desktop dashboards adapt to an 8-column and 12-column grid respectively with a maximum content shell of 1200px.
- **Vertical Spacing Rhythm**: All spatial layout flows across an 8pt base grid. Internal component gaps lean on `space-xs` (4px) for paired caption-label setups and `space-sm` (8px) for list element separation. Component-to-component stacking operates strictly using `space-md` (16px) or `space-lg` (24px).
- **Reflow & Responsiveness**: Bottom navigation on mobile transforms into a persistent left-hand navigation rail on screens exceeding 768px. Complex booking steps reflow from stacked accordion workflows on handhelds to synchronized side-by-side (map + selection manifest) panels on larger viewports.

## Elevation & Depth
Depth is created through low-contrast tonal layering rather than heavy shadow drops, avoiding visual soot and preserving crispness under high device brightness:

- **Canvas Foundation**: The bottom plane sits at `#F0F3F8`. Elements never interact directly on bare glass without explicit containers.
- **Level 1 (Cards & Surface Plats)**: Pure `#FFFFFF` surfaces sitting on `#F0F3F8` with a 1px solid border of `#D1D9E6`. Shadow is extremely diffused: `0px 2px 8px rgba(15, 45, 89, 0.04)`.
- **Level 2 (Active Selections & Flyouts)**: Elevated card states, bottom booking drawers, and active route markers utilize `#FFFFFF` with a navy-tinted ambient lift: `0px 8px 24px rgba(15, 45, 89, 0.08)` alongside a perimeter border of `#0284C7` (1.5px) when focused.
- **Level 3 (Modals & Toast Dialogs)**: Overlaid interfaces utilize `0px 16px 36px rgba(15, 45, 89, 0.14)` over a 40% opacity deep navy backdrop (`#0F2D59` at 40% alpha), creating decisive separation for critical transit alerts.

## Shapes
The design uses an intentional **Rounded (8px base)** visual vocabulary, conveying engineered durability rather than toy-like softness:

- **Core Radius (`0.5rem` / 8px)**: Standard inputs, actionable buttons, card containers, vehicle preview tiles, and alerts.
- **Large Radius (`1rem` / 16px)**: Floating bottom sheets, modal dialog containers, map floating panels, and trip status cards.
- **Extra Large Radius (`1.5rem` / 24px)**: Full-width sticky top navigation headers and vehicle category filter segment controls.
- **Pill / Circular (9999px)**: Status badges (e.g., "In Transit", "Driver Assigned"), numeric cargo tags, and floating circular map controls.

## Components

### Buttons
- **Primary CTA**: Solid Cerulean Blue (`#0284C7`) background with pure white text (`label-lg`), minimum height of 48px for thumb targets. Active state scales to `#0369A1`.
- **Secondary Action**: Tinted Ice Blue (`#E0EBF7`) fill with Deep Royal Navy (`#0F2D59`) text. Hover/pressed turns to `#D1D9E6`.
- **Tertiary/Ghost**: Transparent fill, 1px border of `#D1D9E6`, text in `#1E293B`.

### Input Fields & Selectors
- **Default State**: Surface fill `#FFFFFF`, 1.5px border `#D1D9E6`, text `#1E293B`, placeholder `#64748B`. Corner radius 8px (`rounded-md`).
- **Focus State**: Border `#0284C7` with a 3px soft outer ring of `rgba(2, 132, 199, 0.15)`.
- **Location Inputs (Pickup/Dropoff)**: Distinctive left-aligned iconography (Navy square for pickup, Cerulean pin for drop-off) connected via a dashed 2px slate guide line.

### Cards & Vehicle Selectors
- **Vehicle Selection Card**: Base white container (`#FFFFFF`), 1px border `#D1D9E6`. Contains vehicle silhouette, payload capacity badge (`#E0EBF7`), pricing display in Epilogue bold, and estimated pickup ETA.
- **Selected State**: Outer border shifts to 2px solid `#0284C7` with an ambient glow, surface tinted with a 2% gradient of `#E0EBF7` to `#FFFFFF`.

### Chips & Filter Tabs
- **Filter Chips**: Height 36px, radius 8px, `#FFFFFF` surface with `#D1D9E6` border.
- **Selected Filter**: Background changes to `#0F2D59` with white text and no border. Counter badges inside chips carry a `#0284C7` dot.

### Lists & Activity Rows
- **Trip History Item**: White surface, separated by 8px margins rather than single hairline dividers. Features a left-hand vertical accent bar denoting trip status: Cerulean for active/en-route, Deep Navy for completed, and Muted Slate for cancelled.

### Checkboxes & Radios
- **Radio Buttons**: Dual ring; inactive has `#D1D9E6` border. Active shows an outer border of `#0284C7` enclosing an 8px solid cerulean core on pure white ground.
- **Checkboxes**: 20x20px square with 4px border radius. Checked state fills with `#0284C7` housing a white checkmark icon.

### Route Tracker / Progress Stepper
- Sequential nodes connected via 3px thick tracks. Completed stations are marked in Deep Navy (`#0F2D59`), active stations pulse in Cerulean (`#0284C7`), and upcoming legs sit idle in Mist Grey (`#D1D9E6`).