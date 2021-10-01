//
//  HomeGameViewController.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 01/10/21.
//

import SnapKit
import UIKit

class HomeGameViewController: UIViewController {
    
    lazy var labelPlayerTurn: UILabel = {
        let label = UILabel()
        label.text = "Decide who play first"
        label.textAlignment = .center
        label.center = CGPoint(x: view.width()/2, y: view.height()/2)
        return label
    }()
    
    lazy var buttonRestart: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "gobackward"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    lazy var buttonQuestionMark: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wood")!)
        view.addSubview(labelPlayerTurn)
        view.addSubview(buttonQuestionMark)
        view.addSubview(buttonRestart)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        labelPlayerTurn.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
        
        buttonQuestionMark.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(35)
            make.height.width.equalTo(view.width()*0.05)
        }
        
        buttonRestart.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.right.equalTo(buttonQuestionMark.snp.left).inset(-20)
            make.height.width.equalTo(view.width()*0.05)
        }
        
    }
    
    
    

}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HomeGameViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        HomeGameViewController().showPreview().previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
    }
}
#endif
