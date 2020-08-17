//
//  DetailsViewController.swift
//  Music Player Test
//
//  Created by Jamyson Freire on 16/08/20.
//  Copyright © 2020 Doji. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {
    @IBOutlet private weak var musicLabel: UILabel!
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var pairingView: UIView!
    @IBOutlet private weak var overallView: UIView!
    @IBOutlet private weak var stackButtons: UIStackView!
    @IBOutlet private weak var fadeView: UIView!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var advanceButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var pairingWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pairingHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pairingBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pairingImageView: UIImageView!
    @IBOutlet private weak var smallArtistCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var smallArtistWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var smallArtistHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var blurView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var smallImageView: UIImageView!
    @IBOutlet private weak var secondaryMusicNameLabel: UILabel!
    @IBOutlet private weak var secondaryMusicNameTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var secondaryMusicNameRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dragView: UIView!
    
    private var blurEffectView: UIVisualEffectView?
    private let viewModel = DetailsViewModel()
    private var viewTranslation = CGPoint(x: 0, y: 0)
    private var swipedUp = false
    private var moved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
        setUpInitialStateForView()
        setUpBlurEffect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateInitial()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        parentView.layer.cornerRadius = 10
        backgroundView.layer.cornerRadius = 10
        pairingView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    @IBAction func handleGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            moved = true
            viewTranslation = gesture.translation(in: view)
            if swipedUp {
                let currentTranslation = viewTranslation.y - 606
                if viewTranslation.y > 0 && currentTranslation < 0 {
                    modalAnimation(offset: 606)
                    pairingImageView.alpha = 1 - min(abs(min(currentTranslation * (1/60), 0)), 1)
                    overallView.alpha = 1 - min(abs(min(currentTranslation * (1/570), 0)), 1)
                    backButton.alpha = 1 - min(abs(min(currentTranslation * (1/570), 0)), 1)
                    pairingWidthConstraint.constant = max(min(abs(currentTranslation * 8), view.frame.width), 83)
                    smallArtistWidthConstraint.constant = max(314 - abs(currentTranslation * 0.35), 88)
                    smallArtistHeightConstraint.constant = max(314 - abs(currentTranslation * 0.35), 88)
                    smallArtistCenterConstraint.constant = max(88 - abs(currentTranslation * 0.35), 0) - 88
                    blurEffectView?.alpha = min(abs(min(currentTranslation * (1/300), 0)), 1)
                    secondaryMusicNameLabel.alpha = 0
                    secondaryMusicNameTopConstraint.constant = max(600 - abs(currentTranslation), 52)
                    return
                }
                moved = false
                return
            }
            if viewTranslation.y < -606 || viewTranslation.y > 0 {
                if !swipedUp { moved = false }
                return
            }
            modalAnimation()
            pairingImageView.alpha = 1 - min(abs(min(viewTranslation.y * (1/60), 0)), 1)
            overallView.alpha = 1 - min(abs(min(viewTranslation.y * (1/570), 0)), 1)
            backButton.alpha = 1 - min(abs(min(viewTranslation.y * (1/570), 0)), 1)
            pairingWidthConstraint.constant = max(min(abs(viewTranslation.y * 8), view.frame.width), 83)
            smallArtistWidthConstraint.constant = max(314 - abs(viewTranslation.y), 88)
            smallArtistHeightConstraint.constant = max(314 - abs(viewTranslation.y), 88)
            smallArtistCenterConstraint.constant = max(88 - abs(viewTranslation.y), 0) - 88
            blurEffectView?.alpha = min(abs(min(viewTranslation.y * (1/300), 0)), 1)
            secondaryMusicNameLabel.alpha = min(abs(min(viewTranslation.y * (1/300), 0)), 1)
            secondaryMusicNameTopConstraint.constant = max(314 - abs(viewTranslation.y), 52)
            view.layoutIfNeeded()
        case .ended:
            if !moved { return }
            var currentTranslation = viewTranslation.y
            if swipedUp {
                currentTranslation -= 606
            }
            let translationMoved = (view.frame.height / 2) + currentTranslation
            if translationMoved <= (view.frame.height / 2) && translationMoved > 35 {
                swipedUp = false
                pairingWidthConstraint.constant = 83
                smallArtistWidthConstraint.constant = 314
                smallArtistHeightConstraint.constant = 314
                smallArtistCenterConstraint.constant = 0
                secondaryMusicNameTopConstraint.constant = 314
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.pairingView.transform = .identity
                    self.dragView.transform = .identity
                    self.pairingImageView.alpha = 1
                    self.overallView.alpha = 1
                    self.backButton.alpha = 1
                    self.blurEffectView?.alpha = 0
                    self.secondaryMusicNameLabel.alpha = 0
                    self.view.layoutIfNeeded()
                })
            } else {
                swipedUp = true
                viewTranslation.y = -606
                modalAnimation()
                pairingWidthConstraint.constant = view.frame.width
                smallArtistWidthConstraint.constant = 88
                smallArtistHeightConstraint.constant = 88
                smallArtistCenterConstraint.constant = -88
                secondaryMusicNameTopConstraint.constant = 52
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.pairingImageView.alpha = 0
                    self.overallView.alpha = 0
                    self.backButton.alpha = 0
                    self.blurEffectView?.alpha = 1
                    self.secondaryMusicNameLabel.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        default:
            break
        }
    }
    
    @IBAction func backClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

private extension DetailsViewController {
    func setUpLabels() {
        musicLabel.text = viewModel.musicName
        secondaryMusicNameLabel.text = viewModel.musicName
    }
    
    func setUpBlurEffect() {
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffectView?.frame = blurView.bounds
        blurEffectView?.alpha = 0
        guard let blurEffectView = blurEffectView else { return }
        blurView.insertSubview(blurEffectView, at: 0)
    }
    
    func setUpInitialStateForView() {
        fadeView.alpha = 1
        secondaryMusicNameLabel.alpha = 0
        smallImageView.alpha = 0
        pairingHeightConstraint.constant = view.frame.height
        pairingBottomConstraint.constant = -(view.frame.height - 10)
    }
    
    func animateInitial() {
        overallView.transform = .init(scaleX: 1, y: 0)
        overallView.center.y = view.frame.height
        UIView.animate(withDuration: 1, animations: {
            self.overallView.transform = .identity
            self.overallView.center.y = 0
            self.pauseButton.transform = .init(scaleX: 0.6, y: 0.6)
            self.advanceButton.transform = .init(scaleX: 0.6, y: 0.6)
            self.previousButton.transform = .init(scaleX: 0.6, y: 0.6)
        }, completion: { _ in
            self.animateFinalState()
        })
    }
    
    func animateFinalState() {
        pairingBottomConstraint.constant = -(view.frame.height - 60)
        UIView.animate(withDuration: 0.5, animations: {
            self.pauseButton.transform = .identity
            self.advanceButton.transform = .identity
            self.previousButton.transform = .identity
            self.fadeView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.smallImageView.alpha = 1
        })
    }
    
    func modalAnimation(offset: CGFloat = 0) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.pairingView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y - offset)
            self.dragView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y - offset)
        })
    }
}
