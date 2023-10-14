//
//  MainViewController.swift
//  WorkTimer
//
//  Created by Roman on 13.10.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    private lazy var twitterButton: UIButton = {
        let button = UIButton(type: .system)

        // Настройка основных свойств
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 35 / 2
        button.backgroundColor = .systemBlue

        // Добавление события
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()

    private lazy var countdownView: CountdownView = {
        let view = CountdownView(frame: CGRect(x: 0, y: 0,
                                               width: view.bounds.width * 0.6,
                                               height: view.bounds.width * 0.6))
        view.center = self.view.center
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(twitterButton)

        view.addSubview(countdownView)
        countdownView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(0.6)
            make.width.equalTo(view.snp.width).multipliedBy(0.6)
        }

        twitterButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }

    }

    @objc func buttonTapped() {
        countdownView.buttonAction()
    }

}
