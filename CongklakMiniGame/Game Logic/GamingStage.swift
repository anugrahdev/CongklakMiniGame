//
//  GamingStage.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 02/10/21.
//

import UIKit

extension HomeGameController {
    
    func skipOpponentStoreHouse(index: Int) -> Int {
        var i: Int = index
        
        if i == 15 && contentView.currentPlayer != .PlayerWhite {
            i = 0
            return i
        } else if i == 7 && contentView.currentPlayer != .PlayerBlack {
            i += 1
            return i
        } else {
            return index
        }
    }
    
    
    func isLastSeed(index: Int) {

        if (index == 7 && contentView.currentPlayer == .PlayerBlack) || (index == 15 && contentView.currentPlayer == .PlayerWhite){
            seedsInHand = seedsInHand - 1
            holes[index] = holes[index] + 1
            totalSteps = 0
            contentView.labelPlayerTurn.text = "Seeds in hands : \(seedsInHand)"
            if !isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                    self.contentView.labelPlayerTurn.text = "\(self.contentView.currentPlayer.rawValue) turn"
                }
                updateNumberOfSeeds(index: index)
                unlockButton()
            }
            timer?.invalidate()
            
        } else if index != 7 && index != 15 {
            if holes[index] != 0 {
                if isNgacang {
                    if !ngacangs.contains(index) {
                        seedsInHand = holes[index]+1
                        holes[index] = 0
                    } else {
                        seedsInHand = seedsInHand - 1
                        holes[index] = holes[index] + 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                            self.unlockButton()
                            self.switchPlayerTurn()
                        }
                    }
                } else {
                    seedsInHand = holes[index]+1
                    holes[index] = 0
                }
            } else {
                seedsInHand = seedsInHand - 1
                holes[index] = holes[index] + 1
                shot(index: index)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    self.unlockButton()
                    self.switchPlayerTurn()
                }
                timer?.invalidate()
            }
        }
        
    }
    
    func skipNgacang(index: Int) -> Int {
        var index: Int = index
        if contentView.currentPlayer == ngacangPlayer {
            if isNgacang {
                for i in ngacangs {
                    if contentView.currentPlayer == .PlayerWhite && index == 16 {
                        index =  0
                    }else if index == i {
                        index += 1
                    }
                }
            }
        }
        return index
    }
    
    func switchPlayerTurn() {
        if contentView.currentPlayer == .PlayerBlack {
            contentView.currentPlayer = .PlayerWhite
        } else if contentView.currentPlayer == .PlayerWhite {
            contentView.currentPlayer = .PlayerBlack
        }
        totalSteps = 0
        contentView.lockButton()
        contentView.labelPlayerTurn.text = "\(contentView.currentPlayer.rawValue) turn"
    }
    
    func shot(index: Int) {
        let not = (!)
        if totalSteps >= 15 {
            let oppositeIndex = 14 - index
            if isNgacang {
                if not(ngacangs.contains(oppositeIndex)), holes[oppositeIndex] != 0 {
                    updateAfterShot(index: index, oppositeIndex: oppositeIndex)
                }
            } else if holes[oppositeIndex] != 0 {
                    updateAfterShot(index: index, oppositeIndex: oppositeIndex)
                
            }
            updateNumberOfSeeds(index: index)
        }
    }
    
    func updateAfterShot(index: Int, oppositeIndex: Int) {
        if contentView.currentPlayer == .PlayerBlack {
            holes[7] += holes[oppositeIndex]+1
            holes[index] = 0
            holes[oppositeIndex] = 0
            contentView.buttonsHoles[oppositeIndex].alpha = 1
            contentView.buttonsHoles[7].alpha = 1
        }  else {
            holes[15] += holes[oppositeIndex]+1
            holes[index] = 0
            holes[oppositeIndex] = 0
            
            contentView.buttonsHoles[oppositeIndex].alpha = 1
            contentView.buttonsHoles[15].alpha = 1
        }
    }
    
    func isAnyRemainingSeeds(storeHouse: Int, smallestIndex: Int) {
        var leftover = 0
        var ngacang = 0
        var numberOfOpponentSeeds = 0
        var remainingSeeds = 0
        
        if holes[storeHouse] > 49 {
            leftover = holes[storeHouse] - 49
            for i in smallestIndex..<storeHouse {
                holes[i] = 7
                holes[storeHouse] = leftover
                print(holes)
            }
            numberOfOpponentSeeds = 49 - leftover
            ngacang = 7 - numberOfOpponentSeeds/7
            
            if ngacang <= 3 {
                if numberOfOpponentSeeds % 7 != 0 {
                    remainingSeeds = leftover % 7
                    // fill loser congklak hole
                } else {
                    ngacang += 1
                    if ngacang > 3 {
                        // game over :(
                        // fill loser congklak hole
                    } else {
                        remainingSeeds = 7
                        // fill loser congklak hole
                    }
                }
            } else {
                // game over :(
                // fill loser congklak hole
            }
        } else if holes[storeHouse] == 49 {
            fillHoles()
        }
    }

}
