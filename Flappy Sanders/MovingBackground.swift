//
//  MovingBackground.swift
//  Flappy Sanders
//
//  Created by Kevin Smith on 4/3/16.
//  Copyright © 2016 CyberheadMedia. All rights reserved.
//

import Foundation
import SpriteKit

class MovingBackground : SKSpriteNode {
    let MovingBackgroundTexture = SKTexture(imageNamed: "MovingBackground")
    let MovingGroundTexture = SKTexture(imageNamed: "MovingGround")
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        anchorPoint = CGPointMake(0, 0)
        position = CGPointMake(0.0, 0.0)
    
        // Looping the background mountain texture from left to right
        for var i:CGFloat = 0; i<2 + self.frame.width / (MovingBackgroundTexture.size().width); ++i {
            let groundsprite = SKSpriteNode(texture: MovingBackgroundTexture)
            groundsprite.zPosition = 0
            groundsprite.anchorPoint = CGPointMake(0, 0)
            groundsprite.position = CGPointMake(i * groundsprite.size.width, 0)
            addChild(groundsprite)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func begin() {
        // Moving the background at speed
        let moveGroundSprite = SKAction.moveByX(-MovingBackgroundTexture.size().width, y: 0, duration: NSTimeInterval(0.3 * MovingBackgroundTexture.size().width))
        let resetGroundSprite = SKAction.moveByX(MovingBackgroundTexture.size().width, y: 0, duration: 0.0)
        let moveSequence = SKAction.sequence([moveGroundSprite, resetGroundSprite])
        runAction(SKAction.repeatActionForever(moveSequence))
        
    }
    
    
}