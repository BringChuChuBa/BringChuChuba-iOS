//
//  LaunchInstructor.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

enum LaunchInstructor {
    case home
    case calender
    case ranking
    case users

    // MARK: - Example
    // 아마 AppDel에서 configure가 실행될 때 마지막에 껐던 기록된 VC? Coor? 등을 불러와서 switch case에 따라 return 해야할 듯?
//    static func configure(isAutorized: Bool = false) -> LaunchInstructor {
//        let isAutorized = isAutorized
//
//        switch isAutorized {
//        case false: return .auth
//        case true: return .main
//        }
//    }
}
