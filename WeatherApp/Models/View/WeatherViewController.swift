//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by p h on 02.09.2022.
//

import UIKit
import SpriteKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var spriteKitView: SKView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var maxMinLabel: UILabel!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertDescription: UILabel!
    
    @IBOutlet weak var feelsLikeView: UIView!
    @IBOutlet weak var feelsLikeDescription: UILabel!
    
    @IBOutlet weak var windSpeedView: UIView!
    @IBOutlet weak var windSpeedDescription: UILabel!
    
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var humidityDescription: UILabel!
    
    @IBOutlet weak var hourlyView: UIView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    @IBOutlet weak var dailyView: UIView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    var presenter: WeatherPresenter!
    var weatherEntity: WeatherEntity?
    
    var dateFormatterService: DateFormatterService!
    var alertService: AlertService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
    }
    
    @IBAction func showListOfCities(_ sender: UIButton) {
        presenter.showFavourites()
    }
    
    // MARK: - Private Funcs
    private func setupUI() {
        setupAlert()
        setupFeelsLike()
        setupWindSpeed()
        setupHumidity()
        setupHourly()
        setupCollectionView()
        setupDaily()
        setupTableView()
    }
    
    private func setupBackgroud(nodes: [String], gradient: [String]) {
        let background = SKScene(size: view.frame.size)
        spriteKitView.presentScene(background)
        
        guard let color1 = UIColor.init(hex: gradient[0]),
              let color2 = UIColor.init(hex: gradient[1]) else { return }
        
        let texture = SKTexture(size: CGSize(width: view.frame.width, height: view.frame.height),
                                color1: CIColor(color: color1),
                                color2: CIColor(color: color2),
                                direction: GradientDirection.up)
        texture.filteringMode = .linear
        let backgroundSprite = SKSpriteNode(texture: texture)
        backgroundSprite.position = CGPoint(x: view.center.x, y: view.center.y)
        backgroundSprite.size = view.frame.size
        background.addChild(backgroundSprite)
        
        _ = nodes.compactMap { node in
            guard let animation = SKSpriteNode(fileNamed: node) else { return }
            background.addChild(animation)
            animation.position = CGPoint(x: view.frame.width - 100, y: view.frame.height)
        }
        spriteKitView.fadeIn()
    }
    
    private func setupAlert() {
        alertView.clipsToBounds = true
        alertView.layer.cornerRadius = 15
    }
    
    private func setupFeelsLike() {
        feelsLikeView.clipsToBounds = true
        feelsLikeView.layer.cornerRadius = 15
    }
    
    private func setupWindSpeed() {
        windSpeedView.clipsToBounds = true
        windSpeedView.layer.cornerRadius = 15
    }
    
    private func setupHumidity() {
        humidityView.clipsToBounds = true
        humidityView.layer.cornerRadius = 15
    }
    
    private func setupHourly() {
        hourlyView.clipsToBounds = true
        hourlyView.layer.cornerRadius = 15
    }
    
    private func setupCollectionView() {
        hourlyCollectionView.backgroundColor = .clear
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.register(UINib(nibName: String(describing: HourlyCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: HourlyCell.self))
    }
    
    private func setupDaily() {
        dailyView.clipsToBounds = true
        dailyView.layer.cornerRadius = 15
    }
    
    private func setupTableView() {
        dailyTableView.backgroundColor = .clear
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        dailyTableView.register(UINib(nibName: String(describing: DailyCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DailyCell.self))
    }
    
    private func setupDataToUI() {
        guard let unwrapEntity = weatherEntity else { return }
        cityLabel.text = unwrapEntity.city
        degreesLabel.text = "\(unwrapEntity.currentTemp.toInt())°"
        descriptionLabel.text = unwrapEntity.desc.firstUppercased
        maxMinLabel.text = "H:\(unwrapEntity.maxTemp.toInt())° L:\(unwrapEntity.minTemp.toInt())°"
        alertDescription.text = "There's no danger"
        feelsLikeDescription.text = "\(unwrapEntity.feelsLike.toInt())°"
        windSpeedDescription.text = "\(round(10 * unwrapEntity.windSpeed) / 10) m/s"
        humidityDescription.text = "\(unwrapEntity.humidity)%"
    }
}

// MARK: - Extensions
extension WeatherViewController: WeatherPresenterOutput {
    func setBackground(nodes: [String], gradient: [String]) {
        setupBackgroud(nodes: nodes, gradient: gradient)
    }
    
    func setDataToUI(entity: WeatherEntity) {
        weatherEntity = entity
        setupDataToUI()
        dailyTableView.reloadData()
        hourlyCollectionView.reloadData()
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let entity = weatherEntity else { return 0 }
        return entity.dailyForecast.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let forecast = weatherEntity?.dailyForecast else { return UITableViewCell() }
        let daily = forecast[indexPath.row]
        if let cell = dailyTableView.dequeueReusableCell(withIdentifier: String(describing: DailyCell.self), for: indexPath) as? DailyCell {
            cell.backgroundColor = .clear
            cell.isUserInteractionEnabled = false
            let icon = daily.weather[0].icon
            let iconsDict = WeatherIconsModel()
            guard let unwrapIcon = iconsDict.iconsDict[icon] else { return UITableViewCell() }
            
            cell.weatherIcon.image = UIImage(systemName: unwrapIcon)
            cell.dayLabel.text = dateFormatterService.dailyDateFormatter(date: daily.dt)
            if #available(iOS 16, *) {
                if "\(UnitTemperature(forLocale: Locale.current))".contains("F") {
                    cell.maxTempLabel.text = "\(daily.temp.max.kelvinToFahrenheit().toInt())°"
                    cell.minTempLabel.text = "\(daily.temp.min.kelvinToFahrenheit().toInt())°"
                } else {
                    cell.maxTempLabel.text = "\(daily.temp.max.kelvinToCelsius().toInt())°"
                    cell.minTempLabel.text = "\(daily.temp.min.kelvinToCelsius().toInt())°"
                }
            } else {
                cell.maxTempLabel.text = "\(daily.temp.max.kelvinToCelsius().toInt())°"
                cell.minTempLabel.text = "\(daily.temp.min.kelvinToCelsius().toInt())°"
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = weatherEntity?.hourlyForecast.count else { return 0 }
        if count != 0 {
            return 24
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyCell.self), for: indexPath) as? HourlyCell {
            cell.backgroundColor = .clear
            guard let hourly = weatherEntity?.hourlyForecast[indexPath.row] else { return UICollectionViewCell() }
            let temp = hourly.temp
            let icon = hourly.weather[0].icon
            let iconsDict = WeatherIconsModel()
            guard let unwrapIcon = iconsDict.iconsDict[icon] else { return UICollectionViewCell() }
            if #available(iOS 16, *) {
                if "\(UnitTemperature(forLocale: Locale.current))".contains("F") {
                    cell.degreesLabel.text = "\(Double(temp).kelvinToFahrenheit().toInt())°"
                } else {
                    cell.degreesLabel.text = "\(Double(temp).kelvinToCelsius().toInt())°"
                }
            } else {
                cell.degreesLabel.text = "\(Double(temp).kelvinToCelsius().toInt())°"
            }
            cell.weatherImage.image = UIImage(systemName: unwrapIcon)
            cell.timeLabel.text = dateFormatterService.hourlyDateFormatter(date: hourly.dt)
            
            return cell
        }
        return UICollectionViewCell()
    }
}
