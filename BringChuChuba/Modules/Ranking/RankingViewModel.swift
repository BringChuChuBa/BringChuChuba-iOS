//
//  RankingViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

final class RankingViewModel: ViewModelType {
    // MARK: - Structs
    struct Input {
        let selectedIndex: Driver<Int>
    }

    struct Output {
        let items: Driver<[RankingCellViewModel]>
    }

    // MARK: - Properties
    private let coordinator: RankingCoordinator

    // MARK: - Initializers
    init(coordinator: RankingCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Methods
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let members = Network.shared.request(with: .getFamily(familyUid: Int(GlobalData.shared.familyId)!),
                                             for: Family.self)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .map { $0.members }

        let selectedIndex = input.selectedIndex
            .startWith(0)
            .asObservable()

        let items = Observable
            .combineLatest(members, selectedIndex) { members, index -> [RankingCellViewModel] in
                // 0 = all, 1 = monthly
                    return members.sorted { $0.point < $1.point }
                        .map { RankingCellViewModel(with: $0.id, detail: $0.point) }
            }
            .asDriverOnErrorJustComplete()

        return Output(items: items)
    }
}
