//
//  HourlyCell.swift
//  WeatherApp
//
//  Created by p h on 01.09.2022.
//

import UIKit

class HourlyCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var degreesLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
