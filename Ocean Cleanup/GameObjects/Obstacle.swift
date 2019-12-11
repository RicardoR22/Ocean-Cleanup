//
//  Ship.swift
//  Ocean Cleanup
//
//  Created by Ricardo Rodriguez on 12/9/19.
//  Copyright © 2019 Ricardo Rodriguez. All rights reserved.
//

import SpriteKit

class Obstacle: SKSpriteNode {
	
	enum Obstacles: String, CaseIterable {
		case rockLarge = "rockLarge"
		case rockSmall = "rockSmall"
		case rockWide = "rockWide"
	}
	
	init(){
		let obstacle = Obstacles.allCases.randomElement()
		let texture = SKTexture(imageNamed: obstacle!.rawValue)
        let size = texture.size()
		super.init(texture: texture, color: .clear, size: size)
        self.name = "obstacle"
		self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width / 4.5, height: size.height / 4.5), center: CGPoint(x: 0, y: -20))
		self.physicsBody?.usesPreciseCollisionDetection = true
		self.physicsBody?.affectedByGravity = false
		self.physicsBody?.collisionBitMask = UInt32(4)
		self.physicsBody?.categoryBitMask = UInt32(2)
		self.zPosition = 3
	}
	
	
	func moveDown() {
		let moveDown = SKAction.moveTo(y: -50, duration: 8)
		let remove = SKAction.removeFromParent()
		let moveSequence = SKAction.sequence([moveDown, remove])
		self.run(moveSequence)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
