# ``SmoothRoundedRectangle``

A custom SwiftUI shape which mimics Figma's smooth corner rounding for rectangles. 

@Metadata {
  @TechnologyRoot
}

## Overview

SmoothRoundedRectangle is a customizable SwiftUI shape that mimics Figma's smooth corner rounding for rectangles. The smoothness value can be anything between 0 to 1, 0 with completely circular corner radius and 1 with full smoothness. Corners to which rounding has to be applied can be specified as well. The amount of rounding can be even more than half of the smaller dimension of rectangle just like in Figma.

## Essentials
@Links(visualStyle: compactGrid) {
   - <doc:HighLevelDesign>
}
