# SmoothRoundedRectangle <br> [![license](https://badgen.net/badge/license/MIT/green?icon=github)](./LICENSE) [![language](https://badgen.net/badge/language/Swift/orange?icon=apple)](./LANGUAGE)

## Overview
A custom SwiftUI shape which mimics Figma's smooth corner rounding for rectangles. The smoothness value can be anything between 0 to 1, 0 with completely circular corner radius and 1 with full smoothness. Corners to which rounding has to be applied can be specified as well. The amount of rounding can be even more than half of the smaller dimension of rectangle just like in Figma.

### Detail explanation
Article: [Parametric corner smoothing in SwiftUI](https://medium.com/@zvyom/parametric-corner-smoothing-in-swiftui-108acea52874)

## Usage
Below are few examples:
#### Uniform radii on all corners with custom smoothing
``` swift
SmoothRoundedRectangle(radius: 80, style: .smooth(1))
    .fill(.cyan)
    .frame(width: 240, height: 240)
```

#### Uniform radii on selected corners
``` swift
SmoothRoundedRectangle(radius: 80, corners: [.topLeading, .bottomTrailing])
    .fill(.green)
    .frame(width: 240, height: 80)
```

#### Different radii on different corners
``` swift
SmoothRoundedRectangle(
    topLeadingRadius: 80,
    bottomLeadingRadius: 80,
    bottomTrailingRadius: 20,
    topTrailingRadius: 20,
    style: .continuous
)
.frame(width: 240, height: 120)
```

### Using inside clipShape
``` swift
ContentView()
    .clipShape(SmoothRoundedRectangle(radius: 12, style: .continues))
```
## Results and comparison
#### A comparison of zero smoothness and 70%. <br>
The indigo corner has 70% smoothing and the green one has no smoothing. <br>
![Group 7](https://github.com/user-attachments/assets/0390b622-a23f-42a9-a19f-0b12a059e6bb)

#### A comparison of different smoothnesses and comparison with Figma's smoothness. <br>
<img width="2541" alt="Comparison" src="https://github.com/user-attachments/assets/4e3bf650-7670-483c-889f-ec865a756972">

