//
//  HomeGameViewController.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 01/10/21.
//

import SnapKit
import UIKit

class HomeGameViewController: UIViewController {

    var holes: [Int] = [] //Fill holes
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    var currentPlayer: Player!
    var buttons: [UIButton] = []
    var labels: [UILabel] = []
    var shellsInHand = Int()

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
        generateHoles()
        
    }
    
    override func loadView() {
        super.loadView()
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
    
    
    func generateHoles() {
        for i in 0..<holes.count {
            addButton(tag: i)
        }
    }
    
    func addButton(tag: Int) {
        let holeButton: UIButton = {
            let button = UIButton()
            button.setTitle("39", for: .normal)
            button.layer.cornerRadius = 8
            button.backgroundColor = .systemBlue
            button.isEnabled = false
//            button.addTarget(self, action: #selector(pickHole), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: (50.0).proportionalToHeight(), height: (50.0).proportionalToHeight())
            button.alpha = 0.3
            return button
        }()
        
        let player1Y = deviceHeight/2 + 90
        let player1X = deviceWidth/2 - (300.0).proportionalToWidth()
        
        let player2Y = deviceHeight/2 - 90
        let player2X = deviceWidth/2 - (300.0).proportionalToWidth()
        
        let space = (75.0).proportionalToWidth()
        
        if tag == 7 {
            holeButton.frame = CGRect(x: 0, y: 0, width: (50.0).proportionalToHeight(), height: (100.0).proportionalToHeight())
            holeButton.center = CGPoint(x: player1X, y: deviceHeight/2)
        }
        else if tag == 15 {
            holeButton.frame = CGRect(x: 0, y: 0, width: (50.0).proportionalToHeight(), height: (100.0).proportionalToHeight())
            holeButton.backgroundColor = .systemRed
            holeButton.center = CGPoint(x: player2X + (600.0).proportionalToWidth(), y: deviceHeight/2)
        }
        if tag < 7 {
            holeButton.center = CGPoint(x: (CGFloat(7-tag)*space + player1X), y: player1Y)
        }
        else if tag > 7, tag < 15 {
            holeButton.backgroundColor = .systemRed
            holeButton.center = CGPoint(x: player2X + CGFloat(tag-7)*space, y: player2Y)
        }
        
        holeButton.setTitle("\(holes[tag])", for: .normal)
        holeButton.tag = tag
        buttons.append(holeButton)
        
        view.addSubview(holeButton)
    }
    
    func lockButton() {
        for button in buttons {
            button.isEnabled = false
            button.alpha = 0.3
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
