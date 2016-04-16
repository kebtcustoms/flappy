//
//  GameScene.swift
//  Flappy Sanders
//
//  Created by Kevin Smith on 4/3/16.
//  Copyright (c) 2016 CyberheadMedia. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var movingGround : MovingGround!
    var movingBackground : MovingBackground!
    var movingMidground : MovingMidGround!
    var movingForeground : MovingForeground!
    var birdy : Birdy!
    var dumby : Dumby!

    let movingGroundTexture = SKTexture(imageNamed: "MovingGround")
    let MovingBackgroundTexture = SKTexture(imageNamed: "MovingBackground")
    let MovingMidgroundTexture = SKTexture(imageNamed: "MovingMidground")
    let MovingForegroundTexture = SKTexture(imageNamed: "MovingForeground")
    let Pipe1Texture = SKTexture(imageNamed: "Pipe1")
    let Pipe2Texture = SKTexture(imageNamed: "Pipe2")
    let MovingBirdyTexture = SKTexture(imageNamed: "Birdy1")
    let DumbyTexture = SKTexture(imageNamed: "Birdy1")



    var skyColor = UIColor(red: 133.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
    var moving = SKNode()
    var pipePair = SKNode()
    var pipes = SKNode()
    var groundLevel = SKNode()
    var skyLimit = SKNode()

    var alreadyAddedToTheScene = Bool()

    var movePipesAndRemove = SKAction()
    var spawnThenDelayForever = SKAction()
    
    let birdyCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    var score = NSInteger()
    var scoreLabelNode = SKLabelNode()
    
    var gameSceneAudioPlayer = AVAudioPlayer()
    var gameSceneSound = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("CourseDemoGameScene", ofType: "mp3")!)
    
    var gameSceneEffectAudioPlayer = AVAudioPlayer()
    var gameSceneEffectSound = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("CourseDemoGameOverEffect", ofType: "mp3")!)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Add moving node to the scene
        addChild(moving)
        
        //Gravity properties
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5)
        self.physicsWorld.contactDelegate = self
        
        //Boolean used to add stuff to the scene
        alreadyAddedToTheScene = false
        
        //Setting the background color
        backgroundColor = skyColor
        
        
        //Call an instance of MovingGroundClass
        movingGround = MovingGround(size: CGSizeMake(movingGroundTexture.size().width, movingGroundTexture.size().height))
        moving.addChild(movingGround)
        
        //Call an instance of the MovingBackground class
        movingBackground = MovingBackground(size: CGSizeMake(MovingBackgroundTexture.size().width, MovingBackgroundTexture.size().height))
        movingBackground.zPosition = -3
        moving.addChild(movingBackground)
        
        //Call an instance of MovingMidground class
        
        movingMidground = MovingMidGround(size: CGSizeMake(MovingMidgroundTexture.size().width, MovingMidgroundTexture.size().height))
        movingMidground.zPosition = -2
        moving.addChild(movingMidground)
        
        //Call an instance of MovingForeground class
        movingForeground = MovingForeground(size: CGSizeMake(MovingForegroundTexture.size().width, MovingForegroundTexture.size().height))
       movingForeground.zPosition = -1
        moving.addChild(movingForeground)
        
        //Add the pipes node to the moving node as a child
        moving.addChild(pipes)
        
        //Adding and removing Pipe1 and Pipe2 too and from the GameScene and it also set the speed that moves across the scene
        let distanceToMove = CGFloat(self.frame.size.width * 5.0 * Pipe1Texture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration: NSTimeInterval(0.004 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        //Attach the spawnPipes function directly into the gamescene
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        // Delays between each spawnPipes function
        let delay = SKAction.waitForDuration(1.9, withRange: 2.0)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        
        //Call an instance of the Dumby class
        dumby = Dumby(size: CGSizeMake(DumbyTexture.size().width, DumbyTexture.size().height))
        dumby.position = CGPoint(x: self.frame.size.width / 2.8, y: self.frame.size.height / 2)
        addChild(dumby)
        
        // Call an instance of the Birdy node
        birdy = Birdy(size: CGSizeMake(MovingBirdyTexture.size().width, MovingBirdyTexture.size().height))
        birdy.position = CGPoint(x: self.frame.size.width / 2.8, y: self.frame.size.height / 2)
        //SKPhYSIcs body properties 
        birdy.physicsBody = SKPhysicsBody(circleOfRadius: birdy.size.height / 2)
        birdy.physicsBody?.dynamic = true
        birdy.physicsBody?.allowsRotation = false
        // Add birdy to its own category
        birdy.physicsBody?.categoryBitMask = birdyCategory
        // Birdy can collide with the world and the pipes category
        birdy.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        // Notification is made when the bird collides with the world(ground) or pipes
        birdy.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        //Create a floor so the birdy cant fall through the bottom of the gamescene
        groundLevel.position = CGPointMake(self.frame.width / 2 , movingGroundTexture.size().height / 2)
        //SKPhysics body properties
        groundLevel.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, movingGroundTexture.size().height))
        groundLevel.physicsBody?.dynamic = false
        //Add the ground to the world category for collision detection
        groundLevel.physicsBody?.categoryBitMask = worldCategory
        //Notification is made when the birdy collides with the ground
        groundLevel.physicsBody?.contactTestBitMask = birdyCategory
        self.addChild(groundLevel)
        
        //Create a boundary around the edge of the screen
        skyLimit.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        skyLimit.physicsBody?.friction = 0
        //Add the skyLimit to the world category for collision detection
        skyLimit.physicsBody?.categoryBitMask = worldCategory
        //Notification is made when the birdy collides with the ground
        skyLimit.physicsBody?.contactTestBitMask = birdyCategory
        self.addChild(skyLimit)
        
        //Setting up the score label and adding it to the scene
        score = 0
        scoreLabelNode.fontName = "Halvetica"
        scoreLabelNode.position = CGPointMake(self.frame.size.width / 1.2, self.frame.size.height / 1.2)
        scoreLabelNode.fontColor = UIColor.darkGrayColor()
        scoreLabelNode.zPosition = 1
        scoreLabelNode.text = "\(score)"
        scoreLabelNode.fontSize = 65
        self.addChild(scoreLabelNode)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        
        addStuffToTheScene()
        alreadyAddedToTheScene = true
        
        if (moving.speed > 0) {
        birdy.physicsBody?.velocity = CGVectorMake(0, 0)
        birdy.physicsBody?.applyImpulse(CGVectorMake(0, 31))
            
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (moving.speed > 0) {
            //Tilts the birdy up and down
            birdy.zRotation = self.tiltConstrants(-1, max: 0.5, value: birdy.physicsBody!.velocity.dy * (birdy.physicsBody!.velocity.dx < 0 ? 0.003 : 0.001))
        }
    
    }
    func didBeginContact(contact: SKPhysicsContact) {
        //Detect to see if the scene is moving as collision detection should only work when the scene is moving
        if (moving.speed > 0) {
            if ((contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory || (contact.bodyB.categoryBitMask & scoreCategory) == scoreCategory) {
                
                //increments the score
                score++
                
                //saving the score to be used in the gameover scene
                kScore = score
                
                //Update the scoreLabelNode in the scene to display users current score
                scoreLabelNode.text = "\(score)"
                
            } else {
                
                //stop the scene from moving
                moving.speed = 0
               
                //collision detection with the world category
                birdy.physicsBody?.collisionBitMask = worldCategory
                
                //An attempt to bring the birdie to the ground after a collision has been detected
                let rotateBirdy = SKAction.rotateByAngle(0.01, duration: 0.003)
                let stopBirdy = SKAction.runBlock({() in self.killSpeed ()})
                let slowDownSequence = SKAction.sequence([rotateBirdy, stopBirdy])
                birdy.runAction(slowDownSequence)
                
                // Stop game scene audio when a collision is detected
                gameSceneAudioPlayer.stop()
                
                //Play the game over effect when a collision is detected
                playGameOverEffectAudio()
                
                delay(0.5) {
                    self.gameOver()
                }
            }
        }
        
    }
    
    func addStuffToTheScene() {
        if(alreadyAddedToTheScene == false) {
            //call everything you want to be added to the scene
            movingGround.begin()
            movingBackground.begin()
            movingMidground.begin()
            movingForeground.begin()
            self.runAction(spawnThenDelayForever)
            dumby.removeFromParent()
            addChild(birdy)
            birdy.begin()
            playGameSceneAudio()
            
            
        }
   
    }
    
    func spawnPipes() {
        
        // A node to add the two pipes too
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + Pipe1Texture.size().width, 0)
        pipePair.zPosition = 0
        
        //Pipes variable starting y position
        let height = UInt(self.frame.height / 3)
        let y = UInt(arc4random()) % height
        
        //Create a pipe1 node and add it to the pipePair node
        let pipe1 = SKSpriteNode(texture: Pipe1Texture)
        pipe1.position = CGPointMake(0.0, CGFloat(y))
        // SKPhysics body properties
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
        pipe1.physicsBody?.dynamic = false
        //Adds the pipe to the worldCategory for collision detection
        pipe1.physicsBody?.categoryBitMask = pipeCategory
        //Notification is made when the bird collides with the pipe
        pipe1.physicsBody?.contactTestBitMask = birdyCategory
        pipePair.addChild(pipe1)
        
        //Pipes variable gap
        let maxGap = UInt(self.frame.height / 5)
        let minGap = UInt32( self.frame.height / 8)
        let gap = UInt( arc4random_uniform(minGap)) + maxGap
        
        //Creat a pipe2 node and set the position with the vertical pipe gap and add it to the pipepair node
        let pipe2 = SKSpriteNode(texture: Pipe2Texture)
        pipe2.position = CGPointMake(0.0, CGFloat(y) + pipe1.size.height + CGFloat (gap))
        // SKPhysics body properties
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false
        //Adds the pipe to the worldCategory for collision detection
        pipe2.physicsBody?.categoryBitMask = pipeCategory
        //Notification is made when the bird collides with the pipe
        pipe2.physicsBody?.contactTestBitMask = birdyCategory
        pipePair.addChild(pipe2)
        
        //Counting/Detecting the score using collision detection on pipe1
        let contactBirdyNode = SKNode()
        contactBirdyNode.position = CGPointMake(pipe1.size.width + birdy.size.width, CGRectGetMidY(self.frame))
        contactBirdyNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, self.frame.size.height))
        contactBirdyNode.physicsBody?.dynamic = false
        contactBirdyNode.physicsBody?.categoryBitMask = scoreCategory
        contactBirdyNode.physicsBody?.contactTestBitMask = birdyCategory
        pipePair.addChild(contactBirdyNode)
        
        pipePair.runAction(movePipesAndRemove)
        
        pipes.addChild(pipePair)
        
    }
    
    //Birdy tilt constrants for when the Birdy moves up and down in the scene
    func tiltConstrants (min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if (value > max) {
            return max
        } else if (value < min) {
            return min
        } else {
            return value
        }
}
    
    func killSpeed() {
        //birdy speed to 0 when collision detection has occured 
        birdy.speed = 0
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_SEC))),dispatch_get_main_queue(),closure)
    }
    
    func playGameSceneAudio() {
        //Setting up the audio player for the game scene audio
        do {
            try gameSceneAudioPlayer = AVAudioPlayer(contentsOfURL:
            gameSceneSound)
        } catch {
            print("GameScene. gameSceneAudioPlayer is not available") }
        gameSceneAudioPlayer.prepareToPlay()
        gameSceneAudioPlayer.numberOfLoops = -1
        gameSceneAudioPlayer.play()
        
    }
    
    func playGameOverEffectAudio() {
        //Setting up the audio player for the game over effect audio
            do {
        try gameSceneEffectAudioPlayer = AVAudioPlayer(contentsOfURL:
        gameSceneEffectSound) } catch {
        print("GameScene. gameSceneEffectAudioPlayer is not available") }
            gameSceneEffectAudioPlayer.prepareToPlay()
            gameSceneEffectAudioPlayer.play()
            
    }
    
    func gameOver() {
        // Create the new scene to transition to
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        
        //Remove scene before transitioning
        self.scene?.removeFromParent()
        
        // The transition effect
        let transition = SKTransition.fadeWithColor(UIColor.grayColor(), duration: 1.0)
        transition.pausesOutgoingScene = false
        
        //A variable to hold the GameOver scene
        var scene: GameOver!
        scene = GameOver(size: skView.bounds.size)
        
        //Setting the new scene's aspect ratio to fill
        scene.scaleMode = .AspectFill
        
        //Presenting the new scene with a transition effect
        skView.presentScene(scene, transition: transition)
        
        
    }

}