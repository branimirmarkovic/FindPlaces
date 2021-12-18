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
    func showDropdownNotification(message: String, caller: UIViewController)
}

extension NotificationService {
    func startSpinner() {
        self.spinner.startAnimating()
    }
    func stopSpinner() {
        self.spinner.stopAnimating()
    }
    func showDropdownNotification(message: String,caller: UIViewController) {
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
        notification.frame = CGRect(x: 0, y: 0, width: caller.view.frame.width, height: 0)
    }

    private func dropDownNotification(notification: DefaultDropdownNotificationView) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            notification.expand()
        }


    }

    private func retractNotification(notification: DefaultDropdownNotificationView) {
        UIView.animate(withDuration: 1) {
            notification.removeFromSuperview()
        }


    }
}

class DefaultDropdownNotificationView: UIView {

    var message: String

    private var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = ThemeProvider.main.backgroundColor
        return label
    }()

    private var symbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = ThemeProvider.main.backgroundColor
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


    func retract() {
        self.frame.size.height = 0
        self.layoutIfNeeded()
    }

    func expand() {
        self.frame.size.height = 60
        self.layoutIfNeeded()
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
        self.insetsLayoutMarginsFromSafeArea = true
        //        self.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            symbolView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            symbolView.widthAnchor.constraint(equalToConstant: 40),
            symbolView.topAnchor.constraint(equalTo: self.topAnchor,constant: 20),
            symbolView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            symbolView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: -20)

        ])
    }
}



