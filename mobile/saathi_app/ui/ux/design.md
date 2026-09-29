---
name: Rural Workhorse Cockpit
colors:
  surface: '#111413'
  surface-dim: '#111413'
  surface-bright: '#373a39'
  surface-container-lowest: '#0c0f0e'
  surface-container-low: '#191c1b'
  surface-container: '#1d201f'
  surface-container-high: '#282b29'
  surface-container-highest: '#323534'
  on-surface: '#e1e3e1'
  on-surface-variant: '#d5c4b0'
  inverse-surface: '#e1e3e1'
  inverse-on-surface: '#2e3130'
  outline: '#9d8e7c'
  outline-variant: '#504536'
  surface-tint: '#fdba4f'
  primary: '#ffc66f'
  on-primary: '#442b00'
  primary-container: '#e8a83e'
  on-primary-container: '#603f00'
  inverse-primary: '#805600'
  secondary: '#53de9d'
  on-secondary: '#003822'
  secondary-container: '#04b175'
  on-secondary-container: '#003b24'
  tertiary: '#fec669'
  on-tertiary: '#432c00'
  tertiary-container: '#dfab51'
  on-tertiary-container: '#5e4000'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffddb0'
  primary-fixed-dim: '#fdba4f'
  on-primary-fixed: '#291800'
  on-primary-fixed-variant: '#614000'
  secondary-fixed: '#72fbb8'
  secondary-fixed-dim: '#53de9d'
  on-secondary-fixed: '#002112'
  on-secondary-fixed-variant: '#005233'
  tertiary-fixed: '#ffdeac'
  tertiary-fixed-dim: '#f4bd61'
  on-tertiary-fixed: '#281900'
  on-tertiary-fixed-variant: '#604100'
  background: '#111413'
  on-background: '#e1e3e1'
  surface-variant: '#323534'
typography:
  headline-xl:
    fontFamily: Epilogue
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Epilogue
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Epilogue
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-lg:
    fontFamily: Epilogue
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 22px
    letterSpacing: 0.04em
  label-md:
    fontFamily: Epilogue
    fontSize: 13px
    fontWeight: '700'
    lineHeight: 18px
    letterSpacing: 0.06em
  label-sm:
    fontFamily: Epilogue
    fontSize: 11px
    fontWeight: '800'
    lineHeight: 16px
    letterSpacing: 0.08em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system establishes a high-contrast, glare-resistant utility interface purpose-built for rural commercial vehicle owners, driver-operators, and agricultural transport logistics in Gujarat. It discards urban ride-hailing idioms—such as continuous map tracking, gamified metrics, bidding wars, and sleek translucent layers—in favor of a robust, physical cockpit experience.

### Brand Personality & Emotional Tone
- **Operational Authority:** Unflinching, utilitarian, and dependable. The screen functions as an electronic dashboard bolted to a tractor, chhakda, pickup, or mini-truck cabin.
- **Physical Confidence:** Elements mimic heavy machinery toggle switches, stamped metal nameplates, and industrial instrumentation. Designed to be operated quickly under direct harsh sunlight, vibration, and with dusty or gloved hands.
- **Dignified Utility:** Respects the user's practical reality. Microcopy bridges functional English with native Gujarati terms (e.g., વાહન / Vehicle, કામ / Trips, સાથી / Partner, આજે / Today) without patronizing ornamentation.

### Visual Design Style: Industrial High-Contrast Utility
The aesthetic fuses **Tactile Brutalism** with **High-Contrast Cockpit Instrumentation**:
- Dense, structural dark surfaces eliminate battery drain and glare under bright midday outdoor conditions.
- Deep mechanical graphite bases layered with matte composite surfaces.
- High-visibility amber and safety-green indicator accents provide immediate scanability at arm's length.
- Heavy structural borders frame functional clusters, completely avoiding delicate floating shadows or low-contrast decorative gradients.

## Colors

The palette is engineered specifically for outdoor legibility against strong ambient glare and direct sunlight. It relies on strict semantic boundaries and high contrast ratios that exceed WCAG AAA standards for actionable text and critical statuses.

