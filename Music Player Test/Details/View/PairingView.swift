//
//  PairingView.swift
//  Music Player Test
//
//  Created by Jamyson Freire on 16/08/20.
//  Copyright © 2020 Doji. All rights reserved.
//

import UIKit

final class PairingView: UIView {
    @IBOutlet private weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

private extension PairingView {
    func commonInit() {
        Bundle.main.loadNibNamed("PairingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }
}
