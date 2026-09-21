import SwiftUI

struct ServiceCategoryGridView: View {
    let services: [ServiceItem]
    var groupedByCategory = true

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    var body: some View {
        if groupedByCategory {
            VStack(alignment: .leading, spacing: 21) {
                ForEach(ServiceCategory.allCases) { category in
                    let categoryServices = services.filter {
                        $0.category == category
                    }
                    if !categoryServices.isEmpty {
                        categorySection(category, services: categoryServices)
                    }
                }
            }
        } else {
            VStack(alignment: .leading, spacing: 13) {
                HStack(alignment: .firstTextBaseline) {
                    Text("搜尋結果")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.primaryText)
                    Spacer()
                    Text("\(services.count) 項服務")
                        .font(.system(.footnote, weight: .medium))
                        .foregroundStyle(Color.secondaryText)
                }

                if services.isEmpty {
                    emptyResults
                } else {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(services) { service in
                            ServiceCard(service: service)
                        }
                    }
                }
            }
        }
    }

    private func categorySection(_ category: ServiceCategory, services: [ServiceItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 9) {
                Image(systemName: category.iconName)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.primaryAction)
                    .frame(width: 30, height: 30)
                    .background(Color.softSurface, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.title)
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.primaryText)
                    Text(category.subtitle)
                        .font(.system(.footnote, weight: .medium))
                        .foregroundStyle(Color.secondaryText)
                }
                Spacer()
                Text("\(services.count)")
                    .font(.system(.caption2, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.secondaryText)
            }

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(services) { service in
                    ServiceCard(service: service)
                }
            }
        }
    }

    private var emptyResults: some View {
        VStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(Color.primaryAction.opacity(0.7))
            Text("找不到符合的服務")
                .font(.system(.subheadline, weight: .bold))
                .foregroundStyle(Color.primaryText)
            Text("試試其他關鍵字，例如「列車」、「票卡」或「地圖」")
                .font(.system(.footnote, weight: .medium))
                .foregroundStyle(Color.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 31)
        .padding(.horizontal, 20)
        .background(.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct ServiceCard: View {
    let service: ServiceItem

    var body: some View {
        Button {} label: {
            HStack(spacing: 11) {
                Image(systemName: service.iconName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.primaryAction)
                    .frame(width: 42, height: 42)
                    .background(Color.softSurface.opacity(0.8), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                Text(service.name)
                    .font(.system(.footnote, weight: .bold))
                    .foregroundStyle(Color.primaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .padding(12)
            .frame(
                maxWidth: .infinity,
                minHeight: ServiceMenuLayout.cardHeight,
                maxHeight: ServiceMenuLayout.cardHeight,
                alignment: .leading
            )
            .background(.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.line.opacity(0.75), lineWidth: 1)
            }
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

#Preview("分類總覽") {
    ServiceCategoryGridView(services: ServiceMenuViewModel().allServices)
        .padding()
        .background(Color.pageBackground)
}
