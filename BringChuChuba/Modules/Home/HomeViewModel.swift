//
//  HomeViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    // MARK: - Structs
    struct Input {
        let trigger: Driver<Void>
        let createMissionTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }

    struct Output {
        let fetching: Driver<Bool>
        let missions: Driver<[HomeItemViewModel]>
        let createMission: Driver<Void>
        let selectedMission: Driver<Mission>
        let error: Driver<Error>
    }

    // MARK: - Properties
    private let coordinator: HomeCoordinator
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Initializers
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let memberDriver = input.trigger
            .flatMapLatest { _ -> Driver<Member> in
                return Network.shared.getMember()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }

        let missions = memberDriver
            .flatMap { member -> Driver<[HomeItemViewModel]> in
                guard let familyId = member.familyId else { return Driver.empty() }

                // 이 부분 고쳐야함
                if let point = member.point { GlobalData.shared.memberPoint = point }

                return Network.shared.getMissions(familyId: familyId)
                    .asDriverOnErrorJustComplete()
                    .map { missions in
                        missions.map { mission in
                            HomeItemViewModel(with: mission)
                        }
                    }
            }

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        let selectedMission = input.selection
            .withLatestFrom(missions) { (indexPath, missions) -> Mission in
                return missions[indexPath.row].mission
            }
            .do(onNext: coordinator.toDetailMission)

        let createMission = input.createMissionTrigger
            .do(onNext: coordinator.toCreateMission)

        // 목록보기 버튼 추가
        return Output(fetching: fetching,
                      missions: missions,
                      createMission: createMission,
                      selectedMission: selectedMission,
                      error: errors)
    }

    //    func save(post: Mission) -> Observable<Void> {
    //        return Observable.never()
    //    }
    //
    //    func delete(post: Mission) -> Observable<Void> {
    //        return Observable.never()
    //    }
    //
    //    static func getMissions() -> Observable<Mission> {
    //        // request(APIRouter.getPosts)
    //        return Observable.never()
    //    }
}

// final class PostsUseCase<Cache>: Domain.PostsUseCase where Cache: AbstractCache, Cache.T == Post {
//     private let network: PostsNetwork
//     private let cache: Cache
//
//     init(network: PostsNetwork, cache: Cache) {
//         self.network = network
//         self.cache = cache
//     }
//
//     func posts() -> Observable<[Post]> {
//         let fetchPosts = cache.fetchObjects().asObservable()
//         let stored = network.fetchPosts()
//             .flatMap {
//                 return self.cache.save(objects: $0)
//                     .asObservable()
//                     .map(to: [Post].self)
//                     .concat(Observable.just($0))
//             }
//
//         return fetchPosts.concat(stored)
//     }
//
//     func save(post: Post) -> Observable<Void> {
//         return network.createPost(post: post)
//             .map { _ in }
//     }
//
//     func delete(post: Post) -> Observable<Void> {
//         return network.deletePost(postId: post.uid).map({_ in})
//     }
// }

/*
 func fetchRemotePosts() -> Completable {
         return .create { observer in
             Network.shared.getMember()
                 .subscribe(onSuccess: { member in
                     // we fetched the posts
                     observer(.completed)
                 }, onError: { error in
                     // there was an error fetching the posts
                     observer(.error(error))
                 })
         }
     }
 */
