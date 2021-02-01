//
//  RankingViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

final class RankingViewModel: ViewModelType {
    // MARK: Structs
    struct Input {
        let trigger: Driver<Void>
        let selectedIndex: Driver<Int>
    }

    struct Output {
        let items: Driver<[RankingCellViewModel]>
        let fetching: Driver<Bool>
    }

    // MARK: Properties
    private let coordinator: RankingCoordinator

    // MARK: Initializers
    init(coordinator: RankingCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: Transform Methods
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let familyUid = Int(GlobalData.shared.familyId)! // guard error
        let members = input.trigger
            .flatMapLatest { _ -> Driver<[Member]> in
                Network.shared.request(
                    with: .getFamily(familyUid: familyUid),
                    for: Family.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .map { $0.members }
                .asDriverOnErrorJustComplete()
            }

        let selectedIndex = input.selectedIndex
            .startWith(0)

        let items = Driver
            .combineLatest(members, selectedIndex) { members, _ -> [RankingCellViewModel] in
                // switch(selectedIndex)
                // case 전체기간
                return members.sorted { $0.point < $1.point }
                    .compactMap { RankingCellViewModel(with: $0.id, point: $0.point) }

                // case 이번달
                // - point를 얻은 날짜에 대한 정보 필요
                // - mission의 modifiedAt?
                // -- 맞다면 1. mission modifiedAt이 이번달인 미션만 필터링
                // -- 2. 해당 미션의 contractor 멤버에게 점수 + 1 // thisMonthPoint 프로퍼티 필요
            }
        
        let fetching = activityIndicator.asDriver()

        return Output(
            items: items,
            fetching: fetching
        )
    }
}
