//
//  HomeDataSource.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import RxDataSources

struct HomeTableViewSection {
    var items: [Mission]
    var header: String
}

extension HomeTableViewSection: SectionModelType {
    typealias Item = Mission

    init(original: HomeTableViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct HomeDataSource {
    typealias DataSource = RxTableViewSectionedReloadDataSource

    static func dataSource() -> DataSource<HomeTableViewSection> {
        return .init(configureCell: { _, _, _, _ -> UITableViewCell in // dataSource, tableView, indexPath, item
            let cell = HomeTableViewCell()
//            cell.viewModel = HomeItemViewModel(with: item)
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        })
    }
}
