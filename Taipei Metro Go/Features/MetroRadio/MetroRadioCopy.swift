enum MetroRadioCopy {
    static func productName(for language: AppLanguage) -> String {
        language == .english ? "MetroTogether" : "捷客電台"
    }

    static func communityTitle(for language: AppLanguage) -> String {
        language == .english ? "Passenger Community" : "乘客交流"
    }
}
