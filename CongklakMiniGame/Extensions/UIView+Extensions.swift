//
//  UIView+Extensions.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 01/10/21.
//

import Foundation
import UIKit
import SwiftUI

extension UIView {
    // enable preview for UIKit
    // source: https://dev.to/gualtierofr/preview-uikit-views-in-xcode-3543
    @available(iOS 13, *)
    private struct Preview: UIViewRepresentable {
        typealias UIViewType = UIView
        let view: UIView
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            //
        }
    }
    
    @available(iOS 13, *)
    func showPreview() -> some View {
        // inject self (the current UIView) for the preview
        Preview(view: self)
    }
    
    func width() -> CGFloat {
        return self.frame.width
    }
    
    func height() -> CGFloat {
        return self.frame.height
    }
}
