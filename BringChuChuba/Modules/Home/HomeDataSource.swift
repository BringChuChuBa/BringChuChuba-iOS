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
//    var button: UIButton
//
//    init(items: [Mission], header: String, button: UIButton) {
//        self.items = items
//        self.header = header
//        self.button = button
//    }
}

extension HomeTableViewSection: SectionModelType {
    typealias Item = Mission

    init(original: HomeTableViewSection, items: [Item]) {
        self = original
        self.items = items
    }

//    var identity: String { return header }
}

struct HomeDataSource {
    typealias DataSource = RxTableViewSectionedReloadDataSource

    static func dataSource() -> DataSource<HomeTableViewSection> {
        return .init(configureCell: { _, _, _, item -> UITableViewCell in // dataSource, tableView, indexPath
            let cell = HomeTableViewCell()
//            cell.viewModel = HomeItemViewModel(with: item)
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        })
    }
}
