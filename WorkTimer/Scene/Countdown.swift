//
//  Countdown.swift
//  WorkTimer
//
//  Created by Roman on 13.10.2023.
//

import Foundation

class Countdown {

    // MARK: - Properties
    private var timer: Timer?
    private var milliseconds: Int

    var hours: Int
    var minutes: Int
    var seconds: Int

    var isRunning: Bool {
        return timer != nil
    }
    // Коллбек, который будет вызываться при каждом обновлении
    var onTick: ((String) -> Void)?
    // Коллбек, который будет вызываться при завершении отсчета
    var onCompletion: (() -> Void)?


    // MARK: - Initializers
    init(hours: Int, minutes: Int, seconds: Int, milliseconds: Int = 0) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.milliseconds = milliseconds
    }

    init() {
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
        self.milliseconds = 0
    }


    // MARK: - Functions Private

    // Уменьшает счетчик на одну секунду
    private func decrement() {
        if milliseconds > 0 {
            milliseconds -= 10
        } else if seconds > 0 {
            seconds -= 1
            milliseconds = 990
        } else if minutes > 0 {
            minutes -= 1
            seconds = 59
            milliseconds = 990
        } else if hours > 0 {
            hours -= 1
            minutes = 59
            seconds = 59
            milliseconds = 990
        }
    }

    @objc private func update() {
        decrement()
        onTick?(timeString())

        if totalSeconds() == 0 && milliseconds == 0 {
            timer?.invalidate()
            onCompletion?()
        }
    }

    // MARK: - Functions Public

    // Возвращает общее количество секунд
    func totalSeconds() -> Int {
        return seconds + minutes * 60 + hours * 3600
    }

    // Возвращает строковое представление времени
    func timeString() -> String {
        let roundedSeconds = milliseconds >= 1 ? seconds + 1 : seconds
        return String(format: "%02d:%02d:%02d", hours, minutes, roundedSeconds)
    }

    // Запускает или возобновляет таймер
    func start() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        } else {
            timer?.fire()
        }
    }

    // Останавливает таймер
    func pause() {
        timer?.invalidate()
        timer = nil
    }

    // Останавливает и сбрасывает таймер
    func reset(hours: Int, minutes: Int, seconds: Int, milliseconds: Int = 0) {
        pause()
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.milliseconds = milliseconds
    }
}

