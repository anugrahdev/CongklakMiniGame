//
//  CongklakGame.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 02/10/21.
//

import UIKit

//extension HomeGameController {
//    
//    //MARK: - Start Playing Logic
//    
//    
//    //MARK: - Start Playing Needed
//    
//    // UNTUK CEK HOLE YANG DIPILIH APAKAH ADA ISINYA(TIDAK KOSONG)
//    func isEmptyHole(index: Int) {
//        if holes[index] == 0 {
//            screenView.labelPlayerTurn.text = "This hole is empty, select another one"
//            unlockButton()
//        }
//    }
//    
//    func holeUIUpdate(index: Int) {
//        if previousIndex != nil {
//            screenView.buttonsHoles[previousIndex].alpha = 0.3
//        }
//        screenView.buttonsHoles[index].alpha = 1
//    }
//    
//    func updateNumberOfShells(index: Int) {
//        if gotTheWinner {
//            for i in 0...15 {
//                screenView.buttonsHoles[i].setTitle("\(holes[i])", for: .normal)
//                if !isGameOver {
//                    screenView.buttonsHoles[i].alpha = 1
//                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                        self.screenView.buttonsHoles[i].alpha = 0.3
//                        self.unlockButton()
//                        self.screenView.labelPlayerTurn.text = "\(self.screenView.currentPlayer.rawValue) turn to play"
//                    }
//                }
//                else {
//                    screenView.buttonsHoles[i].alpha = 1
//                    screenView.buttonPlayerToss.isEnabled = true
//                }
//            }
//            gotTheWinner = false
//        }
//        
//        if seedsInHand == 0, holes[index] == 0, index != 7 && index != 15 {
//            for i in 0...15 {
//                screenView.buttonsHoles[i].setTitle("\(holes[i])", for: .normal)
//            }
//        }
//        else {
//            screenView.buttonsHoles[index].setTitle("\(holes[index])", for: .normal)
//        }
//    }
//    
//    func unlockButton() {
//        if screenView.currentPlayer == .PlayerBlack {
//            for i in 0...7 {
//                if i<7 {
//                    screenView.buttonsHoles[i].isEnabled = true
//                }
//                screenView.buttonsHoles[i].alpha = 1
//            }
//        }
//        else {
//            for i in 8...15 {
//                if i<15 {
//                    screenView.buttonsHoles[i].isEnabled = true
//                }
//                screenView.buttonsHoles[i].alpha = 1
//            }
//        }
//        // PLAYER CAN'T TAKE THE SHEELLS FROM NGACANG HOLES
//        if isNgacang {
//            for i in ngacangs {
//                screenView.buttonsHoles[i].isEnabled = false
//            }
//        }
//    }
//    
//    //MARK: - Restart The Game
//    
//    func restart() {
//        //MARK: Stop Game
//        seedsInHand = 0
//        
//        //MARK: Non-Aktifkan Restart Button
//        screenView.buttonRestart.alpha = 0.3
//        screenView.gamePlayed.onNext(false)
//        
//        //MARK: Aktifkan Decide Button
//        screenView.buttonPlayerToss.alpha = 1
//        screenView.gamePlayed.onNext(true)
//        
//        
//        //MARK: Update Shells And Holes
//        fillHoles()
//        for i in 0...15 {
//            screenView.buttonsHoles[i].isEnabled = false
//            screenView.buttonsHoles[i].alpha = 0.3
//            screenView.buttonsHoles[i].setTitle("\(holes[i])", for: .normal)
//            if i <= 7 {
//                screenView.buttonsHoles[i].setTitleColor(.white, for: .normal)
//                screenView.buttonsHoles[i].backgroundColor = .black
//            }
//            else {
//                screenView.buttonsHoles[i].setTitleColor(.black, for: .normal)
//                screenView.buttonsHoles[i].backgroundColor = .white
//            }
//        }
//        
//        //MARK: Update Text Label
//        screenView.labelPlayerTurn.text = "Select who play first"
//        
//        //MARK: Restart Properties
//        totalSteps = 0
//        gotTheWinner = false
//        isNgacang = false
//        isGameOver = false
//        ngacangs = []
//        
//    }
//    
//}
