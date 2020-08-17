//
//  AlbumCollectionViewCell.swift
//  Music Player Test
//
//  Created by Jamyson Freire on 15/08/20.
//  Copyright © 2020 Doji. All rights reserved.
//

import UIKit

enum AnimationType {
    case `default`
    case singleLine
    case singleLineTransaction
    case singleLineToDefault
}

final class AlbumCollectionViewCell: UICollectionViewCell {

    static let identifier = "AlbumCollectionViewCell"
    
    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var secondaryImageView: UIImageView!
    @IBOutlet private weak var secondaryConstraint: NSLayoutConstraint!
    @IBOutlet private weak var musicNameLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var albumWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var albumHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var albumLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var secondaryWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var secondaryHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var musicNameTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var musicNameLeftConstraint: NSLayoutConstraint!
    
    private var skipAnimation = false
    
    func setUpView(album: Album, animationType: AnimationType, skipAnimation: Bool) {
        albumImageView.image = album.image
        musicNameLabel.text = album.music
        artistLabel.text = "by \(album.artist)"
        self.skipAnimation = skipAnimation
        animate(animationType)
    }
}

private extension AlbumCollectionViewCell {
    func animate(_ animationType: AnimationType) {
        switch animationType {
        case .default:
            animateDefault()
        case .singleLine:
            animateSingleLine()
        case .singleLineToDefault:
            animateSingleLineToDefault()
        case .singleLineTransaction:
            animateSingleLineTransaction()
        }
    }
    
    func animateDefault() {
//        albumImageView.alpha = 0
        secondaryImageView.alpha = 0
        albumImageView.transform = .init(scaleX: 0, y: 0)
        albumImageView.center.y = 220
        albumImageView.center.x = -220
        UIView.animate(withDuration: skipAnimation ? 0 : 1.5, animations: {
            self.albumImageView.transform = .identity
            self.albumImageView.center.y = 0
            self.albumImageView.center.x = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.secondaryImageView.alpha = 1
            self.animateDisc(open: true)
        })
    }
    
    func animateDisc(open: Bool, completion: (() -> Void)? = nil) {
        secondaryConstraint.constant = open ? secondaryWidthConstraint.constant / 2 : 0
        UIView.animate(withDuration: skipAnimation ? 0 : 0.6, animations:  {
            self.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
    
    func animateSingleLine() {
        secondaryImageView.alpha = 0
        artistLabel.alpha = 0
        musicNameLabel.textColor = .white
        secondaryConstraint.constant = 0
        albumWidthConstraint.constant = 220
        albumHeightConstraint.constant = 220
        albumLeftConstraint.constant = frame.width - 220
        musicNameLeftConstraint.constant = frame.width - 200
        musicNameTopConstraint.constant = -65
        UIView.animate(withDuration: skipAnimation ? 0 : 1.5, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.secondaryWidthConstraint.constant = 187
            self.secondaryHeightConstraint.constant = 187
            self.animateSingleLineFinalStep()
        })
    }
    
    func animateSingleLineFinalStep() {
        musicNameLeftConstraint.constant = 20
        albumLeftConstraint.constant = 0
        UIView.animate(withDuration: skipAnimation ? 0 : 0.5, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.secondaryImageView.alpha = 1
            self.animateDisc(open: true)
        })
    }
    
    func animateSingleLineTransaction() {
        animateDisc(open: false) {
            self.secondaryImageView.alpha = 0
            self.secondaryWidthConstraint.constant = 110
            self.secondaryHeightConstraint.constant = 110
        }
    }
    
    func animateSingleLineToDefault() {
        secondaryImageView.alpha = 1
        artistLabel.alpha = 1
        musicNameLabel.textColor = .black
        albumWidthConstraint.constant = 118
        albumHeightConstraint.constant = 118
        albumLeftConstraint.constant = 0
        musicNameLeftConstraint.constant = 0
        musicNameTopConstraint.constant = 21
        UIView.animate(withDuration: skipAnimation ? 0 : 0.5, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.animateDisc(open: true)
        })
    }
    
    func animateScaleDown() {
        albumWidthConstraint.constant = 110
        albumHeightConstraint.constant = 110
        UIView.animate(withDuration: skipAnimation ? 0 : 1.5) {
            self.layoutIfNeeded()
        }
    }
}
