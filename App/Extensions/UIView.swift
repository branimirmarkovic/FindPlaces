//
//  UIView.swift
//  App
//
//  Created by Branimir Markovic on 2.1.22..
//

import UIKit


extension UIView {

    static func horizontalSpacer() -> UIView {
        let spacer = UIView()
         spacer.isUserInteractionEnabled = false
         spacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
         spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        return spacer
    }
}
