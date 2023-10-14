//
//  Countdown.swift
//  WorkTimer
//
//  Created by Roman on 13.10.2023.
//

import Foundation

class Countdown {
    var hours: Int
    var minutes: Int
    var seconds: Int
    var isRunning: Bool {
        return timer != nil
    }
    private var timer: Timer?

    // Коллбек, который будет вызываться при каждом обновлении
    var onTick: ((String) -> Void)?
    var onCompletion: (() -> Void)?

    init(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    init() {
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
    }

    // Возвращает общее количество секунд
    func totalSeconds() -> Int {
        return seconds + minutes * 60 + hours * 3600
    }

    // Уменьшает счетчик на одну секунду
    private func decrement() {
        if seconds > 0 {
            seconds -= 1
        } else if minutes > 0 {
            minutes -= 1
            seconds = 59
        } else if hours > 0 {
            hours -= 1
            minutes = 59
            seconds = 59
        }
    }

    // Возвращает строковое представление времени
    func timeString() -> String {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Запускает или возобновляет таймер
    func start() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
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
    func reset(hours: Int, minutes: Int, seconds: Int) {
        pause()
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    @objc private func update() {
        decrement()
        onTick?(timeString())

        if totalSeconds() == 0 {
            timer?.invalidate()
            onCompletion?()
        }
    }
}

