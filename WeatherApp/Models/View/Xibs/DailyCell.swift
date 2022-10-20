//
//  DailyCell.swift
//  WeatherApp
//
//  Created by p h on 01.09.2022.
//

import UIKit

class DailyCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
