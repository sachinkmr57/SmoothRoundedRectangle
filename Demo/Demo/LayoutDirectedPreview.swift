import SwiftUI
import SmoothRoundedRectangle

@available(iOS 16, *) // UnevenRoundedRectangle
@available(iOS 17, *) // @Previewable
#Preview {
	@Previewable @State var radius: Double = 64
	@Previewable @State var smoothness: Double = 1

	let unevenShape = UnevenRoundedRectangle(
		topLeadingRadius: 0,
		bottomLeadingRadius: 0,
		bottomTrailingRadius: radius,
		topTrailingRadius: radius,
		style: .continuous
	)

	let smoothUnevenShape = SmoothRoundedRectangle(
		topLeadingRadius: 0,
		bottomLeadingRadius: 0,
		bottomTrailingRadius: radius,
		topTrailingRadius: radius,
		style: .smooth(smoothness)
	)

	VStack {
		ForEach(LayoutDirection.allCases, id: \.self) { direction in
			unevenShape
				.fill(.red)
				.overlay {
					smoothUnevenShape
						.foregroundStyle(.indigo)
				}
				.environment(\.layoutDirection, direction)
				.overlay {
					Text(String(describing: direction))
				}
		}

		VStack(alignment: .leading, spacing: 0) {
			HStack {
				Text("Radius")
				Spacer()
				Text(radius, format: .number.precision(.fractionLength(0)))
					.monospacedDigit()
			}
			Slider(value: $radius, in: 0...128)

			Divider().frame(height: 64)

			HStack {
				Text("Smoothness")
				Spacer()
				Text(smoothness, format: .number.precision(.fractionLength(2)))
					.monospacedDigit()
			}
			Slider(value: $smoothness, in: 0...1)
		}
	}
	.padding()
	.preferredColorScheme(.dark)
}
