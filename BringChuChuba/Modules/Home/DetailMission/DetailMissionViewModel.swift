//
//  CreateMissionViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/11.
//
import RxSwift
import RxCocoa

final class DetailMissionViewModel: ViewModelType {

    // MARK: Properties
    private let mission: Mission
    private let coordinator: HomeCoordinator
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: Initializers
    init(mission: Mission, coordinator: HomeCoordinator) {
        self.mission = mission
        self.coordinator = coordinator
    }

    struct Input {
        let contractTrigger: Driver<Void>
    }

    struct Output {
        let mission: Driver<Mission>
        let contractEnable: Driver<Bool>
        let error: Driver<Error>
    }

    // MARK: Transform Methods
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()

        let mission = input.contractTrigger.flatMapLatest {
            return Network.shared.request(with: .contractMission(missionUid: Int(self.mission.id)!), for: Mission.self)
                .asDriverOnErrorJustComplete()
        }.startWith(self.mission)

        // TODO: String <-> Date 변환 extension으로 뺄지말지?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent

        let contractEnable = mission
            .filter { $0.client.id != GlobalData.shared.id }
            .filter { $0.status == "todo" } // .todo
            .filter { dateFormatter.date(from: $0.expireAt)! > Date() }
            .map { $0.contractor.isNone }
            .startWith(false)

        return Output(mission: mission,
                      contractEnable: contractEnable,
                      error: errorTracker.asDriver())
    }
}
