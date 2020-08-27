//
//  GameScene.swift
//  Milestone(16-18)
//
//  Created by Игорь Клюжев on 12.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let targets = ["squirrel", "target1", "target2", "target3"]
    let rows = [CGPoint(x: 1200, y: 384), CGPoint(x: 1200, y: 584), CGPoint(x: 1200, y: 184)]
    var gameTimer: Timer?
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "back")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        createTarget()
        
    }
    
    @objc func createTarget() {
        let target = targets.randomElement()
        
        let sprite = SKSpriteNode(imageNamed: target!)
        sprite.position = rows.randomElement()!
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height / 2, center: sprite.position)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
