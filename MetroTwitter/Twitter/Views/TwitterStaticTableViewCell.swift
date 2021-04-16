//
//  TwitterStaticTableViewCell.swift
//  MetroTwitter
//
//  Created by Tsar on 14.04.2021.
//

import UIKit

final class TwitterStaticTableViewCell: UITableViewCell {
    @IBOutlet private weak var shadowView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor.twitterBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowView.layer.cornerRadius == 0 {
            shadowView.setupShadow()
            shadowView.layer.cornerRadius = 8
        }
        
    }
    
}
