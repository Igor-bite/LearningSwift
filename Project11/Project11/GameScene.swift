//
//  GameScene.swift
//  Project11
//
//  Created by Игорь Клюжев on 31.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var balls = 0
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                balls = 0
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        for i in 0...4 {
            makeSlot(at: CGPoint(x: i * 256 + 128 , y: 0), isGood: i % 2 == 0 ? true : false)
            makeBouncer(at: CGPoint(x: i * 256, y: 0))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.name = "box"
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            } else {
                if balls < 5 {
                    let random = Int.random(in: 0...6)
                    var name = "ball"
                    switch random {
                    case 0:
                        name += "Red"
                    case 1:
                        name += "Purple"
                    case 2:
                        name += "Cyan"
                    case 3:
                        name += "Blue"
                    case 4:
                        name += "Green"
                    case 5:
                        name += "Yellow"
                    case 6:
                        name += "Grey"
                    default:
                        name += "Red"
                    }
                    let ball = SKSpriteNode(imageNamed: name)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position = CGPoint(x: location.x, y: 768)
                    ball.name = "ball"
                    addChild(ball)
                    balls += 1
                } else {
                    
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball, nil)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball, nil)
            score -= 1
        } else if object.name == "box" {
            destroy(ball: ball, object)
        }
    }
    
    func destroy(ball: SKNode, _ box: SKNode?) {
        
        
        if box != nil {
            if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
                guard let position = box?.position else { return }
                fireParticles.position = position
                addChild(fireParticles)
            }
            box?.removeFromParent()
        } else {
            if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
                fireParticles.position = ball.position
                addChild(fireParticles)
            }
            ball.removeFromParent()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" && (nodeB.name == "good" || nodeB.name == "bad") {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" && (nodeA.name == "good" || nodeA.name == "bad") {
            collision(between: nodeB, object: nodeA)
        } else if nodeA.name == "ball" && nodeB.name == "box" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" && nodeA.name == "box" {
            collision(between: nodeB, object: nodeA)
        }
    }
}
