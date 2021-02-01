//
//  RankingCellViewModel.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/24.
//

import Foundation

import RxCocoa
import RxSwift

class RankingCellViewModel {
    // MARK: Properties
    let rank = BehaviorRelay<Int?>(value: nil)
    let title = BehaviorRelay<String?>(value: nil)
    let detail = BehaviorRelay<String?>(value: nil)
    //    let image = BehaviorRelay<UIImage?>(value: nil)

    // MARK: Initializers
    init() { }

    init(with title: String, point detail: String) {
        self.title.accept(title)
        self.detail.accept(detail)
    }
}
