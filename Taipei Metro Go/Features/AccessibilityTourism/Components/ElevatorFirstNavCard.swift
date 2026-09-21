import SwiftUI

struct ElevatorFirstNavCard: View {
    @Binding var route: ElevatorRouteModel
    @Binding var isElevatorFirst: Bool
    let language: TourismLanguage
    var onPlanRoute: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle

            HStack(spacing: 10) {
                stationField(title: TourismCopy.text(.from, language: language), text: $route.originStation, symbol: "location.fill")
                Image(systemName: "arrow.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(TourismPalette.action)
                    .accessibilityHidden(true)
                stationField(title: TourismCopy.text(.to, language: language), text: $route.destinationStation, symbol: "mappin.and.ellipse")
            }

            Toggle(isOn: $isElevatorFirst) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(TourismCopy.text(.elevatorFirst, language: language))
                        .font(.headline.weight(.bold))
                        .foregroundStyle(TourismPalette.text)
                    Text(TourismCopy.text(.routePlan, language: language))
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(TourismPalette.secondary)
                }
            }
            .tint(TourismPalette.action)
            .accessibilityLabel(TourismCopy.text(.elevatorFirst, language: language))
            .accessibilityHint("Prefer elevators and step-free passages for the whole route")
            .onChange(of: isElevatorFirst) { _, _ in onPlanRoute() }

            HStack(spacing: 10) {
                metricTile(
                    title: TourismCopy.text(.accessibleTransfer, language: language),
                    value: "\(route.accessibleTransferMinutes) min",
                    detail: route.transferStation
                )
                metricTile(
                    title: TourismCopy.text(.estimatedTravel, language: language),
                    value: "\(route.estimatedTravelMinutes) min",
                    detail: "\(route.transferStation) · \(TourismCopy.text(.transferTime, language: language))"
                )
            }

            Label {
                VStack(alignment: .leading, spacing: 4) {
                    Text(TourismCopy.text(.elevatorInstructions, language: language))
                        .font(.subheadline.weight(.heavy))
                        .foregroundStyle(TourismPalette.navy)
                    Text(route.elevatorMovementInstructions)
                        .font(.subheadline)
                        .foregroundStyle(TourismPalette.text)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } icon: {
                Image(systemName: "figure.roll")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(TourismPalette.action)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(TourismPalette.paleSurface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .accessibilityElement(children: .combine)

            Button(action: onPlanRoute) {
                Label(TourismCopy.text(.findRoute, language: language), systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity, minHeight: 58)
                    .foregroundStyle(.white)
                    .background(TourismPalette.navy, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityHint("Plan a route with the selected elevator preference")
        }
        .padding(18)
        .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(TourismPalette.line, lineWidth: 1))
    }

    private var sectionTitle: some View {
        HStack(spacing: 10) {
            Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(TourismPalette.action, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(TourismCopy.text(.routePlan, language: language))
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(TourismPalette.text)
                Text(TourismCopy.text(.elevatorFirst, language: language))
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(TourismPalette.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }

    private func stationField(title: String, text: Binding<String>, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Label(title, systemImage: symbol)
                .font(.footnote.weight(.bold))
                .foregroundStyle(TourismPalette.secondary)
                .fixedSize(horizontal: false, vertical: true)
            TextField(title, text: text)
                .font(.body.weight(.bold))
                .foregroundStyle(TourismPalette.text)
                .textInputAutocapitalization(.words)
                .submitLabel(.done)
                .padding(.horizontal, 12)
                .frame(minHeight: 52)
                .background(TourismPalette.canvas, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                .accessibilityLabel(title)
                .accessibilityHint("Enter a station or attraction")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func metricTile(title: String, value: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(TourismPalette.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Text(value)
                .font(.title3.weight(.heavy))
                .foregroundStyle(TourismPalette.navy)
            Text(detail)
                .font(.footnote.weight(.medium))
                .foregroundStyle(TourismPalette.text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 82, alignment: .leading)
        .padding(12)
        .background(TourismPalette.canvas, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    @Previewable @State var route = ElevatorRouteModel(
        originStation: "台北車站",
        destinationStation: "台北 101",
        transferStation: "市政府站",
        accessibleTransferMinutes: 8,
        estimatedTravelMinutes: 28,
        elevatorMovementInstructions: "Follow the elevator-only signs to the Bannan Line platform."
    )
    @Previewable @State var elevatorFirst = true

    ElevatorFirstNavCard(route: $route, isElevatorFirst: $elevatorFirst, language: .english, onPlanRoute: {})
        .padding()
        .background(TourismPalette.canvas)
}
