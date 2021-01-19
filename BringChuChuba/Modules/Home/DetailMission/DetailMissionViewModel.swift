//
//  CreateMissionViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/11.
//
import RxSwift
import RxCocoa

final class DetailMissionViewModel: ViewModelType {
    // MARK: - Properties
    private let mission: Mission
    private let coordinator: HomeCoordinator
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Initializers
    init(mission: Mission, coordinator: HomeCoordinator) {
        self.mission = mission
        self.coordinator = coordinator
    }

    // MARK: - Transform Methods
    func transform(input: Input) -> Output {

        let mission = Driver.just(self.mission)
            .debug()

        // TODO: mission.expiredDate < currentDate
        let contractEnable = mission
            .map { mission -> Bool in
                return mission.client.id != GlobalData.shared.id &&
                    mission.status == "todo" &&
                mission.contractor.isNone ? true : false
            }

        return Output(mission: mission, contractEnable: contractEnable)
    }
}

extension DetailMissionViewModel {
    struct Input {
        let contractTrigger: Driver<Void>
    }

    struct Output {
        let mission: Driver<Mission>
        let contractEnable: Driver<Bool>
        // let contract
    }
}
