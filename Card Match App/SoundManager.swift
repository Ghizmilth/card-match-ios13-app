//
//  SoundManager.swift
//  Card Match App
//
//  Created by Hidaner Ferrer on 12/11/19.
//  Copyright © 2019 Hidaner Ferrer. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
        
    }
    
    
    static func playSound(_ effect:SoundEffect) {
        
        var soundFileName = ""
        
        //Determine which sound efefect we want to play and choose the apprpriate file name
        switch effect {
            
            case .flip:
                soundFileName = "cardflip"
            
            case .shuffle:
                soundFileName = "shuffle"
        
            case .match:
                soundFileName = "dingcorrect"
        
            case .nomatch:
                soundFileName = "dingwrong"
    
                //Get the path to the sound file inside the bundle
        let bundlePath  = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
    
        guard bundlePath != nil else {
             print("Couldn't find sound file \(soundFileName) in the bundle")
             return
        }
            
        //Create a URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
            
        do{
           //Create audio player object
           audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
           
           //Play the sound
           audioPlayer?.play()
        }
        catch {
            //Couldn;t create audi player object, log the error
            print("Couldn't create audio player object for sound file \(soundFileName)")
        }
        
            
        }
    
        
    }
    
}
