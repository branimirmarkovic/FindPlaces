//
//  NotificationService.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit

protocol NotificationService {
    var spinner: Spinner {get set}
    var dropdownNotification: DropdownNotification {get set}
    func startSpinner()
    func stopSpinner()
    func showDropdownNotification(message: String, on caller: UIViewController)
}

extension NotificationService {
    func startSpinner() {
            self.spinner.startAnimating()
    }
    func stopSpinner() {
            self.spinner.stopAnimating()
    }
    func showDropdownNotification(message: String,on caller: UIViewController) {
        dropdownNotification.showNotification(message: message, caller: caller)
    }

}

class DefaultNotificationService: NotificationService {

    var spinner: Spinner = DefaultSpinner()
    var dropdownNotification: DropdownNotification = DefaultDropdownNotification()

}

protocol Spinner {
    func startAnimating()
    func stopAnimating()
}

class DefaultSpinner: Spinner {

    private var spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        return spinner
    }()

    init () {

    }

    func startAnimating() {
        spinnerView.startAnimating()
    }

    func stopAnimating() {
        spinnerView.stopAnimating()
    }
}

protocol DropdownNotification {
    var showTime: TimeInterval {get set}
    func showNotification(message: String, caller: UIViewController)
}

class DefaultDropdownNotification: DropdownNotification {
    var showTime: TimeInterval = 4

    private var notificationHeight: CGFloat = 60

    func showNotification(message: String, caller: UIViewController) {
        let notificationView = DefaultDropdownNotificationView(message: message)
        configureNotification(caller: caller, notification: notificationView)
        dropDownNotification(notification: notificationView)
        DispatchQueue.main.asyncAfter(deadline: .now() + showTime) { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.retractNotification(notification: notificationView )
        }

    }

    private func configureNotification(caller: UIViewController, notification: DefaultDropdownNotificationView) {

        caller.view.addSubview(notification)
        notification.frame = CGRect(x: 0, y: -notificationHeight, width: caller.view.frame.width, height: notificationHeight)
    }

    private func dropDownNotification(notification: DefaultDropdownNotificationView) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {[weak self] in
            self?.expand(notification)
        }
    }

    private func retractNotification(notification: DefaultDropdownNotificationView) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {[weak self] in
            self?.retract(notification)
        } completion: { _ in
            notification.removeFromSuperview()
        }
    }

    private func retract(_ notification: DefaultDropdownNotificationView) {
        notification.frame.origin.y = -notificationHeight
    }

    private func expand(_ notification: DefaultDropdownNotificationView) {
        notification.frame.origin.y = 0
    }



}

class DefaultDropdownNotificationView: UIView {

    private var message: String

    private var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = ThemeProvider.main.backgroundColor
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private var symbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.tintColor = ThemeProvider.main.backgroundColor

        let config = UIImage.SymbolConfiguration(paletteColors: [
            ThemeProvider.main.tintColor,
            ThemeProvider.main.backgroundColor
        ])
        imageView.image = UIImage(systemName: "message.circle.fill", withConfiguration: config)
        return imageView
    }()

    init(message: String = "") {
        self.message = message
        super.init(frame: .zero)
        onInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func onInit() {
        configureView()
        addSubViews()
        configureLayout()

    }

    private func configureView() {
        self.messageLabel.text = message
        self.backgroundColor = ThemeProvider.main.tintColor
    }

    private func addSubViews() {
        self.addSubview(messageLabel)
        self.addSubview(symbolView)
    }




    private func configureLayout() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: -20),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 20),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            symbolView.topAnchor.constraint(equalTo: self.topAnchor,constant: 20),
            symbolView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            symbolView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            symbolView.widthAnchor.constraint(equalToConstant: 40),
            symbolView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20)


        ])
    }
}



