//
//  HomeGameViewController.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 01/10/21.
//

import SnapKit
import UIKit

class HomeGameController: BaseViewController<HomeGameView> {
    
    var seedsInHand = Int()
    var timer: Timer?
    var previousIndex: Int!
    var totalSteps = 0
    var gotTheWinner = false
    var isNgacang = false
    var isGameOver = false
    var ngacangs = [Int]()
    var ngacangPlayer: Player!
    
    var holes: [Int] = [] {
        didSet {
            contentView.gameHoles = holes
        }
    }
    
    override func viewDidLoad() {
        fillHoles()
        super.viewDidLoad()
        
        contentView.gamePlayed
            .asObservable()
            .subscribe(onNext: { [weak self] isPlayed in
                self?.contentView.buttonPlayerOne.isEnabled = !isPlayed
                self?.contentView.buttonPlayerTwo.isEnabled = !isPlayed
                self?.contentView.buttonPlayerToss.isEnabled = !isPlayed
                self?.contentView.buttonRestart.isEnabled = isPlayed
            }).disposed(by: disposeBag)
        
        for i in 0...15 {
            contentView.buttonsHoles[i].setTitle("\(holes[i])", for: .normal)
        }
        
        contentView.delegate = self
    }
    
    func fillHoles() {
        holes = Array(repeating: 7, count: 16)
        holes[7] = 0
        holes[15] = 0
    }
    
    func pickPlayer() {

        let players = [Player.PlayerBlack, Player.PlayerWhite]
        let getPlayer = players.randomElement()
        
        self.contentView.labelPlayerTurn.text = "\(String(describing: getPlayer?.rawValue ?? "")) turn to play"
        contentView.currentPlayer = getPlayer
        self.contentView.gamePlayed.onNext(true)
    }
    
    func pickSelectedPlayer(_ player: Player) {
        self.contentView.labelPlayerTurn.text = "\(player.rawValue) turn to play"
        contentView.currentPlayer = player
    }
    
    func isEmptyHole(index: Int) {
        if holes[index] == 0 {
            contentView.labelPlayerTurn.text = "This hole is empty, select another one"
            unlockButton()
        }
    }
    
    func holeUIUpdate(index: Int) {
        if previousIndex != nil {
            contentView.buttonsHoles[previousIndex].alpha = 0.3
        }
        contentView.buttonsHoles[index].alpha = 1
    }
    
    func updateNumberOfSeeds(index: Int) {
        if gotTheWinner {
            for i in 0...15 {
                contentView.buttonsHoles[i].setTitle("\(holes[i])", for: .normal)
                if !isGameOver {
                    contentView.buttonsHoles[i].alpha = 1
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.contentView.buttonsHoles[i].alpha = 0.3
                        self.unlockButton()
                        self.contentView.labelPlayerTurn.text = "\(self.contentView.currentPlayer.rawValue) turn to play"
                    }
                } else {
                    contentView.buttonsHoles[i].alpha = 1
                    contentView.buttonPlayerToss.isEnabled = true
                }
            }
            gotTheWinner = false
        }
        
        if seedsInHand == 0, holes[index] == 0, index != 7 && index != 15 {
            for i in 0...15 {
                contentView.buttonsHoles[i].setTitle("\(holes[i])", for: .normal)
            }
        } else {
            contentView.buttonsHoles[index].setTitle("\(holes[index])", for: .normal)
        }
    }
    
    func unlockButton() {
        if contentView.currentPlayer == .PlayerBlack {
            for i in 0...7 {
                if i<7 {
                    contentView.buttonsHoles[i].isEnabled = true
                }
                contentView.buttonsHoles[i].alpha = 1
            }
        } else {
            for i in 8...15 {
                if i<15 {
                    contentView.buttonsHoles[i].isEnabled = true
                }
                contentView.buttonsHoles[i].alpha = 1
            }
        }
        
        if isNgacang {
            for i in ngacangs {
                contentView.buttonsHoles[i].isEnabled = false
            }
        }
    }
    
    
    func restart() {
        seedsInHand = 0
        
        contentView.buttonRestart.alpha = 0.3
        contentView.gamePlayed.onNext(false)
        
        contentView.buttonPlayerToss.alpha = 1
        contentView.gamePlayed.onNext(true)
        
        
        fillHoles()
        for i in 0...15 {
            contentView.buttonsHoles[i].isEnabled = false
            contentView.buttonsHoles[i].alpha = 0.3
            contentView.buttonsHoles[i].setTitle("\(holes[i])", for: .normal)
            if i <= 7 {
                contentView.buttonsHoles[i].setTitleColor(.white, for: .normal)
                contentView.buttonsHoles[i].backgroundColor = .black
            } else {
                contentView.buttonsHoles[i].setTitleColor(.black, for: .normal)
                contentView.buttonsHoles[i].backgroundColor = .white
            }
        }
        
        contentView.labelPlayerTurn.text = "Select who play first"
        
        totalSteps = 0
        gotTheWinner = false
        isNgacang = false
        isGameOver = false
        ngacangs = []
        self.contentView.gamePlayed.onNext(true)
        
    }
    
    
}

extension HomeGameController: HomeGameViewDelegate {
    func diSelectPlayerTapped(_ player: Player) {
        self.pickSelectedPlayer(player)
    }
    
    func didGameQuestionTapped() {
        let vc = GameInstructionController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func didHoleTapped(_ index: Int) {

    }
    
    func didDecideTapped() {
        if !self.isGameOver {
            self.pickPlayer()
        } else {
            self.restart()
            self.contentView.labelPlayerTurn.text = "\(self.contentView.currentPlayer.rawValue) turn"
            self.unlockButton()
            self.contentView.gamePlayed.onNext(true)
        }
    }
    
    func didRestartTapped() {
        self.restart()
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HomeGameViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        HomeGameController().showPreview().previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
    }
}
#endif
