//
//  CityCell.swift
//  WeatherApp
//
//  Created by p h on 02.09.2022.
//

import UIKit
import SpriteKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var spriteKitView: SKView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var maxMinLabel: UILabel!
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Funcs
    private func setupUI() {
        spriteKitView.layer.cornerRadius = 15
        spriteKitView.clipsToBounds = true
        self.selectionStyle = .none
    }
    
    func setupBackgroud(nodes: [String], gradient: [String]) {
        let background = SKScene(size: spriteKitView.frame.size)
        spriteKitView.presentScene(background)
        
        guard let color1 = UIColor.init(hex: gradient[0]),
              let color2 = UIColor.init(hex: gradient[1]) else { return }
        
        let texture = SKTexture(size: CGSize(width: spriteKitView.frame.width, height: spriteKitView.frame.height),
                                color1: CIColor(color: color1),
                                color2: CIColor(color: color2),
                                direction: GradientDirection.up)
        texture.filteringMode = .linear
        let backgroundSprite = SKSpriteNode(texture: texture)
        backgroundSprite.position = CGPoint(x: spriteKitView.center.x, y: spriteKitView.center.y)
        backgroundSprite.size = spriteKitView.frame.size
        background.addChild(backgroundSprite)
        
        _ = nodes.compactMap { node in
            guard let animation = SKSpriteNode(fileNamed: node) else { return }
            background.addChild(animation)
            animation.position = CGPoint(x: spriteKitView.frame.width - 100, y: spriteKitView.frame.height + 75)
        }
    }
}
