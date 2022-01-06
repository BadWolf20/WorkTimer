//
//  ViewController.swift
//  WorkTimer
//
//  Created by Roman on 06.12.2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Components
    private lazy var startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(getImage(name: "play"), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        return button
    }()

    private lazy var timeLable: UILabel = {
        let label = UILabel()
        label.text = workClock.getTime()
        label.textColor = buttonColor
        label.font = .systemFont(ofSize: Metric.timeLableFontSize, weight: .medium)

        return label
    }()

    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: Metric.progressCenterX,
                                                           y: Metric.progressCenterY),
                                        radius: Metric.progressRadius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 3 * CGFloat.pi / 2,
                                        clockwise: true)
        layer.path = circularPath.cgPath

        layer.strokeColor = Colors.workColor.cgColor
        layer.lineWidth = Metric.progressLineWidth
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.strokeEnd = 0

        return layer
    }()

    private lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: Metric.progressCenterX,
                                                           y: Metric.progressCenterY),
                                        radius: Metric.progressRadius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 3 * CGFloat.pi / 2,
                                        clockwise: true)
        layer.path = circularPath.cgPath

        layer.strokeColor = Colors.trackShadeColor
        layer.lineWidth = Metric.progressLineWidth
        layer.fillColor = UIColor.clear.cgColor

        return layer
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        workClock.setTime(minutes: Metric.timeWorkMinutes, seconds: Metric.timeWorkSeconds)
        handleTap(duration: workClock.getSeconds())

        setupHierarchy()
        setupLayout()
        setupView()
    }

    // MARK: - Settings
    private func setupHierarchy() {
        view.addSubview(startStopButton)
        view.addSubview(timeLable)
        startStopButton.layer.addSublayer(trackLayer)
        startStopButton.layer.addSublayer(progressLayer)

    }

    private func setupLayout() {
        timeLable.translatesAutoresizingMaskIntoConstraints = false
        timeLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.timeLableIndentTop).isActive = true

        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.topAnchor.constraint(equalTo: timeLable.bottomAnchor, constant: Metric.startStopButtonIndentTop).isActive = true
        startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startStopButton.widthAnchor.constraint(equalToConstant: Metric.startStopButtonWidth).isActive = true
        startStopButton.heightAnchor.constraint(equalToConstant: Metric.startStopButtonHeight).isActive = true
    }

    private func setupView() {

    }

    // MARK: - Actions
    var isWorkTime = true
    var isStarded = false
    var workClock = clock()
    var buttonColor: UIColor = Colors.workColor
    var timer = Timer()


    @objc private func buttonAction() {
        if !isStarded {
            startStopButton.setImage(getImage(name: "pause"), for: .normal)
            startStopTimer()
            resumeAnimation()
            isStarded = true
        } else {
            startStopButton.setImage(getImage(name: "play"), for: .normal)
            startStopTimer()
            pauseAnimation()
            isStarded = false
        }
    }

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

        startStopButton.setImage(getImage(name: "play"), for: .normal)
        timeLable.textColor = buttonColor
    }

    @objc func UpdateTimer() {
        workClock.minusSec()
        timeLable.text = workClock.getTime()
        if workClock.getTime() == "00:00:00" {
            timer.invalidate()
            rebootTimer()
        }
    }

    private func changeClock(){
        if isWorkTime {
            isWorkTime = false
            buttonColor = Colors.restColor
            workClock.setTime(minutes: Metric.timeRestMinutes, seconds: Metric.timeRestSeconds)
            handleTap(duration: workClock.getSeconds())
            progressLayer.strokeColor = Colors.restColor.cgColor
        } else  {
            isWorkTime = true
            buttonColor = Colors.workColor
            workClock.setTime(minutes: Metric.timeWorkMinutes, seconds: Metric.timeWorkSeconds)
            handleTap(duration: workClock.getSeconds())
            progressLayer.strokeColor = Colors.workColor.cgColor
        }
    }

    func getImage(name: String) -> UIImage{
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: Metric.startStopImageSize)
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
        static let workColor: UIColor = .systemRed
        static let restColor: UIColor = .systemGreen
        static let trackShadeColor: CGColor = UIColor.systemGray5.cgColor
    }

    enum Metric {
        static let timeLableFontSize: CGFloat = 40
        static let timeLableIndentTop: CGFloat = 220
        static let startStopButtonHeight: CGFloat = 80
        static let startStopButtonWidth: CGFloat = 80
        static let startStopImageSize: CGFloat = 72
        static let startStopButtonIndentTop: CGFloat = 30
        static let progressRadius: CGFloat = 150
        static let progressLineWidth: CGFloat = 3
        static let progressCenterX: CGFloat = Metric.startStopButtonWidth / 2
        static let progressCenterY: CGFloat = Metric.startStopButtonHeight / 2 - 40
        static let timeWorkMinutes: Int = 1
        static let timeWorkSeconds: Int = 0
        static let timeRestMinutes: Int = 0
        static let timeRestSeconds: Int = 30

    }

    enum Strings {

    }
}

//MARK: - Progress bar functions
extension ViewController{
    private func handleTap(duration: Int) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue =  1
        basicAnimation.duration = Double(duration)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false

        progressLayer.add(basicAnimation, forKey: "urSoBasic")
        pauseAnimation()
    }

    func resumeAnimation(){
        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 1
        progressLayer.timeOffset = 0
        progressLayer.beginTime = 0
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
      }

    func pauseAnimation(){
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0
        progressLayer.timeOffset = pausedTime
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

    func getSeconds() -> Int {
        let ms = minute * 60
        let hs = hour * 60 * 60
        return second + ms + hs
    }

}
