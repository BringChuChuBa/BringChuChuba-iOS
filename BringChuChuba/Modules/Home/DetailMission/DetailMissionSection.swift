//
//  DetailMissionSection.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/21.
//

import Foundation
import RxDataSources

enum DetailMissionSection {
    case detail(title: String, items: [DetailMissionSectionItem])
}

enum DetailMissionSectionItem {
    case titleItem(viewModel: DetailMissionCellViewModel)
    case descriptionItem(viewModel: DetailMissionCellViewModel)
    case rewardItem(viewModel: DetailMissionCellViewModel)
    case expireAtItem(viewModel: DetailMissionCellViewModel)
    case clientItem(viewModel: DetailMissionCellViewModel)
    case contractorItem(viewModel: DetailMissionCellViewModel)
    case statusItem(viewModel: DetailMissionCellViewModel)
//    case contractItem(viewModel: MissionContractCellViewModel)
}

extension DetailMissionSection: SectionModelType {
    typealias Item = DetailMissionSectionItem

    var title: String {
        switch self {
        case .detail(let title, _):
            return title
        }
    }

    var items: [DetailMissionSectionItem] {
        switch self {
        case .detail(_, let items):
            return items.map { $0 }
        }
    }

    init(original: DetailMissionSection,
         items: [Item]) {
        switch original {
        case .detail(let title, let items):
            self = .detail(title: title, items: items)
        }
    }
}
