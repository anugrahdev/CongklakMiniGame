//
//  GamingStage.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 02/10/21.
//

import UIKit

extension HomeGameController {
    
    
    func isLastSeed(index: Int) {

        if (index == 7 && contentView.currentPlayer == .PlayerBlack) || (index == 15 && contentView.currentPlayer == .PlayerWhite){
            holes[index] += 1
            seedsInHand -= 1
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
            
        }
        
    }

}
