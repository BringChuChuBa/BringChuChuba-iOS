//
//  DetailMissionCellViewModel.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/21.
//

import Foundation

import RxCocoa
import RxSwift

class DetailMissionCellViewModel {
    // MARK: Properties
    let title = BehaviorRelay<String?>(value: nil)
    let detail = BehaviorRelay<String?>(value: nil)
    //    let image = BehaviorRelay<UIImage?>(value: nil)

    // MARK: Initializers
    init(with title: String, detail: String) {
        //    image: UIImage?
        self.title.accept(title)
        self.detail.accept(detail)
    }
}
