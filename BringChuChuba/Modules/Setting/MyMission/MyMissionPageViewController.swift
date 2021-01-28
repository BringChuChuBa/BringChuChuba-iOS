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
    private let missionStatus: [String] = [
        Mission.Status.todo.rawValue,
        Mission.Status.inProgress.rawValue,
        Mission.Status.complete.rawValue]

    // MARK: UI Components
    private lazy var pages: [UIViewController] = [
        MyMissionViewController(viewModel: viewModel, status: missionStatus[0]),
        MyMissionViewController(viewModel: viewModel, status: missionStatus[1]),
        MyMissionViewController(viewModel: viewModel, status: missionStatus[2])]

    private lazy var segmentedControl: UISegmentedControl = UISegmentedControl(items: missionStatus).then { seg in
        seg.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        seg.selectedSegmentIndex = 0
        seg.addTarget(self, action: #selector(segmentedControlValueDidChange), for: .valueChanged)
    }

    // MARK: Initializers
    init(viewModel: MyMissionViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
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
    }

    // MARK: Set UIs
    private func setupUI() {
        navigationItem.titleView = segmentedControl
    }
}

// MARK: Supporting Methods
extension MyMissionPageViewController {
    /// This method assigns a default ViewController to display when PageViewController is loaded.
    private func assignDefaultPage() {
        if let defaultVC = pages.first {
            setViewControllers([defaultVC], direction: .forward, animated: true, completion: nil)
        }
    }

    /// This method assigns all required delegates and data sources.
    private func assignDelegatesAndDataSources() {
        delegate = self
        dataSource = self
    }

    @objc
    private func segmentedControlValueDidChange(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if (0..<pages.count).contains(selectedIndex),
           let currentVC = viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            setViewControllers([pages[selectedIndex]], direction: selectedIndex > currentIndex ? .forward : .reverse, animated: true, completion: nil)
        }
    }
}

// MARK: UIPageViewController Delegate
extension MyMissionPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
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
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController),
              currentIndex < pages.count - 1
        else { return nil }
        return pages[currentIndex + 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController),
              currentIndex > 0
        else { return nil }
        return pages[currentIndex - 1]
    }
}
