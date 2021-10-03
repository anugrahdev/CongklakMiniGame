//
//  HomeGameViewController.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 01/10/21.
//

import SnapKit
import UIKit
import RxCocoa
import RxSwift

class HomeGameController: BaseViewController<HomeGameView> {
    
    var gamePlayed = BehaviorSubject<Bool>(value: false)
    
    var holes: [Int] = [] {
        didSet {
            contentView.gameHoles = holes
        }
    }
    
    var seedsInHand = Int()
    var timer: Timer?
    var previousIndex: Int!
    var totalSteps = 0
    var ngacangs = [Int]()
    var ngacangPlayer: Player!
    
    var gotTheWinner = false
    var isNgacang = false
    var isGameOver = false
    
    override func viewDidLoad() {
        fillHoles()
        super.viewDidLoad()
        
        self.gamePlayed
            .asObservable()
            .subscribe(onNext: { [weak self] isPlayed in
                self?.contentView.buttonPlayerOne.isEnabled = !isPlayed
                self?.contentView.buttonPlayerTwo.isEnabled = !isPlayed
                self?.contentView.buttonPlayerToss.isEnabled = !isPlayed
                self?.contentView.buttonRestart.isEnabled = isPlayed
                if !isPlayed {
                    self?.contentView.labelPlayerTurn.text = "Select who play first"
                }
            }).disposed(by: disposeBag)
        
        for i in 0...15 {
            contentView.buttonsHoles[i].setTitle("\(holes[i])", for: .normal)
        }
        
        contentView.delegate = self
    }
    
    func fillHoles() {
        holes = [Int]()
        for i in 0...15 {
            if i == 7 || i == 15{
                holes.append(0)
            } else {
                holes.append(7)
            }
        }
    }
    
    func pickPlayer() {

        let getPlayer = [Player.PlayerBlack, Player.PlayerWhite].randomElement()
        
        self.contentView.labelPlayerTurn.text = "\(String(describing: getPlayer?.rawValue ?? "")) turn to play"
        contentView.currentPlayer = getPlayer
        self.gamePlayed.onNext(true)
        unlockButton()
    }
    
    func pickSelectedPlayer(_ player: Player) {
        self.contentView.labelPlayerTurn.text = "\(player.rawValue) turn to play"
        contentView.currentPlayer = player
        unlockButton()
        self.gamePlayed.onNext(true)
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
            for i in 0...6 {
                if i < 7 {
                    contentView.buttonsHoles[i].isEnabled = true
                }
                contentView.buttonsHoles[i].alpha = 1
            }
        } else {
            for i in 8...14 {
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
    
    func startPlaying(pickedHole: Int) {
        var i = pickedHole
        
        isEmptyHole(index: i)
        seedsInHand = holes[i]
        holes[i] = 0
        contentView.buttonsHoles[i].setTitle("\(holes[i])", for: .normal)
        i += 1
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] timer in
            if seedsInHand > 0 {
                totalSteps += 1
                
                contentView.labelPlayerTurn.text = "Seeds in hands: \(seedsInHand-1)"
                
                i = skipNgacang(index: i)

                if i > holes.count-1 {
                    i = 0
                }
                
                i = skipOpponentStoreHouse(index: i)
                
                holeUIUpdate(index: i)
                
                if seedsInHand == 1 {
                    isLastSeed(index: i)
                } else {
                    holes[i] += 1
                    seedsInHand -= 1
                }
                
                updateNumberOfSeeds(index: i)
                previousIndex = i
                i += 1
            } else {
                timer.invalidate()
            }
        })
    }
    
    
    func restart() {
        seedsInHand = 0
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
                
        totalSteps = 0
        gotTheWinner = false
        isNgacang = false
        isGameOver = false
        ngacangs = []
        self.gamePlayed.onNext(false)
        
    }
    
    
}

extension HomeGameController: HomeGameViewDelegate {
    func diSelectPlayerTapped(_ player: Player) {
        self.pickSelectedPlayer(player)
        gamePlayed.onNext(true)
    }
    
    func didGameQuestionTapped() {
        let vc = GameInstructionController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func didHoleTapped(_ index: Int) {
        startPlaying(pickedHole: index)
    }
    
    func didDecideTapped() {
        if !self.isGameOver {
            self.pickPlayer()
        } else {
            self.restart()
            self.contentView.labelPlayerTurn.text = "\(self.contentView.currentPlayer.rawValue) turn"
            self.unlockButton()
            self.gamePlayed.onNext(true)
        }
        gamePlayed.onNext(true)
    }
    
    func didRestartTapped() {
        self.restart()
        gamePlayed.onNext(false)
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
