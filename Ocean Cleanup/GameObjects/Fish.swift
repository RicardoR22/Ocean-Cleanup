//
//  Debris.swift
//  Ocean Cleanup
//
//  Created by Ricardo Rodriguez on 12/9/19.
//  Copyright © 2019 Ricardo Rodriguez. All rights reserved.
//

import SpriteKit

class Fish: SKSpriteNode {
	
	
	enum Fishes: String, CaseIterable {
		case redFish = "FishRed"
		case blueFish = "FishBlue"
		case greenFish = "FishGreen"
		case orangeFish = "FishOrange"
		case yellowFish = "FishYellow"
	}
	
	init(){
		let fish = Fishes.allCases.randomElement()
		let texture = SKTexture(imageNamed: fish!.rawValue)
        let size = texture.size()
		super.init(texture: texture, color: .clear, size: size)
        self.name = "fish"
		self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width / 2, height: size.height / 2), center: CGPoint(x: 0, y: 10))
		self.physicsBody?.usesPreciseCollisionDetection = true
		self.physicsBody?.affectedByGravity = false
		self.physicsBody?.collisionBitMask = UInt32(4)
		self.physicsBody?.categoryBitMask = UInt32(2)
	}
	
	
	func moveDown() {
		let moveDown = SKAction.moveTo(y: -50, duration: 5)
		let remove = SKAction.removeFromParent()
		let moveSequence = SKAction.sequence([moveDown, remove])
		self.run(moveSequence)
	}
	

	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
