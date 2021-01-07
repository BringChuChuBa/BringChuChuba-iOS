//
//  HomeItemViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import Foundation

struct HomeItemViewModel {
    var title: String

    init(itemModel: HomeTableViewItem) {
        self.title = itemModel.title
    }
}