### Core Swatches & Roles
- **Base Background (`#151817` - Graphite Base):** Deep, non-reflective soot-graphite canvas that absorbs glare and reduces cabin eye fatigue.
- **Surface Level 1 (`#1D2220` - Cockpit Deck):** The primary container background for actionable cards, vehicle cards, and ledger units.
- **Surface Level 2 (`#252B28` - Raised Instrument):** Used for elevated headers, input troughs, and nested list items.
- **Primary Action / Focal Accent (`#E8A83E` - Industrial Amber):** Safety amber used for primary interactive buttons, prominent alerts, call-to-action cards, and essential visual anchors.
- **Positive / Active Status (`#18B77A` - Signal Green):** Mechanical green denoting active availability, confirmed assignments, running engines, and verified load statuses.
- **Muted Gold (`#B98932` - Cast Brass):** Secondary indicator color for vehicle profile badges, mechanical certifications, and secondary accent flags.
- **Destructive / Danger (`#D95C4A` - Warning Flare):** Critical alerts, cancellation confirmation, breakdown reports, and emergency actions.
- **Primary Content / Text (`#F3EEE3` - Ivory Enamel):** Uncoated warm white with maximum luminance contrast against graphite backgrounds.
- **Secondary Content (`#D1C9BA` - Weathered Bone):** Subtitles, field labels, metadata stamps, and Gujarati microcopy cues.
- **Border Trim (`#333A36` - Structural Stroke):** Crisp delineating line applied across all containers to preserve structural boundaries in high-glare environments.

## Typography

The typographic hierarchy combines the blocky, mechanical geometry of **Epilogue** for numbers, headings, and functional badges with the hyper-legible neutral structure of **Inter** for data tables, location text, and instructional content.

### Typographic Principles
- **Chunky Weight Scale:** Regular weight (400) is omitted. All text starts at medium (500) or bold (700/800) to ensure characters remain legible when viewed on vibrating dashboard mounts under dusty screen conditions.
- **Uppercase Data Stamps:** Labels, operational states, and tracking metadata use `Epilogue` uppercase with positive letter spacing to produce clear industrial signage.
- **Bilingual Stacking:** When pairing English titles with Gujarati counterparts (e.g., `WORK TRIPS` / `કામ`), the Gujarati microcopy is rendered adjacent or immediately below at `body-sm` or `label-md` using a muted tone (`#D1C9BA`) to keep visual hierarchy focused without clutter.
- **Numerical Prominence:** Weights, phone numbers, load volumes, and vehicle registration numbers rely on large tabular styling to eliminate character confusion.

## Layout & Spacing

The layout philosophy implements a rigid, single-column **Cockpit Stacking Model** for mobile screens, expandable to a structured utility grid for larger ruggedized tablets.

### Layout Principles
- **Touch Perimeter Priority:** All critical interactions are positioned within bottom-half thumb reach. No primary action should be located in top peripheral corners.
- **Oversized Touch Footprint:** Every actionable element adheres to a minimum physical touch height of **52px** (primary actions baseline at **56px**), accounting for rapid taps on bumpy rural paths.
- **Density Over Airiness:** Rather than vast decorative whitespace, spacing is intentional and modular. Dense information clusters are partitioned by concrete 1px borders and distinct container surfaces rather than airy voids.
- **Fluid Single Column Reflow:**
  - **Handheld (<600px):** 1-column layout, edge margins at `1rem` (16px), stacked utility cards, pinned persistent bottom navigation/action dock.
  - **Tablet/Dashboard Mount (>=600px):** 2-column fixed utility split. Left column anchors vehicle telemetry, status, and driver profile; right column displays job queues and route parameters.

## Elevation & Depth

Visual depth is achieved exclusively through **Surface Tiers** and **Structural Outlines**. Soft blurred drop-shadows are strictly prohibited as they dissolve under high ambient solar light.

