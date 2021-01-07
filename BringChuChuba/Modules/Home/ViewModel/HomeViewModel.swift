//
//  HomeViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxSwift

final class HomeViewModel {
    // MARK: - Properties
    private let coordinator: HomeCoordinator
    private let disposeBag = DisposeBag()
    public let missions: PublishSubject<[Mission]> = PublishSubject()
    public let isLoading: PublishSubject<Bool> = PublishSubject()

    let items = BehaviorSubject<[HomeTableViewSection]>(value: [

        HomeTableViewSection(
            items: [
                HomeTableViewItem(title: "1"),
                HomeTableViewItem(title: "2"),
                HomeTableViewItem(title: "3"),
                HomeTableViewItem(title: "4"),
                HomeTableViewItem(title: "5")
            ],
            header: "First Section",
            button: UIButton(type: .system)),

        HomeTableViewSection(
            items: [
                HomeTableViewItem(title: "6"),
                HomeTableViewItem(title: "7"),
                HomeTableViewItem(title: "8"),
                HomeTableViewItem(title: "9"),
                HomeTableViewItem(title: "10")
            ],
            header: "Second Section",
            button: UIButton(type: .system))
    ])

    let dataSource = HomeDataSource.dataSource()

    // MARK: - Initializers
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

    func fetchData() {
        isLoading.onNext(true)
        Mock.getMissions()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in // [unowned self] response in
                print("End Point Called")
//                self.missions.onNext(response.mission)
                self.isLoading.onNext(false)
            }, onError: { error in
                switch error {
//                case APIError.~ ~~~~
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

class Mock {
    static func getMissions() -> Observable<Mission> {
        // request(APIRouter.getPosts)
        return Observable.never()
    }
}
