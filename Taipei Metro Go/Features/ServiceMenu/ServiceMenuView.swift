import SwiftUI

@MainActor
struct ServiceMenuView: View {
    @StateObject private var viewModel = ServiceMenuViewModel()

    var body: some View {
        VStack(spacing: 0) {
            WayfindingHeader(title: "功能服務")
                .padding(.horizontal, 14)
                .padding(.top, 8)
                .padding(.bottom, 10)

            GlobalSearchBarView(searchText: $viewModel.searchText)
                .padding(.horizontal, 18)
                .padding(.top, 10)
                .padding(.bottom, 4)

            List {
                if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    DynamicShortcutsSection(
                        services: viewModel.dynamicShortcuts,
                        recommendationLabel: viewModel.recommendationLabel
                    )
                    .listRowInsets(EdgeInsets(top: 2, leading: 18, bottom: 12, trailing: 18))
                    .listRowBackground(Color.clear)

                    ServiceCategoryGridView(services: viewModel.allServices)
                        .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 30, trailing: 18))
                        .listRowBackground(Color.clear)
                } else {
                    ServiceCategoryGridView(services: viewModel.filteredServices, groupedByCategory: false)
                        .listRowInsets(EdgeInsets(top: 2, leading: 18, bottom: 30, trailing: 18))
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .listRowSpacing(0)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .background(Color.pageBackground.ignoresSafeArea())
        .preferredColorScheme(.light)
        .onAppear { viewModel.refreshDynamicShortcuts() }
    }
}

#Preview {
    ServiceMenuView()
}

#Preview("功能服務・最大輔助使用字級") {
    ServiceMenuView()
        .environment(\.dynamicTypeSize, .accessibility5)
}
