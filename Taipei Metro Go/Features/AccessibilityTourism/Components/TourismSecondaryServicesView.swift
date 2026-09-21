import SwiftUI

struct TourismSecondaryServicesView: View {
    let exits: [AttractionExitInfoModel]
    let qrTicketCount: Int
    let ticketWalletMessage: String?
    let airportTransferMessage: String?
    let serviceActionMessage: String?
    let isAssistanceAlertActive: Bool
    let language: TourismLanguage
    var onSelectPass: (String) -> Void
    var onShowAirportGuide: () -> Void
    var onRequestDelivery: () -> Void
    var onToggleAssistance: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            attractionSection
            ticketSection
            airportAndDeliverySection
            assistanceSection
        }
    }

    private var attractionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeading(.attractions, symbol: "figure.roll")
            ForEach(exits) { exit in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "arrow.up.right.square.fill")
                        .font(.title2)
                        .foregroundStyle(TourismPalette.action)
                        .frame(width: 42, height: 42)
                        .background(TourismPalette.paleSurface, in: RoundedRectangle(cornerRadius: 13))
                    VStack(alignment: .leading, spacing: 5) {
                        Text(exit.attractionName)
                            .font(.headline.weight(.heavy))
                            .foregroundStyle(TourismPalette.text)
                        Text("\(exit.nearestStation) · \(exit.exitNumber)")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(TourismPalette.action)
                        Text(exitNote(for: exit))
                            .font(.subheadline)
                            .foregroundStyle(TourismPalette.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 0)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(TourismPalette.canvas, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
                .accessibilityElement(children: .combine)
            }
        }
        .tourismCard()
    }

    private var ticketSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeading(.tickets, symbol: "ticket.fill")
            HStack(spacing: 9) {
                passButton(.taipeiPass, symbol: "tram.fill")
                passButton(.funPass, symbol: "sparkles")
            }
            HStack(spacing: 10) {
                Image(systemName: "qrcode")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(TourismPalette.navy)
                Text(TourismCopy.text(.qrTickets, language: language))
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(TourismPalette.text)
                Spacer()
                Text("\(qrTicketCount)")
                    .font(.title2.weight(.heavy).monospacedDigit())
                    .foregroundStyle(TourismPalette.action)
            }
            .padding(14)
            .frame(minHeight: 58)
            .background(TourismPalette.canvas, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            if let ticketWalletMessage {
                statusMessage(ticketWalletMessage, symbol: "checkmark.circle.fill", color: TourismPalette.statusSuccess)
            }
        }
        .tourismCard()
    }

    private var airportAndDeliverySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeading(.airportTransfer, symbol: "airplane")
            Button(action: onShowAirportGuide) {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "airplane.departure")
                        .font(.headline.weight(.bold))
                    VStack(alignment: .leading, spacing: 5) {
                        Text(TourismCopy.text(.preCheckIn, language: language))
                            .font(.subheadline.weight(.semibold))
                            .multilineTextAlignment(.leading)
                        Text(TourismCopy.text(.airportMRT, language: language))
                            .font(.footnote.weight(.bold))
                            .foregroundStyle(TourismPalette.action)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "arrow.up.right")
                        .font(.caption.weight(.heavy))
                }
                .foregroundStyle(TourismPalette.text)
                .padding(14)
                .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
                .background(TourismPalette.canvas, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            .buttonStyle(.plain)
            if let airportTransferMessage {
                statusMessage(airportTransferMessage, symbol: "airplane", color: TourismPalette.action)
            }
            VStack(alignment: .leading, spacing: 10) {
                Label(TourismCopy.text(.hotelDelivery, language: language), systemImage: "shippingbox.fill")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(TourismPalette.text)
                Button(action: onRequestDelivery) {
                    Text(TourismCopy.text(.requestDelivery, language: language))
                        .font(.headline.weight(.bold))
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .foregroundStyle(TourismPalette.action)
                        .background(TourismPalette.paleSurface, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            if let serviceActionMessage {
                statusMessage(serviceActionMessage, symbol: "info.circle.fill", color: TourismPalette.action)
            }
        }
        .tourismCard()
    }

    private var assistanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeading(.assistance, symbol: "person.crop.circle.badge.exclamationmark")
            Button(action: onToggleAssistance) {
                Label(
                    TourismCopy.text(isAssistanceAlertActive ? .cancelAssistance : .assistance, language: language),
                    systemImage: isAssistanceAlertActive ? "xmark.circle.fill" : "bell.and.waves.left.and.right.fill"
                )
                .font(.headline.weight(.heavy))
                .frame(maxWidth: .infinity, minHeight: 62)
                .foregroundStyle(.white)
                .background(isAssistanceAlertActive ? TourismPalette.statusSuccess : TourismPalette.statusEmphasis, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityHint("Send or cancel a simulated station assistance request")
            if isAssistanceAlertActive {
                statusMessage(TourismCopy.text(.assistanceSent, language: language), symbol: "checkmark.shield.fill", color: TourismPalette.statusSuccess)
            }
        }
        .tourismCard()
    }

    private func sectionHeading(_ key: TourismCopy.Key, symbol: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(TourismPalette.navy, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
            Text(TourismCopy.text(key, language: language))
                .font(.title3.weight(.heavy))
                .foregroundStyle(TourismPalette.text)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }

    private func passButton(_ key: TourismCopy.Key, symbol: String) -> some View {
        let title = TourismCopy.text(key, language: language)
        return Button { onSelectPass(title) } label: {
            Label(title, systemImage: symbol)
                .font(.subheadline.weight(.bold))
                .frame(maxWidth: .infinity, minHeight: 58)
                .foregroundStyle(TourismPalette.navy)
                .background(TourismPalette.paleSurface, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityHint(TourismCopy.text(.addToWallet, language: language))
    }

    private func statusMessage(_ message: String, symbol: String, color: Color) -> some View {
        Label(message, systemImage: symbol)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(color)
            .fixedSize(horizontal: false, vertical: true)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
    }

    private func exitNote(for exit: AttractionExitInfoModel) -> String {
        switch (exit.attractionName, language) {
        case (_, .traditionalChinese): exit.luggageFriendlyNote
        case (_, .english): exit.luggageFriendlyNote
        case (_, .japanese): "エレベーターのある段差のない広い通路で、キャリーケースでも移動しやすい出口です。"
        case (_, .korean): "엘리베이터가 있는 넓고 단차 없는 통로로, 캐리어 이동에 편리한 출구입니다."
        }
    }
}

private extension View {
    func tourismCard() -> some View {
        padding(18)
            .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(TourismPalette.line, lineWidth: 1))
    }
}

#Preview {
    TourismSecondaryServicesView(
        exits: [AttractionExitInfoModel(attractionName: "台北 101", nearestStation: "台北 101／世貿站", exitNumber: "出口 4", luggageFriendlyNote: "Wide step-free route with elevator access.")],
        qrTicketCount: 2,
        ticketWalletMessage: nil,
        airportTransferMessage: nil,
        serviceActionMessage: nil,
        isAssistanceAlertActive: false,
        language: .english,
        onSelectPass: { _ in },
        onShowAirportGuide: {},
        onRequestDelivery: {},
        onToggleAssistance: {}
    )
    .padding()
    .background(TourismPalette.canvas)
}
