//
//  MyMissionItemViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import Foundation

final class MyMissionItemViewModel {
    // MARK: Properties
    let title: String
    let description: String
    let reward: String
    let mission: Mission

    // MARK: Initializers
    init (with mission: Mission) {
        self.mission = mission
        self.title = mission.title
        self.description = mission.description ?? "미션 설명"
        self.reward = mission.reward ?? "보상은 옵셔널이 아닐텐데?"
    }
}
