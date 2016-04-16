//
//  Birdy.swift
//  Flappy Sanders
//
//  Created by Kevin Smith on 4/7/16.
//  Copyright © 2016 CyberheadMedia. All rights reserved.
//

import Foundation
import SpriteKit

class Birdy : SKSpriteNode {
    
    let MovingBirdy1Texture = SKTexture(imageNamed: "Birdy1")
    let MovingBirdy2Texture = SKTexture(imageNamed: "Birdy2")
    
    init(size: CGSize) {
    super.init(texture: MovingBirdy1Texture, color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
    zPosition = 1
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func begin() {
        
        //Flapping wings animation
        let animation = SKAction.animateWithTextures([MovingBirdy1Texture,MovingBirdy2Texture], timePerFrame: 0.2)
        runAction(SKAction.repeatActionForever(animation))
    }
    
}