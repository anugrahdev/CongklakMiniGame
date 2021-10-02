//
//  BaseView.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 02/10/21.
//

import UIKit
import RxSwift

class BaseView: UIView {
    
    public var disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {}
    func onViewDidLoad() {}
    func onViewWillAppear() {}
    func onViewDidAppear() {}
    func onViewWillDisAppear() {}
    func onViewDidDisAppear() {}
    func onViewWillLayoutSubViews() {}
    func onViewDidLayoutSubViews() {}
    static let getDeviceWidth = UIScreen.main.bounds.width
    static let getDeviceHeight = UIScreen.main.bounds.height
    
    func getDeviceWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getDeviceHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
