//
//  DoingItemViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import Foundation

final class DoingMissionItemViewModel {
    // MARK: Properties
    let title: String
    let subtitle: String
    let mission: Mission

    // MARK: Initializers
    init (with mission: Mission) {
        self.mission = mission
        self.title = mission.title
        self.subtitle = mission.description ?? "미션 설명"
    }
}
