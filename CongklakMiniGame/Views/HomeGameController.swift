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
            screenView.gameHoles = holes
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        fillHoles()
        super.viewDidLoad()
        screenView.gamePlayed
            .asObservable()
            .subscribe(onNext: { [weak self] isPlayed in
                self?.screenView.buttonPlayerOne.isEnabled = !isPlayed
                self?.screenView.buttonPlayerTwo.isEnabled = !isPlayed
                self?.screenView.buttonPlayerToss.isEnabled = !isPlayed
                self?.screenView.buttonRestart.isEnabled = isPlayed
            }).disposed(by: disposeBag)
        configureViewEvent()
    }
    
    // MARK: - Configuration
    
    func configureViewEvent() {
        screenView.delegate = self
    }
    
    func fillHoles() {
        holes = Array(repeating: 7, count: 16)
        holes[7] = 0
        holes[15] = 0
    }
    
    func pickPlayer() {
        let player1 = Player.PlayerBlack
        let player2 = Player.PlayerWhite
        let players: [Player] = [player1, player2]
        let getPlayer = players.randomElement()
        
        self.screenView.labelPlayerTurn.text = "\(String(describing: getPlayer?.rawValue ?? "")) turn to play"
        screenView.currentPlayer = getPlayer
    }
    
    func pickSelectedPlayer(_ player: Player) {
        self.screenView.labelPlayerTurn.text = "\(player.rawValue) turn to play"
        screenView.currentPlayer = player
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

    }
    
    func didRestartTapped() {

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
