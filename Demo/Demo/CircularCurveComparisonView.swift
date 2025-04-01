import SwiftUI
import SmoothRoundedRectangle

struct CircularCurveComparisonView: View {
	@State var radius: Double = 8
	@State var smoothness: Double = 1

	let sizes: [CGFloat] = [16, 32, 48, 64, 128, 256]

	var body: some View {
		VStack(spacing: 8) {
			ForEach(sizes, id: \.self) { size in

				ZStack {
					RoundedRectangle(cornerRadius: radius, style: .continuous)
						.foregroundStyle(.red)

					SmoothRoundedRectangle(
						radius: radius,
						style: .smooth(smoothness)
					)
					.foregroundStyle(.indigo)
				}
				.frame(width: size, height: size)
			}

			VStack(alignment: .leading, spacing: 0) {
				HStack {
					Text("Radius")
					Spacer()
					Text(radius, format: .number.precision(.fractionLength(0)))
						.monospacedDigit()
				}
				Slider(value: $radius, in: 0...sizes.last!)

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
}

#Preview {
	CircularCurveComparisonView()
}
