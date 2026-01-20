# 🎨 Design System Guide — Personal Finance App

**File:** `design_guide.md`
**Purpose:** Enforce consistent, modern, clean, finance-grade mobile UI across all screens.

---

## 1. Design Philosophy

### Core Principles

* **Clarity over decoration**
* **Calm, trustworthy, finance-first**
* **Minimal but premium**
* **Content > Chrome**
* **Numbers must breathe**

### Design Vibe

* Modern fintech
* Soft gradients
* Rounded, friendly UI
* No harsh colors
* Apple / Stripe / Revolut inspired

---

## 2. Platform Guidelines

* **Primary Target:** Mobile (iOS + Android)
* **Framework Assumption:** Flutter
* **Design Style:** iOS-first, Android-compatible
* **Safe Area:** Respect notch & gesture areas
* **Touch Targets:** Minimum 44px

---

## 3. Color System 🎨

### Primary Colors

```txt
Primary Blue:     #3B82F6
Primary Indigo:  #6366F1
Accent Cyan:     #06B6D4
```

### Neutral Colors

```txt
Background:      #F8FAFC
Surface:         #FFFFFF
Border Light:    #E5E7EB
Text Primary:    #0F172A
Text Secondary:  #64748B
```

### Semantic Colors

```txt
Success: #22C55E
Warning: #F59E0B
Error:   #EF4444
Info:    #38BDF8
```

### Rules

* Never use pure black (#000000)
* Avoid saturated red/green for large areas
* Gradients must be subtle (2 colors max)

---

## 4. Typography System ✍️

### Font Family

```txt
Primary Font: Inter
Fallback: System UI
```

### Font Scale

| Usage         | Size  | Weight   |
| ------------- | ----- | -------- |
| App Title     | 28    | SemiBold |
| Section Title | 20    | SemiBold |
| Card Title    | 16    | Medium   |
| Body Text     | 14    | Regular  |
| Caption       | 12    | Regular  |
| Amount (₹)    | 18–22 | SemiBold |

### Typography Rules

* Numbers always **SemiBold**
* Line height: 1.4–1.6
* Avoid ALL CAPS
* No more than 3 font weights

---

## 5. Spacing System 📐

### Base Unit

```txt
Base spacing = 8px
```

### Common Spacing

```txt
8px   – tight
16px  – default padding
24px  – section spacing
32px  – screen separation
```

### Rules

* Consistent padding inside cards (16px)
* Vertical rhythm > horizontal compactness

---

## 6. Layout & Grid 📱

### Screen Layout

* Single column layout
* Scroll-based screens
* Sticky bottom navigation

### Grid Rules

* Max width: device width
* Cards aligned vertically
* No side-by-side cards unless explicitly needed

---

## 7. Card System 🧩

### Card Style

```txt
Background: #FFFFFF
Radius: 16px
Shadow: Soft (Y=4, Blur=20, Opacity=8%)
Border: Optional (1px light)
```

### Card Types

* Balance Card
* Transaction Card
* Chart Card
* Action Card

### Rules

* Cards must feel tappable
* No heavy shadows
* One primary action per card

---

## 8. Buttons & Actions 🔘

### Primary Button

```txt
Height: 48px
Radius: 12px
Color: Primary Blue
Text: White
```

### Secondary Button

```txt
Outline or soft fill
Text: Primary color
```

### Floating Action Button (FAB)

* Used for **Add Transaction**
* Circular
* Bottom center or bottom right

---

## 9. Navigation 🧭

### Bottom Navigation

* Max 4–5 items
* Icons + labels
* Active state = primary color
* Inactive = gray

### Header

* Minimal
* Title + optional icon
* No clutter

---

## 10. Icons 🧠

### Icon Style

* Outline icons
* Rounded edges
* Consistent stroke width

### Recommended Sets

* Material Icons
* Lucide
* SF Symbols (conceptually)

### Rules

* Never mix icon styles
* Icons support text, not replace it

---

## 11. Data & Finance UI Rules 💰

### Amount Display

* Currency symbol smaller than number
* Use color:

  * Green → income
  * Red → expense
  * Neutral → balance

### Charts

* Simple bar / line charts
* Soft colors
* No grid overload
* Labels always readable

---

## 12. States & Feedback 🔄

### Empty State

* Friendly illustration or icon
* Clear CTA

### Loading

* Skeleton loaders preferred
* No spinners for full screens

### Error

* Human language
* Recovery action visible

---

## 13. Animation & Motion 🎞️

### Rules

* Subtle only
* Duration: 200–300ms
* Ease-in-out
* No bounce-heavy animation

### Where to Animate

* Page transitions
* Button press
* Card appearance

---

## 14. Accessibility ♿

* Color contrast ≥ WCAG AA
* Text scalable
* Buttons reachable by thumb
* Avoid color-only indicators

---

## 15. Strict Do & Don’t 🚨

### DO

✅ Use whitespace generously
✅ Highlight numbers clearly
✅ Keep screens calm

### DON’T

❌ Overuse gradients
❌ Use random colors
❌ Mix font styles
❌ Crowd information

---

## 16. AI Usage Instruction 🤖 (IMPORTANT)

> When generating UI, layouts, or components:

* Always follow this design guide
* Never invent new colors, fonts, or spacing
* If unsure → choose the simplest option
* Prioritize readability over aesthetics

---

## ✅ End of Design Guide
