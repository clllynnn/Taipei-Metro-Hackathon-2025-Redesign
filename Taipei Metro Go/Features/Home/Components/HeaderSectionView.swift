import SwiftUI

struct HeaderSectionView: View {
    @Binding var currentLanguage: AppLanguage
    @Binding var appMode: AppMode
    var isCompact = false

    var body: some View {
        ZStack {
            Text(brandTitle)
                .font(.system(size: isCompact ? 21 : 23, weight: .semibold, design: .default))
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Spacer(minLength: 0)
                settingsMenu
            }
        }
        .padding(.horizontal, isCompact ? 14 : 18)
        .frame(maxWidth: .infinity)
        .frame(height: isCompact ? 54 : 60)
        .background(Color.pageBackground.ignoresSafeArea(edges: .top))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.line.opacity(0.45))
                .frame(height: 0.5)
        }
    }

    private var brandTitle: String {
        switch currentLanguage {
        case .traditionalChinese: "台北捷運"
        case .english: "Taipei Metro GO"
        case .japanese: "台北メトロ"
        case .korean: "타이베이 메트로"
        }
    }

    private var settingsMenu: some View {
        Menu {
            Menu {
                ForEach(AppLanguage.allCases) { language in
                    Button {
                        currentLanguage = language
                    } label: {
                        if language == currentLanguage {
                            Label(language.displayName, systemImage: "checkmark")
                        } else {
                            Text(language.displayName)
                        }
                    }
                }
            } label: {
                Label(HomeCopy.text(.language, language: currentLanguage), systemImage: "globe")
            }
            Divider()
            ForEach(AppMode.allCases) { mode in
                Button {
                    appMode = mode
                } label: {
                    if mode == appMode {
                        Label(mode.title(language: currentLanguage), systemImage: "checkmark")
                    } else {
                        Label(mode.title(language: currentLanguage), systemImage: mode.symbol)
                    }
                }
            }
        } label: {
            Image(systemName: "gearshape")
                .font(.title3.weight(.medium))
                .foregroundStyle(Color.black)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(HomeCopy.text(.language, language: currentLanguage))、\(HomeCopy.text(.mode, language: currentLanguage))")
    }
}

#Preview {
    HeaderSectionView(
        currentLanguage: .constant(.traditionalChinese),
        appMode: .constant(.normal)
    )
}
