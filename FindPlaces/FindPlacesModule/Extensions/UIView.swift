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

import SwiftUI

struct ViewPreview: UIViewRepresentable {
    let viewBuilder: () -> UIView

    init(_ viewBuilder: @escaping () -> UIView) {
        self.viewBuilder = viewBuilder
    }

    func makeUIView(context: Context) -> some UIView {
        viewBuilder()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Not needed
    }
}
