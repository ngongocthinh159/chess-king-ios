/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Ngo Ngoc Thinh
  ID: s3879364
  Created  date: 26/08/2024
  Last modified: 02/09/2024
  Acknowledgement:
     https://rmit.instructure.com/courses/138616/modules/items/6274581
     https://rmit.instructure.com/courses/138616/modules/items/6274582
     https://rmit.instructure.com/courses/138616/modules/items/6274583
     https://rmit.instructure.com/courses/138616/modules/items/6274584
     https://rmit.instructure.com/courses/138616/modules/items/6274585
     https://rmit.instructure.com/courses/138616/modules/items/6274586
     https://rmit.instructure.com/courses/138616/modules/items/6274588
     https://rmit.instructure.com/courses/138616/modules/items/6274589
     https://developer.apple.com/documentation/swift/
     https://developer.apple.com/documentation/swiftui/
     https://www.youtube.com/watch?v=Va1Xeq04YxU&t=15559s
     https://www.instructables.com/Playing-Chess/
     https://github.com/exyte/PopupView
     https://github.com/willdale/SwiftUICharts
*/

import Foundation

import AVFoundation
import UIKit

class AudioManager {
    static let shared = AudioManager()
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    private var gameMusicPlayer: AVAudioPlayer?
    private var leaderBoardMusicPlayer: AVAudioPlayer?
    private var htpMusicPlayer: AVAudioPlayer?
    private var modelData: ModelData?
    
    init() {
        setupEventNotifications()
    }
    
    func updateSettings(from modelData: ModelData) {
        self.modelData = modelData
    }
    
    func setupEventNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appWillResignActive() {
        if backgroundMusicPlayer?.isPlaying == true {
            backgroundMusicPlayer?.pause()
        }
    }

    @objc func appDidBecomeActive() {
        if isMusicEnabled, let player = backgroundMusicPlayer, !player.isPlaying {
            player.play()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    static func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playHTPMusic(filename: String) {
        if !isMusicEnabled {
            return
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Could not find file: \(filename)")
            return
        }
        if let player = htpMusicPlayer, player.url == url {
            // Resume if it's paused
            player.play()
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1 // Loop indefinitely
            player.play()
            htpMusicPlayer = player
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
    
    func playLeaderboardMusic(filename: String) {
        if !isMusicEnabled {
            return
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Could not find file: \(filename)")
            return
        }
        if let player = leaderBoardMusicPlayer, player.url == url {
            // Resume if it's paused
            player.play()
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1 // Loop indefinitely
            player.play()
            leaderBoardMusicPlayer = player
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
    
    func playBackgroundMusic(filename: String) {
        if !isMusicEnabled {
            return
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Could not find file: \(filename)")
            return
        }
        if let player = backgroundMusicPlayer, player.url == url {
            // Resume if it's paused
            player.play()
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1 // Loop indefinitely
            player.play()
            backgroundMusicPlayer = player
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
    
    func playGameMusic(filename: String) {
        if !isMusicEnabled {
            return
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Could not find file: \(filename)")
            return
        }
        if let player = gameMusicPlayer, player.url == url {
            // Resume if it's paused
            player.play()
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1 // Loop indefinitely
            player.play()
            gameMusicPlayer = player
        } catch {
            print("Could not create audio player: \(error)")
        }
    }

    func playSoundEffect(filename: String) {
        if !isMusicEnabled {
            return
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0  // Play once
            player.play()
            soundEffectPlayer = player
        } catch {
            print("Could not create sound effect player: \(error)")
        }
    }
    
    func pauseBackgroundMusic() {
        if backgroundMusicPlayer?.isPlaying == true {
            backgroundMusicPlayer?.pause()
        }
    }

    func resumeBackgoundMusic() {
        if isMusicEnabled, let player = backgroundMusicPlayer, !player.isPlaying {
            player.play()
        }
    }
    
    func stopBackgroundMusic() {
        if backgroundMusicPlayer?.isPlaying == true {
            backgroundMusicPlayer?.stop()
        }
    }
    
    func pauseSoundEffect() {
        if soundEffectPlayer?.isPlaying == true {
            soundEffectPlayer?.pause()
        }
    }

    func resumeSoundEffect() {
        if isMusicEnabled, let player = soundEffectPlayer, !player.isPlaying {
            player.play()
        }
    }
    
    func stopSoundEffect() {
        if soundEffectPlayer?.isPlaying == true {
            soundEffectPlayer?.stop()
        }
    }
    
    func stopAllMusics() {
        stopBackgroundMusic()
        stopSoundEffect()
    }
    
    func pauseGameMusic() {
        if gameMusicPlayer?.isPlaying == true {
            gameMusicPlayer?.pause()
        }
    }
    
    func stopGameMusic() {
        if gameMusicPlayer?.isPlaying == true {
            gameMusicPlayer?.stop()
        }
    }
    
    func pauseAllMusics() {
        pauseBackgroundMusic()
        pauseSoundEffect()
        pauseGameMusic()
        pauseLeaderboardMusic()
        pauseHTPMusic()
    }
    
    func pauseLeaderboardMusic() {
        if leaderBoardMusicPlayer?.isPlaying == true {
            leaderBoardMusicPlayer?.pause()
        }
    }
    
    func stopLeaderboardMusic() {
        if leaderBoardMusicPlayer?.isPlaying == true {
            leaderBoardMusicPlayer?.stop()
        }
    }
    
    func pauseHTPMusic() {
        if htpMusicPlayer?.isPlaying == true {
            htpMusicPlayer?.pause()
        }
    }
    
    func stopHTPMusic() {
        if htpMusicPlayer?.isPlaying == true {
            htpMusicPlayer?.stop()
        }
    }
    
    func pauseAllMusicsExcept(_ except: String) {
        if except == "background" {
            pauseSoundEffect()
            pauseGameMusic()
            pauseLeaderboardMusic()
            pauseHTPMusic()
        } else if except == "game" {
            pauseBackgroundMusic()
            pauseSoundEffect()
        } else if except == "effect" {
            pauseBackgroundMusic()
            pauseGameMusic()
        }
    }
    
    func resumeAllMusics() {
        resumeBackgoundMusic()
        resumeSoundEffect()
    }
    
    func isBackgoundPlayerPlaying() -> Bool {
        return backgroundMusicPlayer?.isPlaying ?? false
    }
    
    var isMusicEnabled: Bool {
        return modelData?.appConfig.isSoundOn ?? false
    }
}
