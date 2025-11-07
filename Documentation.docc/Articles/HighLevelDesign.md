# High-Level Design

## 1. Purpose and Scope

### Purpose

The `SmoothRoundedRectangle` module provides a SwiftUI shape that renders rounded rectangles with configurable smooth corner transitions. Unlike standard rounded rectangles that use simple circular arcs, this module enables fine-grained control over corner radii and smoothing styles, producing visually pleasing, continuous corner curves.

### Scope

**In Scope:**
- SwiftUI shape implementation for rounded rectangles with smooth corners
- Per-corner radius configuration with layout direction awareness
- Multiple smoothing styles (circular, continuous, custom)
- Automatic corner normalization to prevent geometric conflicts
- InsettableShape conformance for stroke border support

**Out of Scope:**
- Animation or transition effects
- Non-rectangular shapes
- Interactive shape manipulation

---

## 2. Functional Overview

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    SwiftUI Layer                            │
│  ┌───────────────────────────────────────────────────────┐  │
│  │    SmoothRoundedRectangle (InsettableShape)           │  │
│  │    - Initializers (uniform, selected, per-corner)     │  │
│  │    - path(in:) → Path                                 │  │
│  │    - inset(by:) → InsettableShape                     │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                Configuration Layer                          │
│  ┌──────────────────┐  ┌──────────────────┐                 │
│  │   Style Enum     │  │  Corners Set     │                 │
│  │  - circular      │  │  - topLeading    │                 │
│  │  - continuous    │  │  - topTrailing   │                 │
│  │  - smooth(Double)│  │  - bottomLeading │                 │
│  └──────────────────┘  │  - bottomTrailing│                 │
│                        └──────────────────┘                 │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                Processing Layer                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  normalizeCorners()                                   │  │
│  │  - Prevents corner overlap                            │  │
│  │  - Scales radius/smoothness if needed                 │  │
│  └───────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  computeParameters() → computeCurvePoints()           │  │
│  │  - Calculates bezier curve parameters                 │  │
│  │  - Computes arc parameters                            │  │
│  └───────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  drawCornerPath()                                     │  │
│  │  - Adds bezier curves for smooth transitions          │  │
│  │  - Adds circular arc for corner rounding              │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                    SwiftUI Path
```

### Data Flow

1. **Initialization**: User creates a `SmoothRoundedRectangle` with radius values and style, which are converted into corner attributes.

2. **Normalization**: The `normalizeCorners` function ensures no corner overlaps occur by scaling down radii and smoothness values when needed.

3. **Path Generation**: For each corner, parameters are computed, curve points are calculated, and the path is drawn using bezier curves and circular arcs.

4. **Path Assembly**: All four corners are drawn in sequence and the complete path is returned to SwiftUI.

---

## 3. Architecture and Components

### Core Components

#### SmoothRoundedRectangle
- **Location**: `SmoothRoundedRectangle.swift`
- **Responsibility**: Primary SwiftUI shape conforming to `InsettableShape`
- **Key Properties**: Four corner attributes (`topLeftCorner`, `topRightCorner`, `bottomLeftCorner`, `bottomRightCorner`), `insetAmount`
- **Key Methods**: `path(in:)`, `inset(by:)`
- **Initializers**: Three convenience initializers (uniform radius, selected corners, per-corner configuration)

#### Style
- **Location**: `SmoothRoundedRectangle+Attributes.swift`
- **Responsibility**: Defines smoothing style for corners
- **Variants**: `.circular` (no smoothing), `.continuous` (iOS-style), `.smooth(Double)` (custom), `.smooth` (maximum)

#### Corners
- **Location**: `SmoothRoundedRectangle+Attributes.swift`
- **Responsibility**: OptionSet for selecting which corners to round
- **Options**: `topLeading`, `topTrailing`, `bottomLeading`, `bottomTrailing`
- **Presets**: `all`, `top`, `bottom`, `leading`, `trailing`

### Helper Types

- **SmoothCornerAttributes**: Stores radius and smoothness for a single corner
- **SmoothRectangleAttributes**: Aggregates all four corner attributes
- **SmoothCornerParameters**: Computed mathematical parameters for drawing
- **Corner**: Enum identifying which corner is being processed

---

## 4. Key Design Decisions

### InsettableShape Conformance
**Decision**: Implement `InsettableShape` instead of just `Shape`.

**Rationale**: Enables accurate stroke borders with `strokeBorder` API and maintains consistency with SwiftUI's built-in shapes.

### Automatic Corner Normalization
**Decision**: Automatically normalize corners to prevent geometric conflicts.

**Rationale**: Prevents visual artifacts from overlapping corners and ensures the shape always renders correctly, even if user-specified values would cause conflicts.

### Bezier + Arc Hybrid Approach
**Decision**: Use bezier curves for smooth transitions combined with circular arcs for rounding.
