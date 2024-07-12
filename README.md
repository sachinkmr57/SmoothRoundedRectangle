# SmoothRoundedRectangle <br> [![license](https://badgen.net/badge/license/MIT/green?icon=github)](./LICENSE) [![language](https://badgen.net/badge/language/Swift/orange?icon=apple)](./LANGUAGE)

## Overview
A custom SwiftUI shape which mimics Figma's smooth corner rounding for rectangles. The smoothness value can be anyting between 0 to 100, 0 with completely circular corner radius and 100 with full smoothness. Corners to which rounding has to be applied can be specified as well. The amount of rounding can be even more than half of the smaller dimension of rectangle just like in Figma.

## Usage
Below are few examples:
#### Uniform radii on all corners with custom smoothing
``` swift
SmoothRoundedRectangle(radius: 80, smoothness: .custom(100))
    .fill(Color.cyan)
    .frame(width: 240, height: 240)
```

#### Uniform radii on selected corners
``` swift
SmoothRoundedRectangle(radius: 80, corners: [.topLeft, .bottomRight])
    .fill(Color.green)
    .frame(width: 240, height: 80)
```

#### Different radii on different corners
``` swift
SmoothRoundedRectangle(
    topLeft: 80,
    topRight: 20,
    bottomRight: 80,
    bottomLeft: 20,
    smoothness: .iOS)
    .frame(width: 240, height: 120)
```
