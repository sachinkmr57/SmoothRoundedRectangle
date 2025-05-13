import SwiftUI
import SmoothRoundedRectangle

@available(iOS 17, *) // @Previewable
#Preview {
	@Previewable @State var radius: Double = 64
	@Previewable @State var smoothness: Double = -10

	let smoothUnevenShape = SmoothRoundedRectangle(
		radius: radius,
		style: .smooth(smoothness)
	)

	VStack {
		smoothUnevenShape
			.strokeBorder(lineWidth: 4)
			.foregroundStyle(.indigo)
			.aspectRatio(contentMode: .fit)
			.frame(maxHeight: .infinity)

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
			Slider(value: $smoothness, in: -10...10)
		}
	}
	.padding()
	.preferredColorScheme(.dark)
}
