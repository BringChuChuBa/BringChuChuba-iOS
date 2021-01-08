//
//  HomeItemViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import Foundation

final class HomeItemViewModel {
    // MARK: Properties
    let title: String
    let subtitle: String
    let mission: Mission

    // MARK: Initializers
    init (with mission: Mission) {
        self.mission = mission
        self.title = mission.title.uppercased()
        self.subtitle = mission.description
    }
}
