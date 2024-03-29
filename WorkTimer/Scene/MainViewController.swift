//
//  MainViewController.swift
//  WorkTimer
//
//  Created by Roman on 13.10.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    // MARK: - Properties



    // MARK: - Components
    private lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        // Добавление события
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()

    private lazy var countdownView: CountdownView = {
        let view = CountdownView(frame: CGRect(x: 0, y: 0,
                                               width: getSmallestSideSize(),
                                               height: getSmallestSideSize()))
        view.center = self.view.center
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupConstraints()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.setupConstraints()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupConstraints()
        setupComponents()
        setupText()
    }

    private func setupHierarchy() {
        view.addSubview(playPauseButton)
        view.addSubview(countdownView)
    }

    private func setupComponents() {
        setButtonDesign()
        countdownView.delegate = self

    }

    private func setupText() {

    }

    private func setupConstraints() {
        if UIDevice.current.orientation.isPortrait {
            countdownView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(countdownView.snp.height)
                make.height.equalTo(getSmallestSideSize())
            }
            
            playPauseButton.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
//                let t = (view.bounds.midY + getSmallestSideSize() / 2) + (view.bounds.height - (view.bounds.midY + getSmallestSideSize() / 2)) / 2
                let midY = view.bounds.height / 2 + view.bounds.midY / 2 + getSmallestSideSize() / 4
                make.centerY.equalTo(midY)

                make.height.equalTo(100)
                make.width.equalTo(100)
            }
        }
        if UIDevice.current.orientation.isLandscape {
            countdownView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(countdownView.snp.height)
                make.height.equalTo(getSmallestSideSize())
                make.centerX.equalToSuperview().dividedBy(2)
            }

            playPauseButton.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().multipliedBy(1.5)

                make.height.equalTo(100)
                make.width.equalTo(100)
            }
        }
    }

    // MARK: - Actions
    @objc func buttonTapped() {
        countdownView.buttonAction()
        setButtonDesign()
    }

    // MARK: - Functions
    private func forOrientation(portrait: CGFloat, landscape: CGFloat) -> CGFloat {
        return UIDevice.current.orientation.isPortrait ? portrait : landscape
    }

    private func setButtonDesign() {
        if countdownView.isRunning {
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)

        } else {
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        
        if countdownView.isWorkTime {
            playPauseButton.tintColor =  UIColor(named: "WorkColor")
        } else {
            playPauseButton.tintColor = UIColor(named: "RestColor")
        }
    }

    private func getSmallestSideSize() -> Double {
        return min(view.bounds.width, view.bounds.height) * 0.6
    }

}

// MARK: - CountdownViewDelegate
extension MainViewController: CountdownViewDelegate {
    func countdownDidComplete() {
        setButtonDesign()
    }
}
