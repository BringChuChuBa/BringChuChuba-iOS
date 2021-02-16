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
        let segmentSelected: Driver<Periods>
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

        let familyUid = Int(GlobalData.shared.familyId)! // guard
        let family = input.trigger.flatMapLatest {
            return Network.shared.request(
                with: .getFamily(familyUid: familyUid),
                for: Family.self
            )
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
        }

        let items = Driver
            .combineLatest(
                family,
                input.segmentSelected
            ) { family, segmentSelected -> [RankingCellViewModel] in
                switch segmentSelected {
                case .all:
                    return family.members
                        .sorted { $0.point > $1.point }
                        .compactMap { RankingCellViewModel(
                            with: $0.id,
                            point: $0.point
                        ) }
                case .monthly:
                    let count = family.missions
                        .filter { $0.status == .complete }
                        .filter { $0.contractor.isSome }
                        .filter { $0.modifiedAt.toDate.isDateInThisMonth }
                        .filter { $0.contractor.isSome }
                        .map { $0.contractor! }
                        .reduce(into: [:]) { counts, member in
                            counts[member, default: 0] += 1
                        }
                    return count.sorted { $0.value > $1.value }
                        .compactMap { RankingCellViewModel(
                            with: $0.key.id,
                            point: $0.value.toString
                        ) }
                }
            }
        
        let fetching = activityIndicator.asDriver()

        return Output(
            items: items,
            fetching: fetching
        )
    }
}
