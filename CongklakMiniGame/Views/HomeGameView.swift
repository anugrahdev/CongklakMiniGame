//
//  HomeGameView.swift
//  CongklakMiniGame
//
//  Created by Anang Nugraha on 02/10/21.
//

import Foundation
import UIKit
import SnapKit

protocol HomeGameViewDelegate: AnyObject {
    func didHoleTapped(_ index: Int)
    func didDecideTapped()
    func diSelectPlayerTapped(_ player: Player)
    func didRestartTapped()
    func didGameQuestionTapped()
}


class HomeGameView: BaseView {
    
    weak var delegate: HomeGameViewDelegate?
    
    var gameHoles = [Int]()
    var currentPlayer: Player!
    var buttonsHoles = [UIButton]()
    var labels = [UILabel]()
    
}
