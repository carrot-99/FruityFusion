//  AudioManager.swift

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    var backgroundMusicPlayer: AVAudioPlayer?
    var gameMusicPlayer: AVAudioPlayer?
    var mergeSoundPlayer: AVAudioPlayer?
    var watermelonMergeSoundPlayer: AVAudioPlayer?
    var gameOverSoundPlayer: AVAudioPlayer?
    enum ActiveScene {
        case title, game
    }
    var lastActiveScene: ActiveScene?

    private init() {}  // このクラスはシングルトンです
    
    private func isSoundEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isSoundEnabled")
    }
    
    func setSoundEnabled(_ isEnabled: Bool) {
        if isEnabled {
            // 音声をオンにする
            // 必要に応じて再生中の音声を再開する
        } else {
            // 音声をオフにする
            stopBackgroundMusic()
            stopGameMusic()
            // その他の音声も停止
        }
    }

    func playBackgroundMusic() {
        guard isSoundEnabled() else { return }
        let urlString = Bundle.main.path(forResource: "backgroundMusic", ofType: "mp3")
        guard let urlString = urlString else { return }

        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            backgroundMusicPlayer?.numberOfLoops = -1  // 無限にループさせます
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.play()
        } catch {
            print("backgroundMusic could not be loaded")
        }
        lastActiveScene = .title
    }

    func playGameMusic() {
        guard isSoundEnabled() else { return }
        let urlString = Bundle.main.path(forResource: "gameMusic", ofType: "mp3")
        guard let urlString = urlString else { return }

        do {
            gameMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            gameMusicPlayer?.numberOfLoops = -1
            gameMusicPlayer?.prepareToPlay()
            gameMusicPlayer?.play()
        } catch {
            print("gameMusic could not be loaded")
        }
        lastActiveScene = .game
    }
    
    func playMergeSound() {
        guard isSoundEnabled() else { return }
        playSound(fileName: "mergeSound", player: &mergeSoundPlayer)
    }

    func playWatermelonMergeSound() {
        guard isSoundEnabled() else { return }
        playSound(fileName: "watermelonMergeSound", player: &watermelonMergeSoundPlayer)
    }
    
    func playGameOverSound() {
        guard isSoundEnabled() else { return }
        playSound(fileName: "gameOverSound", player: &gameOverSoundPlayer)
    }

    private func playSound(fileName: String, player: inout AVAudioPlayer?) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("\(fileName) could not be played.")
        }
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }

    func stopGameMusic() {
        gameMusicPlayer?.stop()
    }
}
