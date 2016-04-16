
//
//  GameOver.swift
//  Flappy Sanders
//
//  Created by Kevin Smith on 4/3/16.
//  Copyright © 2016 CyberheadMedia. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import AVFoundation

class GameOver: SKScene {
    var bgColor = UIColor(red: 163.0/255.0, green: 188.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    var textGreenColor = UIColor(red: 163.0/255.0, green: 188.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    var playAgainButton = UIButton()
    var playAgainButtonImage = UIImage(named: "PlayAgainButton") as UIImage!

    var scoreLabel = UILabel()
    var scoreLabelImage = UIImage(named: "ScoreBG") as UIImage!
    var scoreLabelImageView = UIImageView()
    
    var gameOverSceneAudioPlayer = AVAudioPlayer()
    var gameOverSceneSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("CourseDemoGameOver", ofType: "mp3")!)
    
    override func didMoveToView(view: SKView) {
        
        
        //Setting the background to custom UIcolor
        backgroundColor = bgColor
        
        // Create the play again button
        self.playAgainButton = UIButton(type: UIButtonType.Custom)
        self.playAgainButton.setImage(playAgainButtonImage, forState: .Normal)
        self.playAgainButton.frame = CGRectMake(self.frame.size.width / 2, self.frame.size.height / 2, 80, 80)
        self.playAgainButton.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.playAgainButton.layer.zPosition = 0
        //make the playagain button perform an action when it is touched
        self.playAgainButton.addTarget(self, action: "playAgainButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        delay(0.5) {
            view.addSubview(self.playAgainButton)
            
            
        }
    
        //Label to hold the players current score
        self.scoreLabel = UILabel(frame: CGRectMake(self.frame.size.width / 2, 200, 120, 120))
        self.scoreLabel.textAlignment = NSTextAlignment.Center
        self.scoreLabel.textColor = textGreenColor
        self.scoreLabel.text = "\(kScore)"
        self.scoreLabel.font = UIFont(name: scoreLabel.font.fontName, size: 45)
        self.scoreLabel.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.scoreLabel.layer.zPosition = 1
        
        //Set background image for the score label
        self.scoreLabelImageView = UIImageView(image: scoreLabelImage!)
        self.scoreLabelImageView.frame = CGRectMake(self.frame.size.width / 2, 200, 120, 120)
        self.scoreLabelImageView.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.scoreLabelImageView.layer.zPosition = 0
        delay(0.5) {
            view.addSubview(self.scoreLabel)
            view.addSubview(self.scoreLabelImageView)
        }
        
        delay(0.5) {
            
            //Play the game over scene audio
            self.playGameOverSceneAudio()
        }
    
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_SEC))),dispatch_get_main_queue(),closure)
    }
    func playAgainButtonAction(sender:UIButton!) {
        
        delay(0.5) {
            //Play the game again
            self.playAgain()
        }
        
    }
    
    func playGameOverSceneAudio() {
        //Setting up the audio player for the game over scene audio
        do {
            try gameOverSceneAudioPlayer = AVAudioPlayer(contentsOfURL:
            gameOverSceneSound) } catch {
            print("GameScene. gameSceneEffectAudioPlayer is not available") }
        gameOverSceneAudioPlayer.prepareToPlay()
        gameOverSceneAudioPlayer.numberOfLoops = -1
        gameOverSceneAudioPlayer.play()
        
    }


    func playAgain() {
        
        //Removes the scoreLabel from the view
        scoreLabel.removeFromSuperview()
        
        //Removes the scoreLabelImageView for the view
        scoreLabelImageView.removeFromSuperview()
        
        //Removes the playAgainButton from the view
        playAgainButton.removeFromSuperview()
        
        // Create the new scene to transition to
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        
        //Remove scene before transitioning
        self.scene?.removeFromParent()
        
        // The transition effect
        let transition = SKTransition.fadeWithColor(UIColor.grayColor(), duration: 1.0)
        transition.pausesOutgoingScene = false
        
        //A variable to hold the GameOver scene
        var scene: GameScene!
        scene = GameScene(size: skView.bounds.size)
        
        //Setting the new scene's aspect ratio to fill
        scene.scaleMode = .AspectFill
        
        //Presenting the new scene with a transition effect
        skView.presentScene(scene, transition: transition)

        
        
    }

}