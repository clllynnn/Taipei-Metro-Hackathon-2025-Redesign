import SwiftUI

struct QuickDestinationSection: View {
    let destinations: [QuickDestination]
    let contrastMode: HighContrastMode
    let selectedDestinationID: String?
    let routePlanningMessage: String?
    var onSelect: (QuickDestination) -> Void

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("常用目的地")
                .font(.title2.weight(.heavy))
                .foregroundStyle(contrastMode.foregroundColor)
                .accessibilityAddTraits(.isHeader)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(destinations) { destination in
                    destinationButton(destination)
                }
            }

            if let routePlanningMessage {
                Label(routePlanningMessage, systemImage: "checkmark.circle.fill")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(contrastMode.foregroundColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.updatesFrequently)
            }
        }
    }

    private func destinationButton(_ destination: QuickDestination) -> some View {
        let isSelected = selectedDestinationID == destination.id

        return Button {
            onSelect(destination)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: destination.iconName)
                    .font(.largeTitle.weight(.semibold))
                    .frame(minHeight: 48)
                    .foregroundStyle(contrastMode.accentColor)
                    .accessibilityHidden(true)

                Text(destination.title)
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(contrastMode.foregroundColor)
                    .fixedSize(horizontal: false, vertical: true)

                Text(destination.targetStation)
                    .font(.body.weight(.bold))
                    .foregroundStyle(contrastMode.foregroundColor)
                    .fixedSize(horizontal: false, vertical: true)

                Text(destination.addressNote)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(contrastMode.secondaryColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
            .padding(14)
            .background(contrastMode.surfaceColor, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(contrastMode.borderColor, lineWidth: isSelected ? 4 : 2)
            }
            .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(destination.title)，\(destination.targetStation)，\(destination.addressNote)")
        .accessibilityHint("點兩下規劃前往此目的地的無障礙路線")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    QuickDestinationSection(
        destinations: [
            QuickDestination(id: "home", title: "回家", iconName: "house.fill", targetStation: "大安站", addressNote: "信義路三段附近"),
            QuickDestination(id: "hospital", title: "台大醫院", iconName: "cross.case.fill", targetStation: "台大醫院站", addressNote: "中山南路 7 號"),
            QuickDestination(id: "daughter", title: "女兒家", iconName: "person.fill", targetStation: "永春站", addressNote: "松山路附近")
        ],
        contrastMode: .grayOnBlack,
        selectedDestinationID: nil,
        routePlanningMessage: nil,
        onSelect: { _ in }
    )
    .padding()
    .background(HighContrastMode.grayOnBlack.backgroundColor)
}
