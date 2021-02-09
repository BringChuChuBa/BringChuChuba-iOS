//
//  MyMissionPageViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/20.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MyMissionPageViewController: UIPageViewController {
    // MARK: Properties
    private var viewModel: MyMissionViewModel!
    private let disposeBag = DisposeBag()

    // MARK: UI Components
    private lazy var pages: [UIViewController] = [
        MyMissionViewController(viewModel: viewModel,
                                status: Mission.Status.todo.rawValue),
        MyMissionViewController(viewModel: viewModel,
                                status: Mission.Status.inProgress.rawValue),
        MyMissionViewController(viewModel: viewModel,
                                status: Mission.Status.complete.rawValue)
    ]

    private lazy var segmentedControl = UISegmentedControl(
        items: Mission.Status.allCases.map { $0.title }
    ).then {
        navigationItem.titleView = $0

        $0.selectedSegmentIndex = 0
        $0.autoresizingMask = .flexibleWidth
        $0.addTarget(self,
                     action: #selector(segmentedControlValueDidChange),
                     for: .valueChanged)
    }
    
    // MARK: Initializers
    init(viewModel: MyMissionViewModel) {
        self.viewModel = viewModel
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        assignDelegatesAndDataSources()
        assignDefaultPage()
//        removeSwipeGesture()
    }
    
    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

//        navigationItem.title = "MyMission.Navigation.Title".localized
        navigationItem.titleView = segmentedControl
    }
}

// MARK: Supporting Methods
extension MyMissionPageViewController {
    /// This method assigns all required delegates and data sources.
    private func assignDelegatesAndDataSources() {
        delegate = self
        dataSource = self
    }

    /// This method assigns a default ViewController to display when PageViewController is loaded.
    private func assignDefaultPage() {
        if let defaultVC = pages.first {
            setViewControllers([defaultVC],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

    private func removeSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    @objc
    private func segmentedControlValueDidChange(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let range = Range(0...2)

        if range ~= selectedIndex,
           let currentVC = viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            setViewControllers(
                [pages[selectedIndex]],
                direction: selectedIndex > currentIndex ? .forward : .reverse,
                animated: true,
                completion: nil
            )
        }
    }
}

// MARK: UIPageViewController Delegate
extension MyMissionPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if finished,
           completed,
           let currentVC = viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            segmentedControl.selectedSegmentIndex = currentIndex
        }
    }
}
 
// MARK: UIPageViewController DataSource
extension MyMissionPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController)
    -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController),
              currentIndex < pages.count - 1 else { return nil }
        return pages[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController)
    -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController),
              currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }
}
