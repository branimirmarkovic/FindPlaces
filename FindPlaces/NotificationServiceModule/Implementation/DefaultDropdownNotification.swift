//
//  DefaultDropdownNotification.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 19.4.22..
//

import UIKit


class DefaultDropdownNotification: DropdownNotification {
    var showTime: TimeInterval = 4

    private var notificationHeight: CGFloat = 60

    private var canShowNotification: Bool = true

    func showNotification(message: String) {
        guard canShowNotification else {return}
        let notificationView = DefaultDropdownNotificationView(message: message)
        configureNotification(notification: notificationView)
        dropDownNotification(notification: notificationView)
        canShowNotification = false
        DispatchQueue.main.asyncAfter(deadline: .now() + showTime) { [weak self] in
            guard let self = self else {return}
            self.retractNotification(notification: notificationView )
            self.canShowNotification = true
        }
    }

    private func configureNotification(notification: DefaultDropdownNotificationView) {
        guard let topWindow =  UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first else {return}
        topWindow.addSubview(notification)
        notification.tapAction = { [weak self] in
            guard let self = self else {return}
            self.retractNotification(notification: notification)
        }
        notification.frame.origin.x = topWindow.frame.origin.x + topWindow.safeAreaInsets.left
        notification.frame.origin.y = topWindow.frame.origin.y + topWindow.safeAreaInsets.top
        notification.frame.size.width = topWindow.frame.width
        notification.frame.size.height = 0


    }

    private func dropDownNotification(notification: DefaultDropdownNotificationView) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .transitionCurlDown) {[weak self] in
            self?.expand(notification)
        }
    }

    private func retractNotification(notification: DefaultDropdownNotificationView) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .transitionCurlUp) {[weak self] in
            self?.retract(notification)
        } completion: { _ in
            notification.removeFromSuperview()
        }
    }

    private func expand(_ notification: DefaultDropdownNotificationView) {
        notification.expand(by: notificationHeight)
        notification.layoutIfNeeded()
        notification.superview?.layoutIfNeeded()
    }

    private func retract(_ notification: DefaultDropdownNotificationView) {
        notification.collapse()
        notification.layoutIfNeeded()
        notification.superview?.layoutIfNeeded()
    }
}


class DefaultDropdownNotificationView: UIView {

    private var message: String
    var tapAction: (() -> Void)? {
        didSet {
            addGestureRecognizer(tapGesture)
            isUserInteractionEnabled = true
        }
    }

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = ThemeProvider.main.backgroundColor
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let symbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = ThemeProvider.main.backgroundColor

        let config = UIImage.SymbolConfiguration(paletteColors: [
            ThemeProvider.main.tintColor,
            ThemeProvider.main.backgroundColor
        ])
        imageView.image = UIImage(systemName: "message.circle.fill", withConfiguration: config)
        return imageView
    }()

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()

    private let tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        return gesture
    }()

    @objc private func viewTapped() {
        tapAction?()
    }

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
        configureLayout()
    }

    private func configureView() {
        self.messageLabel.text = message
        self.backgroundColor = ThemeProvider.main.tintColor
    }

    private func configureLayout() {

        symbolView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            symbolView.widthAnchor.constraint(equalToConstant: 50),
            symbolView.heightAnchor.constraint(equalToConstant: 50)
        ])
        stack.addArrangedSubview(messageLabel)
        stack.addArrangedSubview(UIView.horizontalSpacer())
        stack.addArrangedSubview(symbolView)

        self.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

     func expand(by height: CGFloat) {
        self.frame.size.height = height
    }

     func collapse() {
        self.frame.size.height = 0
        self.stack.removeFromSuperview()
    }
}
