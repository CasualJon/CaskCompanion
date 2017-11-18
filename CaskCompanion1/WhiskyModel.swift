//
//  WhiskyModel.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 7/17/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import Foundation
import AVFoundation

class WhiskyDo: NSObject {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Making DBManager class a Singleton (lol)
    /////////////////////////////////////////////////////////////////////////////////////
    static let shared: WhiskyDo = WhiskyDo()
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    //  Bool to enable/disable Debug Mode (mainly print to Console)
    private var debugMode = true
    private var player: AVAudioPlayer?
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    //  NAME:   detailToConsole()
    //  PARAMS: option/detailToShow: String
    //  USAGE:  Function takes a string passed from caller and prints data to the Console iff 
    //          debugMode field = true
    //  RETURN: Void
    func detailToConsole(option detailToShow: String) {
        if debugMode {
            print("Option Selected: \(detailToShow)")
        }
        
        return
    }
    
    
    //  NAME:   palySound()
    //  PARAMS: proAudioName: String!, audioType: String!
    //  USAGE:  Function takes a string passed from caller and plays the associated audio file
    //  RETURN: Void
    func playSound(proAudioName: String) {
        let resourcePath = Bundle.main.resourceURL!
        let audioURL = resourcePath.appendingPathComponent(proAudioName)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: audioURL)
            self.player = sound
            sound.prepareToPlay()
            sound.play()
        } catch {
            print("Error Playing the Audio File")
        }
    }
}