### Depth Architecture
- **Base Canvas (Level 0 - `#151817`):** The viewport foundation.
- **Structural Card Tier (Level 1 - `#1D2220`):** Framed with a 1px solid `#333A36` border. Forms the body of cards, operational blocks, and trip tickets.
- **Inset Recess (Level -1 - `#121514`):** Countersunk backgrounds for read-only timestamps, manual location updates, and diagnostic fields. Uses a 1px inset dark stroke.
- **Raised Controls (Level 2 - `#252B28`):** Elevated dialogs, status banners, and persistent bottom cockpit sheets. Outlined with `#404A45` to visibly project forward.
- **Tactile Depress States:** Physical press states switch primary buttons from flat industrial amber (`#E8A83E`) to dark brass (`#B98932`) accompanied by a 1px inset stroke, providing instantaneous physical feedback on click or touch.

## Shapes

The interface embraces a machined, semi-chiseled profile with tight corners (`0.25rem` / `4px` baseline corner radius). Large pill-like radii and round circular cards are prohibited to preserve the feel of hardware dials and industrial instrumentation.

### Corner Rules
- **Buttons and Primary Chips:** `4px` roundedness. Maintains a clean, blocky, stamping-press appearance.
- **Utility Cards and Frame Enclosures:** `4px` corner radius framed with sharp 1px borderlines.
- **Pills and Status Indicators:** Maximum corner radius of `4px` to `6px`. Never circular or capsule pills.
- **Dividers:** Clean, solid 1px and 2px straight horizontal and vertical tracks.

## Components

### 1. Chunky Primary & Secondary Buttons
- **Primary Call-to-Action (Action Amber):** Min-height 56px. Background `#E8A83E`, text `#151817` (Epilogue 700 uppercase). Heavy tactile active state with `#B98932` fill. Full-width on mobile.
- **Secondary Action (Work Deck):** Min-height 56px. Background `#1D2220`, border 1.5px solid `#333A36`, text `#F3EEE3`. Focus/pressed background `#252B28` with `#E8A83E` border highlight.
- **Destructive Utility:** Min-height 52px. Background transparent, border 1.5px solid `#D95C4A`, text `#D95C4A`.

### 2. Location Stamp & Manual Refresh Bar (Anti-Continuous GPS)
- Replaces generic animated maps. Features an industrial status box displaying:
  - Last verified stop name in bold Gujarati + English.
  - Subtext: `Location updated 14 mins ago` (Ivory `#D1C9BA`).
  - Action: Chunky tactile "REFRESH LOCATION" button with a manual sync icon, min touch target 48px height.

### 3. Status Badges & Hardware Indicators
- Compact, high-visibility badges with solid 1px contrasting borders:
  - **Available / On Duty (સાથી હાજર):** Background `#18B77A` tint (15%), border 1px solid `#18B77A`, text `#18B77A`.
  - **Vehicle Engaged (વાહન ચાલુ):** Background `#E8A83E` tint (15%), border 1px solid `#E8A83E`, text `#E8A83E`.
  - **Inactive / Maintenance (બંધ):** Background `#252B28`, border 1px solid `#505A55`, text `#D1C9BA`.

### 4. Workhorse Job & Haul Cards
- Structural background `#1D2220`, 1px border `#333A36`.
- Header section contains cargo category (e.g., કપાસ / Cotton, મગફળી / Groundnut, ખાતર / Fertilizer) with bold vehicle weight rating tags.
- Direct phone dialer bar: Solid high-contrast trigger (min-height 52px) displaying client name and prominent call button without sub-menus.

### 5. Input Fields & Selectors
- Height: 56px minimum.
- Background `#151817` (sunken tier), border 2px solid `#333A36`.
- Text color `#F3EEE3` in `body-lg`. Active focus state triggers an intense `#E8A83E` outline with zero glowing shadows.
- Monospaced numerical values for cargo load, vehicle plate input, and phone numbers.

### 6. Cockpit Navigation Header & Micro-Dock
- Top bar: Fixed status with offline/online indicator, vehicle identifier (e.g., GJ-03-XX-0000), and battery/network level.
- Bottom Persistent Bar: Chunky 3-button physical dock for `આજે (Today)`, `કામ (Trips)`, and `વાહન (Vehicle)`. Active state designated by a 3px top border bar in `#E8A83E`.