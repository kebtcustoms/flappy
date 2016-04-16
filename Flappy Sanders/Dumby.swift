//
//  Dumby.swift
//  Flappy Sanders
//
//  Created by Kevin Smith on 4/7/16.
//  Copyright © 2016 CyberheadMedia. All rights reserved.
//

import Foundation
import SpriteKit

class Dumby : SKSpriteNode {
    let DumbyTexture = SKTexture(imageNamed: "Birdy1")
    init(size: CGSize) {
        super.init(texture: DumbyTexture, color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        zPosition = 1
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
