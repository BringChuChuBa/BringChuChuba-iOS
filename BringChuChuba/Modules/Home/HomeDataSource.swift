//
//  HomeDataSource.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import RxDataSources

struct HomeTableViewItem {
    let title: String
    // UIImage 2개
    // point

    init(title: String) {
        self.title = title
    }
}

struct HomeTableViewSection {
    let items: [HomeTableViewItem]
    let header: String
    let button: UIButton

    init(items: [HomeTableViewItem], header: String, button: UIButton) {
        self.items = items
        self.header = header
        self.button = button
    }
}

extension HomeTableViewSection: SectionModelType {
    typealias Item = HomeTableViewItem

    init(original: Self, items: [Self.Item]) {
        self = original
    }

//    var identity: String { return header }
}

struct HomeDataSource {
    typealias DataSource = RxTableViewSectionedReloadDataSource

    static func dataSource() -> DataSource<HomeTableViewSection> {
        return .init(configureCell: { _, _, _, item -> UITableViewCell in // dataSource, tableView, indexPath
            let cell = HomeContentCell()
            cell.viewModel = HomeItemViewModel(itemModel: item)
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        })
    }
}
