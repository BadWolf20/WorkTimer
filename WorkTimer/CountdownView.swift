//
//  CountdownView.swift
//  WorkTimer
//
//  Created by Roman on 13.10.2023.
//

import UIKit

class CountdownView: UIView {
    // MARK: - Properties
    private var countdown = Countdown()
    private var isWorkTime = false


    // MARK: - Components
    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: self.center.x,
                                                           y: self.center.y),
                                        radius: self.bounds.width / 2,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 3 * CGFloat.pi / 2,
                                        clockwise: true)
        layer.path = circularPath.cgPath

        layer.strokeColor = UIColor.blue.cgColor
        layer.lineWidth = 3
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.strokeEnd = 0

        return layer
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        handleTap(duration: 0)

        setupHierarchy()
        setupConstraints()
        setupComponents()
        setupText()
    }

    private func setupHierarchy() {
        layer.addSublayer(progressLayer)
        addSubview(timeLabel)
    }

    private func setupComponents() {
        countdown.onTick = { [weak self] timeString in
            self?.timeLabel.text = timeString
        }

        countdown.onCompletion = {
            self.handleTap(duration: 0)
        }


    }

    private func setupText() {

    }

    private func setupConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()

        }
    }

    // MARK: - Update

    private func updateUI() {

    }


    // MARK: - Actions
    func buttonAction() {
        if !countdown.isRunning {
            countdown.start()
            resumeAnimation()
        } else {
            countdown.pause()
            pauseAnimation()
        }
    }


    // MARK: - Functions

    private func handleTap(duration: Int) {
        if isWorkTime {
            countdown.reset(hours: 0, minutes: 0, seconds: 1)
            progressLayer.strokeColor = UIColor.green.cgColor
        } else  {
            countdown.reset(hours: 0, minutes: 0, seconds: 2)
            progressLayer.strokeColor = UIColor.red.cgColor
        }

        isWorkTime.toggle()

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue =  1
        basicAnimation.duration = Double(countdown.totalSeconds())
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        progressLayer.add(basicAnimation, forKey: "urSoBasic")

        pauseAnimation()

        timeLabel.text = countdown.timeString()
    }

    private func resumeAnimation(){
        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 1
        progressLayer.timeOffset = 0
        progressLayer.beginTime = 0
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
      }

    private func pauseAnimation(){
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0
        progressLayer.timeOffset = pausedTime
    }

}
