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
        label.textAlignment = .center
        return label
    }()
    
    lazy var buttonPlayerOneStoreHouse: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.isEnabled = false
        button.layer.cornerRadius = (getDeviceWidth() * 0.120)/2
        button.alpha = 0.3
        return button
    }()
    
    lazy var buttonPlayerTwoStoreHouse: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.isEnabled = false
        button.layer.cornerRadius = (getDeviceWidth() * 0.120)/2
        button.alpha = 0.3
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var stackPlayerOneHole: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    lazy var stackPlayerTwoHole: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    var currentPlayer: Player!
    var gameHoles = [Int]()
    var buttonsHoles = [UIButton](repeating: UIButton(), count: 16)
    var labels = [UILabel]()
    
    override func setViews() {
        addSubview(labelPlayerTurn)
        addSubview(buttonQuestionMark)
        addSubview(buttonRestart)
        addSubview(buttonPlayerToss)
        addSubview(buttonPlayerOne)
        addSubview(buttonPlayerTwo)
        addSubview(stackPlayerOneHole)
        addSubview(stackPlayerTwoHole)
        addSubview(buttonPlayerOneStoreHouse)
        addSubview(buttonPlayerTwoStoreHouse)
        
        buttonPlayerOneStoreHouse.tag = 7
        buttonPlayerTwoStoreHouse.tag = 15
        
        buttonsHoles[buttonPlayerOneStoreHouse.tag] = buttonPlayerOneStoreHouse
        buttonsHoles[buttonPlayerTwoStoreHouse.tag] = buttonPlayerTwoStoreHouse
        
        for playerOneHoleIndex in (0...6).reversed() {
            let buttonPlayerOneHole: UIButton = {
                let button = UIButton()
                button.backgroundColor = .black
                button.isEnabled = false
                button.layer.cornerRadius = (getDeviceWidth() * 0.075)/2
                button.addTarget(self, action: #selector(pickHole), for: .touchUpInside)
                button.alpha = 0.3
                return button
            }()
            
            buttonPlayerOneHole.snp.makeConstraints { make in
                make.width.height.equalTo(getDeviceWidth() * 0.07)
            }
            
            buttonPlayerOneHole.tag = playerOneHoleIndex
            buttonsHoles[buttonPlayerOneHole.tag] = buttonPlayerOneHole
            stackPlayerOneHole.addArrangedSubview(buttonPlayerOneHole)
        }
        
        for playerTwoHoleIndex in 8...14 {
            let buttonPlayerTwoHole: UIButton = {
                let button = UIButton()
                button.backgroundColor = .white
                button.isEnabled = false
                button.setTitleColor(.black, for: .normal)
                button.layer.cornerRadius = (getDeviceWidth() * 0.075)/2
                button.addTarget(self, action: #selector(pickHole), for: .touchUpInside)
                button.alpha = 0.3
                return button
            }()
            
            buttonPlayerTwoHole.snp.makeConstraints { make in
                make.width.height.equalTo(getDeviceWidth() * 0.07)
            }
            buttonPlayerTwoHole.tag = playerTwoHoleIndex
            buttonsHoles[buttonPlayerTwoHole.tag] = buttonPlayerTwoHole
            stackPlayerTwoHole.addArrangedSubview(buttonPlayerTwoHole)
        }
        
        
        
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
        
        buttonPlayerOneStoreHouse.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(getDeviceWidth() * 0.05)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(getDeviceWidth() * 0.120)
        }
        
        stackPlayerOneHole.snp.makeConstraints { make in
            make.left.equalTo(buttonPlayerOneStoreHouse.snp.right).inset(10)
            make.top.equalTo(buttonPlayerOneStoreHouse.snp.bottom).inset(-10)
            make.right.equalTo(buttonPlayerTwoStoreHouse.snp.left).inset(-10)
        }
        
        buttonPlayerTwoStoreHouse.snp.makeConstraints { make in
            make.right.equalToSuperview().inset((getDeviceWidth() * 0.05))
            make.centerY.equalToSuperview()
            make.height.width.equalTo(getDeviceWidth() * 0.120)
        }
        
        stackPlayerTwoHole.snp.makeConstraints { make in
            make.left.equalTo(buttonPlayerOneStoreHouse.snp.right).inset(10)
            make.bottom.equalTo(buttonPlayerTwoStoreHouse.snp.top).inset(-10)
            make.right.equalTo(buttonPlayerTwoStoreHouse.snp.left).inset(-10)
        }
        
    }
    
    override func onViewDidLoad() {        
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
            }.disposed(by: disposeBag)
        
        buttonPlayerToss
            .rx
            .tap.bind { [unowned self] in
                buttonRestart.alpha = 1
                delegate?.didDecideTapped()
            }.disposed(by: disposeBag)
        
        buttonPlayerOne
            .rx
            .tap.bind { [unowned self] in
                buttonRestart.alpha = 1
                delegate?.diSelectPlayerTapped(Player.PlayerBlack)
            }.disposed(by: disposeBag)
        
        buttonPlayerTwo
            .rx
            .tap.bind { [unowned self] in
                buttonRestart.alpha = 1
                delegate?.diSelectPlayerTapped(Player.PlayerWhite)
            }.disposed(by: disposeBag)
        
        
    }
    
    func lockButton() {
        for button in buttonsHoles {
            button.isEnabled = false
            button.alpha = 0.3
        }
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
