//
//  MovingMidground.swift
//  Flappy Sanders
//
//  Created by Kevin Smith on 4/3/16.
//  Copyright © 2016 CyberheadMedia. All rights reserved.
//

import Foundation
import SpriteKit

class MovingMidGround : SKSpriteNode {
    let MovingMidgroundTexture = SKTexture(imageNamed: "MovingMidground")
    let MovingGroundTexture = SKTexture(imageNamed: "MovingGround")
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size:CGSizeMake(MovingMidgroundTexture.size().width, MovingMidgroundTexture.size().height))
        anchorPoint = CGPointMake(0, 0)
        position = CGPointMake(0.0, 0.0)
        
        // Looping the midground texture
        for var i:CGFloat = 0; i<2 + self.frame.width / (MovingMidgroundTexture.size().width); ++i {
            let groundsprite = SKSpriteNode(texture: MovingMidgroundTexture)
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
        let moveGroundSprite = SKAction.moveByX(-MovingMidgroundTexture.size().width, y: 0, duration: NSTimeInterval(0.1 * MovingMidgroundTexture.size().width))
        let resetGroundSprite = SKAction.moveByX(MovingMidgroundTexture.size().width, y: 0, duration: 0.0)
        let moveSequence = SKAction.sequence([moveGroundSprite, resetGroundSprite])
        runAction(SKAction.repeatActionForever(moveSequence))
        
    }

}