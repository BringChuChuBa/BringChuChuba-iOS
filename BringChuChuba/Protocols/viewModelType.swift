//
//  viewModelType.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/07.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
