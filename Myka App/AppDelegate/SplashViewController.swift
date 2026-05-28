//
//  SplashViewController.swift
//  My Kai
//
//  Created by YATIN  KALRA on 03/02/26.
//


import UIKit
import Lottie
import AVFoundation

final class SplashViewController: UIViewController {

    // MARK: - UI


    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.animation = LottieAnimation.named("splash_animation")
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private static var hasPlayedAudio = false
    // MARK: - Audio
    private var audioPlayer: AVAudioPlayer?
    var comesFrom = ""
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudio()
//        playSplash()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playSplash()
    }
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Audio Setup
    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: "splash_sound", withExtension: "mp3") else {
            print("splash_sound.mp3 not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Audio error:", error.localizedDescription)
        }
    }

    // MARK: - Play Splash
    private func playSplash() {
        
        if !Self.hasPlayedAudio {
            Self.hasPlayedAudio = true
            
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0
            audioPlayer?.play()
        }
        
        animationView.play { [weak self] finished in
            guard finished else { return }
            self?.navigateNext()
        }
    }

    // MARK: - Navigation
    private func navigateNext() {
        
        let isOnboarding = UserDetail.shared.getOnboardingStatus()
        let isLoginSession = UserDetail.shared.getLoginSession()
          
        if isLoginSession == true && isOnboarding == true && comesFrom != "letsStart"{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if isLoginSession == false && isOnboarding == true && comesFrom != "letsStart"{
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "letsStartVC") as! letsStartVC
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "IntroVC") as? IntroVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
