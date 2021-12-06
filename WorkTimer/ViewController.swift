//
//  ViewController.swift
//  WorkTimer
//
//  Created by Roman on 06.12.2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Components
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 72)
        button.setImage(UIImage(systemName: "play",withConfiguration: imageConfiguration)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)

        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//        button.backgroundColor = backGroundColor
//        button.titleLabel?.font = .systemFont(ofSize: Metric.buttonsFontSize, weight: .medium)
//
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = Metric.buttonsHeight / 2

        return button
    }()

    private lazy var timeLable: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textColor = .red
        label.font = .systemFont(ofSize: 40, weight: .medium)

        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupView()
    }

    // MARK: - Settings
    private func setupHierarchy() {
        view.addSubview(startButton)
        view.addSubview(timeLable)
    }

    private func setupLayout() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 80).isActive = true

        timeLable.translatesAutoresizingMaskIntoConstraints = false
        timeLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeLable.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20).isActive = true


    }

    private func setupView() {

    }

    // MARK: - Actions

    var isStarded = false

    @objc private func buttonAction() {
        if !isStarded {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 72)
            startButton.setImage(UIImage(systemName: "pause",withConfiguration: imageConfiguration)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
            startStopTimer()
            isStarded = true
        } else {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 72)
            startButton.setImage(UIImage(systemName: "play",withConfiguration: imageConfiguration)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
            startStopTimer()
            isStarded = false
        }
    }

    var timer = Timer()
    private func startStopTimer(){
        if !timer.isValid{
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
        }
    }

    private func rebootTimer(){
        timeLable.text = String(10)
        isStarded = false
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 72)
        startButton.setImage(UIImage(systemName: "play",withConfiguration: imageConfiguration)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
    }

    @objc func UpdateTimer() {
        var counter = Int(timeLable.text ?? "0") ?? 0
        if counter < 1 {
            timer.invalidate()
            rebootTimer()
        } else {
            counter = counter - 1
            timeLable.text = String(counter)
        }
    }

}

// MARK: - Constants

extension ViewController{
    enum Colors {

    }

    enum Metric {

    }

    enum Strings {

    }
}

