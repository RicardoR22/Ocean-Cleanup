//
//  GameScene.swift
//  Ocean Cleanup
//
//  Created by Ricardo Rodriguez on 12/9/19.
//  Copyright © 2019 Ricardo Rodriguez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	private var backgroundSprite = SKSpriteNode()
	private var backgroundFrames: [SKTexture] = []
	private let boat = SKSpriteNode(imageNamed: "ship_small_body")
	private let scoreLabel = Label(fontNamed: "Chalkduster", fontSize: 20, name: "scoreLabel", text: "Score: 0")
	private var score = 0

	
	override func didMove(to view: SKView) {
		scene?.backgroundColor = .cyan
		makeBackground()
		animateBackground()
		makeBoat()
		
		scoreLabel.position = CGPoint(x: view.bounds.width - 50, y: view.bounds.height - 60)
		self.addChild(scoreLabel)
		
		let create = SKAction.run {
		   self.createObjects()
		}
		

		let sound:SKAction = SKAction.playSoundFileNamed("SeaWaves.mp3", waitForCompletion: true)
		let loopSound:SKAction = SKAction.repeatForever(sound)
		self.run(loopSound)
			   
			   
		let wait = SKAction.wait(forDuration: 2)
		let sequence = SKAction.group([create, wait])
		let repeatForever = SKAction.repeatForever(sequence)
		self.run(repeatForever)
		physicsWorld.contactDelegate = self
		
	}
	
	func makeBackground() {
		let backgroundAtlas = SKTextureAtlas(named: "OceanBackground")
		var oceanFrames: [SKTexture] = []
		
		let numImages = backgroundAtlas.textureNames.count
		for i in 1...numImages {
			let oceanTextureName = "ocean\(i)"
			oceanFrames.append(backgroundAtlas.textureNamed(oceanTextureName))
		}
		backgroundFrames = oceanFrames
		
		let firstFrameTexture = backgroundFrames[0]
		backgroundSprite = SKSpriteNode(texture: firstFrameTexture)
		backgroundSprite.position = CGPoint(x: frame.midX, y: frame.midY)
		backgroundSprite.size = CGSize(width: frame.width, height: frame.height)
		backgroundSprite.zPosition = -1
		addChild(backgroundSprite)
	}
	
	func animateBackground() {
		backgroundSprite.run(SKAction.repeatForever(
			SKAction.animate(with: backgroundFrames,
							 timePerFrame: 0.1,
							 resize: false,
							 restore: true)),
							 withKey:"movingOceanBackground")
	}
	
	func makeBoat() {
		boat.name = "boat"
		boat.size = CGSize(width: 75, height: 100)
		boat.position =  CGPoint(x: frame.midX, y: 100)
		boat.physicsBody = SKPhysicsBody(circleOfRadius: max((boat.size.width) / 2.75, (boat.size.height) / 3))
		boat.physicsBody?.usesPreciseCollisionDetection = true
		boat.physicsBody?.isDynamic = false
		boat.physicsBody?.contactTestBitMask = boat.physicsBody!.collisionBitMask
		boat.physicsBody?.collisionBitMask = UInt32(2)
		boat.physicsBody?.categoryBitMask = UInt32(4)
		boat.zPosition = 10
		
		let rippleEffect = SKSpriteNode(imageNamed: "water_ripple")
		rippleEffect.size = CGSize(width: 90, height: 130)
		rippleEffect.zPosition = -1
		
		addChild(boat)
		boat.addChild(rippleEffect)
		
	}
	
	func createObjects() {
		
		if Bool.random() {
			let ship = Obstacle()
			ship.position = CGPoint(x: CGFloat.random(in: 0..<size.width), y: (view?.bounds.height)!)
			ship.moveDown()
			self.addChild(ship)
		} else {
			let fish = Fish()
			fish.position = CGPoint(x: CGFloat.random(in: 0..<size.width), y: (view?.bounds.height)!)
			fish.moveDown()
			self.addChild(fish)
		}
		
	}
	
	func didCollide(ship: SKNode, object: SKNode) {
		if object.name == "obstacle" {
			destroy(object: object)
			presentGameOver()
		} else if object.name == "fish" {
			destroy(object: object)
			collectDebris()
		}
	}
	
	func collectDebris() {
		let collectEffect = SKEmitterNode(fileNamed: "CollectedDebris")
		collectEffect?.particlePosition = CGPoint(x: boat.anchorPoint.x, y: boat.anchorPoint.y)
		collectEffect?.targetNode = self
		boat.addChild(collectEffect!)
		scoreLabel.Score += 1
		score += 1
		scoreLabel.text = "Score: " + String(scoreLabel.Score)
	}
	
	func presentGameOver() {
		let gameOverScene = GameOverScene(size: size)
		gameOverScene.scaleMode = scaleMode
		gameOverScene.score = score

		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		view?.presentScene(gameOverScene, transition: reveal)
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		guard let nodeA = contact.bodyA.node else { return }
		guard let nodeB = contact.bodyB.node else { return }
		
		if contact.bodyA.node?.name == "boat" {
			didCollide(ship: nodeA, object: nodeB)
		} else if contact.bodyB.node?.name == "boat" {
			didCollide(ship: nodeB, object: nodeA)
		}
	}
	
	func destroy(object: SKNode) {
		object.removeFromParent()
	}
	
	func touchDown(atPoint pos : CGPoint) {
		let moveAction = SKAction.moveTo(x: pos.x, duration: 1)
		boat.run(moveAction)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
}
