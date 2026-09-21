import SwiftUI

struct HomeFavoriteDestination: Identifiable, Equatable {
    let id: String
    let title: String
    let station: String
    var opensRoutePlanner = false
}

struct DestinationSwitchSection: View {
    let destinations: [HomeFavoriteDestination]
    let language: AppLanguage
    @Binding var isPresented: Bool
    let onSelect: (String) -> Void
    let onOpenRoutePlanner: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(Color.primaryAction)
                Text(HomeCopy.text(.frequentRoutes, language: language))
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.primaryText)
                Spacer()
                Button { withAnimation(.easeInOut(duration: 0.18)) { isPresented = false } } label: {
                    Image(systemName: "xmark")
                        .font(.caption.weight(.bold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color.secondaryText)
            }

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)],
                spacing: 8
            ) {
                ForEach(destinations) { destination in
                    Button {
                        if destination.opensRoutePlanner {
                            onOpenRoutePlanner()
                        } else {
                            onSelect(destination.station)
                        }
                        withAnimation(.easeInOut(duration: 0.18)) { isPresented = false }
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(HomeCopy.favoriteTitle(destination.id, fallback: destination.title, language: language))
                                .font(.subheadline.weight(.bold))
                            if !destination.opensRoutePlanner {
                                Text(HomeCopy.stationName(destination.station, language: language))
                                    .font(.caption)
                                    .foregroundStyle(Color.secondaryText)
                            }
                        }
                        .foregroundStyle(Color.primaryText)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                        .background(Color.pageBackground, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }

            Button {
                onOpenRoutePlanner()
                withAnimation(.easeInOut(duration: 0.18)) { isPresented = false }
            } label: {
                HStack {
                    Text(HomeCopy.text(.routePlannerPrompt, language: language))
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.primaryAction)
                .padding(.horizontal, 4)
                .frame(minHeight: 44)
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.line, lineWidth: 1))
        .shadow(color: Color.black.opacity(0.10), radius: 10, y: 5)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
