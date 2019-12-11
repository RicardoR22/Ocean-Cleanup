//
//  GameOverScene.swift
//  Ocean Cleanup
//
//  Created by Ricardo Rodriguez on 12/10/19.
//  Copyright © 2019 Ricardo Rodriguez. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
	let gameOver = Label(fontNamed: "Chalkduster", fontSize: 30, name: "GameOverLabel", text: "GAME OVER")
	let replay = Label(fontNamed: "Chalkduster", fontSize: 20, name: "tapToReplayLabel", text: "Tap anywhere to Replay")
	let scoreLabel = Label(fontNamed: "Chalkduster", fontSize: 30, name: "ScoreLabel", text: "Score: 0")
	var score = 0

	
    override func didMove(to view: SKView) {
        
        if let view = self.view {
            gameOver.position = CGPoint(x: view.bounds.width/2, y: (view.bounds.height/2) + 20)
			scoreLabel.position = CGPoint(x: view.bounds.width/2, y: gameOver.position.y - 30)
			replay.position = CGPoint(x: view.bounds.width/2, y: scoreLabel.position.y - 50)
            replay.zPosition = 2
            
			scoreLabel.text = "Score: \(score)"
        }
        addChild(gameOver)
        addChild(replay)
		addChild(scoreLabel)
    }
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

		let gameScene = GameScene(size: size)
		gameScene.scaleMode = scaleMode

		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		view?.presentScene(gameScene, transition: reveal)

    }
    

}
