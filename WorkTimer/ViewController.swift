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
        button.setImage(getImage(name: "play"), for: .normal)

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
        label.text = workClock.getTime()
        label.textColor = buttonColor
        label.font = .systemFont(ofSize: 40, weight: .medium)

        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        workClock.setTime(minutes: 0, seconds: 3)

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
    var isWorkTime = true
    var isStarded = false
    var workClock = clock()
    var buttonColor: UIColor = .systemRed
    let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 72)

    @objc private func buttonAction() {
        if !isStarded {

            startButton.setImage(getImage(name: "pause"), for: .normal)
            startStopTimer()
            isStarded = true
        } else {

            startButton.setImage(getImage(name: "play"), for: .normal)
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

        changeClock()
        timeLable.text = workClock.getTime()

        isStarded = false

        startButton.setImage(getImage(name: "play"), for: .normal)
        timeLable.textColor = buttonColor
    }

    @objc func UpdateTimer() {
        if workClock.getTime() == "00:00:00" {
            timer.invalidate()
            rebootTimer()
        } else {
            workClock.minusSec()
            timeLable.text = workClock.getTime()
        }
    }

    private func changeClock(){
        if isWorkTime {
            isWorkTime = false
            buttonColor = .systemGreen
            workClock.setTime(minutes: 0, seconds: 10)
        } else  {
            isWorkTime = true
            buttonColor = .systemRed
            workClock.setTime(minutes: 0, seconds: 5)
        }
    }

    func getImage(name: String) -> UIImage{
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 72)
        var image: UIImage
        switch name {
            case "play":
                image =  UIImage(systemName: "play",withConfiguration: imageConfiguration)!
            case "pause":
                image =  UIImage(systemName: "pause",withConfiguration: imageConfiguration)!
            default:
                image =  UIImage(systemName: "xmark.octagon",withConfiguration: imageConfiguration)!
        }
        return image.withTintColor(buttonColor, renderingMode: .alwaysOriginal)
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

struct clock {
    private var second = 0
    private var minute = 0
    private var hour = 0

    mutating func setTime(hours: Int, minutes: Int, seconds: Int) {
        second = seconds
        minute = minutes
        hour = hours
    }

    mutating func setTime(minutes: Int, seconds: Int) {
        minute = minutes
        second = seconds
    }

    mutating func minusSec() {
        if second == 0 {
            if minute == 0 {
                if hour == 0 {
                    return
                }
                minute = 60
                hour = hour - 1
            }
            second = 59
            minute = minute - 1
        } else {
            second = second - 1
        }
    }

    func getTime() -> String {
        var out: String = ""

        for number in [hour, minute, second] {
            if number < 10 {
                out += String(0) + String(number) + ":"
            } else {
                out += String(number) + ":"
            }
        }
        out.removeLast()
        return out
    }

}
