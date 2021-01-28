//
//  DetailMissionViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/11.
//

import RxCocoa
import RxSwift

final class DetailMissionViewModel: ViewModelType {
    // MARK: Structs
    struct Input {
        let contractTrigger: Driver<Void>
    }

    struct Output {
        let items: Driver<[DetailMissionSection]>
        let contractEnable: Driver<Bool>
        let error: Driver<Error>
    }

    // MARK: Properties
    private let mission: Mission
    private let coordinator: HomeCoordinator

    // MARK: Initializers
    init(mission: Mission, coordinator: HomeCoordinator) {
        self.mission = mission
        self.coordinator = coordinator
    }

    // MARK: Methods
    func transform(input: Input) -> Output {
        // TODO: Alert 추가
        let errorTracker = ErrorTracker()

        let mission = input.contractTrigger.flatMapLatest {
            return Network.shared.request(with: .contractMission(missionUid: Int(self.mission.id)!), for: Mission.self)
                .asDriverOnErrorJustComplete()
        }.startWith(self.mission)

        let dateFormatter = DateFormatter().then {
            $0.dateFormat = Constant.dateFormat
            $0.locale = Locale.current
            $0.timeZone = TimeZone.autoupdatingCurrent
        }

        let contractEnable = mission
            .filter { $0.client.id != GlobalData.shared.id }
            .filter { $0.status == .todo }
            .filter { dateFormatter.date(from: $0.expireAt)! > Date() }
            .map { $0.contractor.isNone }
            .startWith(false)

        let items = mission.map { mission -> [DetailMissionSection] in
            var items: [DetailMissionSectionItem] = []

            // title
            let titleCellViewModel = DetailMissionCellViewModel(with: "Common.Title".localized, detail: mission.title)
            items.append(DetailMissionSectionItem.titleItem(viewModel: titleCellViewModel))

            // description
            if let description = mission.description {
                let descriptionCellViewModel = DetailMissionCellViewModel(with: "Common.Description".localized, detail: description)
                items.append(DetailMissionSectionItem.descriptionItem(viewModel: descriptionCellViewModel))
            }

            // reward
            let rewardCellViewModel = DetailMissionCellViewModel(with: "Common.Reward".localized, detail: mission.reward)
            items.append(DetailMissionSectionItem.rewardItem(viewModel: rewardCellViewModel))

            // client
            let clientCellViewModel = DetailMissionCellViewModel(with: "Common.Clinet".localized, detail: mission.client.id) // nickname
            items.append(DetailMissionSectionItem.clientItem(viewModel: clientCellViewModel))

            // contractor
            if let contractor = mission.contractor {
                let contractorCellViewModel = DetailMissionCellViewModel(with: "Common.Contractor".localized, detail: contractor.id) // nickname
                items.append(DetailMissionSectionItem.contractorItem(viewModel: contractorCellViewModel))
            }

            // expireAt
            let expireAtCellViewModel = DetailMissionCellViewModel(with: "Common.ExpireAt".localized, detail: mission.expireAt)
            items.append(DetailMissionSectionItem.expireAtItem(viewModel: expireAtCellViewModel))

            // status
            let statusCellViewModel = DetailMissionCellViewModel(with: "Common.Status".localized, detail: mission.status.rawValue)
            items.append(DetailMissionSectionItem.statusItem(viewModel: statusCellViewModel))

            var detailMissionSections: [DetailMissionSection] = []
            detailMissionSections.append(DetailMissionSection.detail(title: "", items: items))
            return detailMissionSections
        }

        return Output(items: items,
                      contractEnable: contractEnable,
                      error: errorTracker.asDriver())
    }
}
