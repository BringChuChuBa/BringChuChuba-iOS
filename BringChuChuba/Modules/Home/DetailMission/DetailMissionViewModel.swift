//
//  DetailMissionViewModel.swift
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

    // MARK: Initializers
    init(mission: Mission, coordinator: HomeCoordinator) {
        self.mission = mission
        self.coordinator = coordinator
    }

    struct Input {
        let contractTrigger: Driver<Void>
    }

    struct Output {
        let items: Driver<[DetailMissionSection]>
        let contractEnable: Driver<Bool>
        let error: Driver<Error>
    }

    // MARK: Transform Methods
    func transform(input: Input) -> Output {
        // TODO: Alert 추가
        let errorTracker = ErrorTracker()

        let mission = input.contractTrigger.flatMapLatest {
            return Network.shared
                .request(with: .contractMission(missionUid: Int(self.mission.id)!),
                         for: Mission.self)
                .asDriverOnErrorJustComplete()
        }.startWith(self.mission)

        let dateFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy-MM-dd HH:mm"
            $0.locale = Locale.current
            $0.timeZone = TimeZone.autoupdatingCurrent
        }

        let contractEnable = mission
            .filter { $0.client.id != GlobalData.shared.id }
            .filter { $0.status == "todo" } // .todo
            .filter { dateFormatter.date(from: $0.expireAt)! > Date() }
            .map { $0.contractor.isNone }
            .startWith(false)

        let items = mission.map { mission -> [DetailMissionSection] in
            var items: [DetailMissionSectionItem] = []

            // title
            let titleCellViewModel = DetailMissionCellViewModel(with: "미션", detail: mission.title)
            items.append(DetailMissionSectionItem.titleItem(viewModel: titleCellViewModel))

            // description
            if let description = mission.description {
                let descriptionCellViewModel = DetailMissionCellViewModel(with: "설명", detail: description)
                items.append(DetailMissionSectionItem.descriptionItem(viewModel: descriptionCellViewModel))
            }

            // reward
            let rewardCellViewModel = DetailMissionCellViewModel(with: "보상", detail: mission.reward)
            items.append(DetailMissionSectionItem.rewardItem(viewModel: rewardCellViewModel))

            // client
            let clientCellViewModel = DetailMissionCellViewModel(with: "요청자", detail: mission.client.id) // nickname
            items.append(DetailMissionSectionItem.clientItem(viewModel: clientCellViewModel))

            // contractor
            if let contractor = mission.contractor {
                let contractorCellViewModel = DetailMissionCellViewModel(with: "수행자", detail: contractor.id) // nickname
                items.append(DetailMissionSectionItem.contractorItem(viewModel: contractorCellViewModel))
            }

            // expireAt
            let expireAtCellViewModel = DetailMissionCellViewModel(with: "마감기한", detail: mission.expireAt)
            items.append(DetailMissionSectionItem.expireAtItem(viewModel: expireAtCellViewModel))

            // status
            let statusCellViewModel = DetailMissionCellViewModel(with: "상태", detail: mission.status)
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
