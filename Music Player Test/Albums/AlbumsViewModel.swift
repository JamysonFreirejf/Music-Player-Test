//
//  AlbumsViewModel.swift
//  Music Player Test
//
//  Created by Jamyson Freire on 15/08/20.
//  Copyright © 2020 Doji. All rights reserved.
//

import Foundation
import UIKit

struct Album {
    let music: String
    let artist: String
    let image: UIImage
}

enum AlbumsCollumns: CGFloat {
    case one = 1
    case two = 2
}

final class AlbumsViewModel {
    let albums: [Album]
    var collumns: AlbumsCollumns = .two
    var skipAnimation = false
    var animationType: AnimationType = .default
    
    init(albums: [Album] = [.init(music: "Starboy", artist: "Daft Punk", image: #imageLiteral(resourceName: "Rectangle 40")),
                            .init(music: "Girls Like You", artist: "Maroon 5", image: #imageLiteral(resourceName: "Rectangle 40-5")),
                            .init(music: "Senorit", artist: "Camila & Shawn", image: #imageLiteral(resourceName: "Rectangle 40-1")),
                            .init(music: "Love me like you do", artist: "Ellie Goulding", image: #imageLiteral(resourceName: "Rectangle 40-4")),
                            .init(music: "Happier", artist: "Marshmello", image: #imageLiteral(resourceName: "Rectangle 40-2")),
                            .init(music: "Shape of you", artist: "Ed Sheeran", image: #imageLiteral(resourceName: "Rectangle 40-3"))]) {
        self.albums = albums
    }
    
    func toggleCollumns(completion: @escaping () -> Void) {
        if collumns == .one {
            animationType = .singleLineTransaction
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.animationType = .singleLineToDefault
                self.collumns = .two
                completion()
            }
        } else if collumns == .two {
            animationType = .singleLine
            collumns = .one
        }
        completion()
    }
}
