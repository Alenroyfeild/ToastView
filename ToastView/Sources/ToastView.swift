//
//  ToastView.swift
//  ToastView
//
//  Created by BalajiRoyal on 06/11/23.
//

import UIKit

class ToastView {
    private struct Task {
        let message: String
        let uiView: UIView
        let position: Position
        let autoHide: Bool
        let mode: Mode
        let animationTime: TimeInterval
        let hapticType: UINotificationFeedbackGenerator.FeedbackType?
    }
    
    enum Mode {
        case showProgress, showPrefixImage(image: UIImage)
    }
    
    enum type {
        case shared, isolated
    }
    
    enum Position: String, CaseIterable {
        case belowTopAnchor, aboveTopAnchor, aboveBottomAnchor, aboveCenter
    }
    
    var position: Position = .aboveBottomAnchor
    
    lazy var appleToastView: AppleToastView = {
        let appleToastView = AppleToastView(child: MessageView())
        appleToastView.transform = initialTransform
        appleToastView.alpha = 0
        return appleToastView
    }()
    
    private var isToastVisible: Bool = false

    private var initialTransform: CGAffineTransform {
        CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: 24)
    }
   
    static let shared = ToastView()
    private var taskQueue: [Task] = []
    private var isTaskRunning = false
    private var isSharedToastVisible = false // Track if a shared toast is currently visible
    
    /// Shows the toast message with haptic feedback
    func showToast(message: String, on uiView: UIView, position: Position = .aboveTopAnchor, autoHide: Bool = false, mode: Mode = .showProgress, animationTime: TimeInterval = 0.25, haptic type: UINotificationFeedbackGenerator.FeedbackType?) {
        showToast(message: message, on: uiView, position: position, autoHide: autoHide, mode: mode, animationTime: animationTime, haptic: type, completion: { })
    }

    private func showToast(message: String, on uiView: UIView, position: Position = .aboveTopAnchor, autoHide: Bool = false, mode: Mode = .showProgress, animationTime: TimeInterval = 0.25, haptic type: UINotificationFeedbackGenerator.FeedbackType?, completion: @escaping () -> Void) {
        if self === Self.shared {
            showSharedToast(message: message, on: uiView, position: position, autoHide: autoHide, mode: mode, animationTime: animationTime, hapticType: type)
        } else {
            if let type {
                UINotificationFeedbackGenerator().notificationOccurred(type)
            }
            showToast(message: message, on: uiView, position: position, autoHide: autoHide, mode: mode, animationTime: animationTime, completion: completion)
        }
    }

    private func showToast(message: String, on uiView: UIView, position place: Position = .aboveTopAnchor, autoHide: Bool = false, mode: Mode = .showProgress, animationTime: TimeInterval = 0.25, completion: @escaping () -> Void) {
        uiView.addSubview(appleToastView)
        position = place
        appleToastView.child.title = message
        appleToastView.setUpViewConstraints(position: place)
        if place == .aboveTopAnchor {
            uiView.clipsToBounds = false
        }
        
        switch mode {
        case .showProgress:
            appleToastView.child.startSyncAnimation()
        case .showPrefixImage(let image):
            appleToastView.child.showPrefixImage(image: image)
        }

        UIView.animate(withDuration: animationTime, delay: 0, options: .curveEaseOut) { [weak self] in
            guard let self else { return }
            self.appleToastView.transform = getInitialTransform(position: place)
            self.appleToastView.alpha = 1
            if autoHide {
                DispatchQueue.main.asyncAfter(deadline: .now() + getCloseDuration()) {
                    self.closeToast(isForced: false, completion: completion)
                }
            } else {
                completion()
            }
        }
    }
    
    private func getCloseDuration() -> CGFloat {
        if self === Self.shared {
            if taskQueue.isEmpty {
                return 2
            }
            return 0.5
        }
        return 2
    }
    
    private func getInitialTransform(position: Position) -> CGAffineTransform {
        switch position {
        case .belowTopAnchor:
            return CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 24)
        default:
            return .identity
        }
    }
    
    private func getFinalTransForm(position: Position) -> CGAffineTransform {
        switch position {
        case .belowTopAnchor:
            return CGAffineTransform(scaleX: 0.9, y: 0.9)
        default:
            return initialTransform
        }
    }
    
    private func closeToast(isForced: Bool = true, completion: @escaping () -> Void) {
        let duration = isForced ? 0.05 : 0.25
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
            self.appleToastView.transform = self.getFinalTransForm(position: self.position)
            self.appleToastView.alpha = 0
        } completion: { _ in
            self.appleToastView.child.stopSyncAnimation()
            self.appleToastView.removeFromSuperview()
            completion()
        }
    }
    
    private func showSharedToast(message: String, on uiView: UIView, position: Position = .aboveTopAnchor, autoHide: Bool = false, mode: Mode = .showProgress, animationTime: TimeInterval, hapticType: UINotificationFeedbackGenerator.FeedbackType?) {
        let task = Task(message: message, uiView: uiView, position: position, autoHide: autoHide, mode: mode, animationTime: animationTime, hapticType: hapticType)
        taskQueue.append(task)
        
        if !isTaskRunning {
            // If no task is currently running, start executing the next task.
            executeNextTask()
        } else {
            // If a shared toast is currently visible, close it and show the next.
            closeAndShowSharedToast()
        }
    }
    
    func closeToast() {
        if self === Self.shared {
            taskQueue.removeAll()
            closeToast(completion: { })
        } else {
            closeToast(completion: { })
        }
    }
    
    private func closeAndShowSharedToast() {
        closeToast(completion: {
            self.executeNextTask()
        })
    }
    
    private func executeNextTask() {
        guard !taskQueue.isEmpty else {
            // No tasks in the queue, mark task execution as finished.
            isTaskRunning = false
            return
        }
        
        isTaskRunning = true
        let task = taskQueue.removeFirst()
        
        if let type = task.hapticType {
            UINotificationFeedbackGenerator().notificationOccurred(type)
        }
        
        showToast(message: task.message, on: task.uiView, position: task.position, autoHide: task.autoHide, mode: task.mode, animationTime: task.animationTime) { [weak self] in
            // After showing the toast, execute the next task in the queue.
            self?.executeNextTask()
        }
    }
}
