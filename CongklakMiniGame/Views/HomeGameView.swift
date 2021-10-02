//
//  HomeGameView.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 02/10/21.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

protocol HomeGameViewDelegate: AnyObject {
    func didHoleTapped(_ index: Int)
    func didDecideTapped()
    func diSelectPlayerTapped(_ player: Player)
    func didRestartTapped()
    func didGameQuestionTapped()
}


class HomeGameView: BaseView {
    
    weak var delegate: HomeGameViewDelegate?
    var gamePlayed = PublishSubject<Bool>()

   
    
    lazy var buttonRestart: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gobackward"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.isEnabled = false
        return button
    }()
    
    lazy var buttonQuestionMark: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    lazy var buttonPlayerToss: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dice"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = UIColor.systemBlue
        return button
    }()
    
    lazy var buttonPlayerOne: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = UIColor.black
        return button
    }()
    
    
    lazy var buttonPlayerTwo: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = UIColor.white
        return button
    }()
    
    lazy var labelPlayerTurn: UILabel = {
        let label = UILabel()
        label.text = "Select who play first"
        label.textAlignment = .center
        return label
    }()
    
    var currentPlayer: Player!
    var gameHoles = [Int]()
    var buttonsHoles = [UIButton]()
    var labels = [UILabel]()
    
    override func setViews() {
        addSubview(labelPlayerTurn)
        addSubview(buttonQuestionMark)
        addSubview(buttonRestart)
        addSubview(buttonPlayerToss)
        addSubview(buttonPlayerOne)
        addSubview(buttonPlayerTwo)
        backgroundColor = UIColor(patternImage: UIImage(named: "wood")!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonQuestionMark.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(35)
            make.height.width.equalTo(getDeviceWidth()*0.040)
        }
        
        buttonRestart.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.right.equalTo(buttonQuestionMark.snp.left).inset(-15)
            make.height.width.equalTo(getDeviceWidth()*0.040)
        }
        
        labelPlayerTurn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        buttonPlayerToss.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(35)
            make.height.width.equalTo(getDeviceWidth()*0.040)
        }
        
        buttonPlayerTwo.snp.makeConstraints { make in
            make.right.equalTo(buttonPlayerToss.snp.left).inset(-10)
            make.centerY.equalTo(buttonPlayerToss)
            make.height.width.equalTo(getDeviceWidth()*0.040)
        }
        
        buttonPlayerOne.snp.makeConstraints { make in
            make.right.equalTo(buttonPlayerTwo.snp.left).inset(-10)
            make.centerY.equalTo(buttonPlayerTwo)
            make.height.width.equalTo(getDeviceWidth()*0.040)
        }
    }
    
    override func onViewDidLoad() {
        generateHoles()
        
        bindAndObserveView()
    }
    
    func bindAndObserveView(){
        buttonQuestionMark
            .rx
            .tap
            .bind(onNext: { [unowned self] in
                delegate?.didGameQuestionTapped()
            }).disposed(by: disposeBag)
        
        buttonRestart
            .rx
            .tap.bind { [unowned self] in
                delegate?.didRestartTapped()
                gamePlayed.onNext(false)
            }.disposed(by: disposeBag)
        
        buttonPlayerToss
            .rx
            .tap.bind { [unowned self] in
                buttonRestart.alpha = 1
                gamePlayed.onNext(true)
                delegate?.didDecideTapped()
            }.disposed(by: disposeBag)
        
        buttonPlayerOne
            .rx
            .tap.bind { [unowned self] in
                buttonRestart.alpha = 1
                gamePlayed.onNext(true)
                delegate?.diSelectPlayerTapped(Player.PlayerBlack)
            }.disposed(by: disposeBag)
        
        buttonPlayerTwo
            .rx
            .tap.bind { [unowned self] in
                buttonRestart.alpha = 1
                gamePlayed.onNext(true)
                delegate?.diSelectPlayerTapped(Player.PlayerWhite)
            }.disposed(by: disposeBag)
        
        
    }
    
    func generateHoles() {
        for i in 0..<gameHoles.count {
            makeGameHomeButton(tag: i)
        }
    }
    
    func lockButton() {
        for button in buttonsHoles {
            button.isEnabled = false
            button.alpha = 0.3
        }
    }
    
    func makeGameHomeButton(tag: Int) {
        
        let holeSize = getDeviceWidth() * 0.075
        let storeHouseSize = getDeviceWidth() * 0.120

        let holeButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = (holeSize)/2
            button.backgroundColor = .black
            button.isEnabled = false
            button.addTarget(self, action: #selector(pickHole), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: getDeviceWidth() * 0.075, height: getDeviceWidth() * 0.08)
            button.alpha = 0.3
            return button
        }()
        
        let player1Y = getDeviceHeight()/2 + 80
        let player1X = getDeviceWidth()/2 - 300
        
        let player2Y = getDeviceHeight()/2 - 80
        let player2X = getDeviceWidth()/2 - 300
        
        let space = CGFloat(75.0)
        
        if tag == 7 {
            holeButton.frame = CGRect(x: 0, y: 0, width: storeHouseSize, height: storeHouseSize)
            holeButton.layer.cornerRadius = storeHouseSize/2
            holeButton.center = CGPoint(x: player1X, y: getDeviceHeight()/2)
        }
        else if tag == 15 {
            holeButton.frame = CGRect(x: 0, y: 0, width: storeHouseSize, height: storeHouseSize)
            holeButton.layer.cornerRadius = storeHouseSize/2
            holeButton.backgroundColor = .white
            holeButton.setTitleColor(.black, for: .normal)
            holeButton.center = CGPoint(x: player2X + 600.0, y: getDeviceHeight()/2)
        }
        if tag < 7 {
            holeButton.center = CGPoint(x: (CGFloat(7-tag)*CGFloat(space) + player1X), y: player1Y)
        }
        else if tag > 7, tag < 15 {
            holeButton.backgroundColor = .white
            holeButton.setTitleColor(.black, for: .normal)
            holeButton.center = CGPoint(x: player2X + CGFloat(tag-7)*space, y: player2Y)
        }
        
        holeButton.setTitle("\(gameHoles[tag])", for: .normal)
        holeButton.tag = tag
        buttonsHoles.append(holeButton)
        
        addSubview(holeButton)
    }
    
    
    @objc func pickHole(sender: UIButton) {
        lockButton()
        delegate?.didHoleTapped(sender.tag)
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HomeGameView_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        HomeGameView().showPreview().previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
    }
}
#endif
