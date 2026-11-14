//  AudioManager.swift

import AVFoundation

/// BGM と効果音の再生を管理するシングルトン
final class AudioManager {
    static let shared = AudioManager()

    enum Music: String {
        case title = "backgroundMusic"
        case game = "gameMusic"
    }

    enum SoundEffect: String, CaseIterable {
        case merge = "mergeSound"
        case watermelonMerge = "watermelonMergeSound"
        case gameOver = "gameOverSound"
    }

    private let defaults: UserDefaults
    private var musicPlayer: AVAudioPlayer?
    private var playingMusic: Music?
    private var effectPlayers: [SoundEffect: AVAudioPlayer] = [:]

    /// 現在の画面で流すべき BGM（バックグラウンド復帰時の再開に使う）
    private(set) var requestedMusic: Music?

    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        // 他アプリの音楽を止めず、消音スイッチにも従う
        try? AVAudioSession.sharedInstance().setCategory(.ambient)
        preloadEffects()
    }

    private var isMusicEnabled: Bool { defaults.bool(forKey: StorageKey.isMusicEnabled) }
    private var isSoundEffectsEnabled: Bool { defaults.bool(forKey: StorageKey.isSoundEffectsEnabled) }

    // MARK: - BGM

    func playMusic(_ music: Music) {
        requestedMusic = music
        guard isMusicEnabled else { return }
        if playingMusic == music, musicPlayer?.isPlaying == true { return }

        guard let url = Bundle.main.url(forResource: music.rawValue, withExtension: "mp3") else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.volume = 0.6
            player.prepareToPlay()
            player.play()
            musicPlayer = player
            playingMusic = music
        } catch {
            print("\(music.rawValue) could not be loaded: \(error)")
        }
    }

    /// 画面の BGM 指定は残したまま一時停止する（バックグラウンド移行時など）
    func pauseMusic() {
        musicPlayer?.pause()
    }

    func resumeMusic() {
        guard let music = requestedMusic, isMusicEnabled else { return }
        if playingMusic == music, let player = musicPlayer {
            player.play()
        } else {
            playMusic(music)
        }
    }

    func setMusicEnabled(_ isEnabled: Bool) {
        if isEnabled {
            resumeMusic()
        } else {
            musicPlayer?.stop()
            musicPlayer = nil
            playingMusic = nil
        }
    }

    // MARK: - 効果音

    func play(_ effect: SoundEffect) {
        guard isSoundEffectsEnabled, let player = effectPlayers[effect] else { return }
        player.currentTime = 0
        player.play()
    }

    private func preloadEffects() {
        for effect in SoundEffect.allCases {
            guard let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3"),
                  let player = try? AVAudioPlayer(contentsOf: url) else { continue }
            player.prepareToPlay()
            effectPlayers[effect] = player
        }
    }
}
