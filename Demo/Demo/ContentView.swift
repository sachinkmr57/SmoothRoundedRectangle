import SwiftUI
import SmoothRoundedRectangle

struct ContentView: View {
	@State var radius: Double = 128
	@State var smoothness: Double = 100

	var body: some View {
		VStack(spacing: 64) {
			ZStack {
				RoundedRectangle(cornerRadius: radius, style: .continuous)
					.foregroundStyle(.red)

				SmoothRoundedRectangle(
					radius: radius,
					style: .smooth(smoothness)
				)
				.foregroundStyle(.indigo)
			}
			.frame(width: 512, height: 512)
			.frame(width: 254, height: 254, alignment: .bottomTrailing)

			VStack(alignment: .leading, spacing: 0) {
				HStack {
				Text("Radius")
				Spacer()
				Text(radius, format: .number.precision(.fractionLength(0)))
					.monospacedDigit()
				}
				Slider(value: $radius, in: 0...256)

				Divider().frame(height: 64)

				HStack {
					Text("Smoothness")
					Spacer()
					Text(smoothness, format: .number.precision(.fractionLength(0)))
						.monospacedDigit()
				}
				Slider(value: $smoothness, in: 0...100)
			}
		}
		.padding()
		.preferredColorScheme(.dark)
	}
}

#Preview {
    ContentView()
}
