//
//  FavouritesViewController.swift
//  WeatherApp
//
//  Created by p h on 02.09.2022.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var citiesTable: UITableView!
    
    var dateFormatterService: DateFormatterService!
    var locationService: LocationService!
    var alertService: AlertService!
    
    var presenter: FavouritesPresenter!
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setups
    private func setupUI() {
        setupSearchBar()
        setupLocationsTableView()
    }
    
    private func setupLocationsTableView() {
        citiesTable.backgroundColor = .clear
        citiesTable.separatorStyle = .none
        citiesTable.dataSource = self
        citiesTable.delegate = self
        citiesTable.register(UINib(nibName: String(describing: CityCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CityCell.self))
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.setShowsCancelButton(false, animated: false)
    }
    
    // MARK: - Private funcs
    private func showNoSearchResultAlert() {
        alertService.noSearchResult(title: "City not found!",
                                    message: "Incorrect city name",
                                    preset: .error,
                                    haptic: .error)
    }
}

// MARK: - Extensions
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.locationsEntity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = citiesTable.dequeueReusableCell(withIdentifier: String(describing: CityCell.self), for: indexPath) as? CityCell else { return UITableViewCell() }
        let location = presenter.locationsEntity[indexPath.row]
        let animation = presenter.animationsEntity[indexPath.row]
        cell.setupBackgroud(nodes: animation.nodes, gradient: animation.gradient)
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "My Location"
        default:
            cell.titleLabel.text = location.cityName
        }
        cell.cityLabel.text = location.cityName
        cell.weatherLabel.text = location.weatherDesc.firstUppercased
        if #available(iOS 16, *) {
            if "\(UnitTemperature(forLocale: Locale.current))".contains("F") {
                cell.temperatureLabel.text = "\(Double(location.temp).kelvinToFahrenheit().toInt())°"
                cell.maxMinLabel.text = "H:\(Double(location.maxTemp).kelvinToFahrenheit().toInt())° L:\(Double(location.minTemp).kelvinToFahrenheit().toInt())°"
            } else {
                cell.temperatureLabel.text = "\(Double(location.temp).kelvinToCelsius().toInt())°"
                cell.maxMinLabel.text = "H:\(Double(location.maxTemp).kelvinToCelsius().toInt())° L:\(Double(location.minTemp).kelvinToCelsius().toInt())°"
            }
        } else {
            cell.temperatureLabel.text = "\(Double(location.temp).kelvinToCelsius().toInt())°"
            cell.maxMinLabel.text = "H:\(Double(location.maxTemp).kelvinToCelsius().toInt())° L:\(Double(location.minTemp).kelvinToCelsius().toInt())°"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = presenter.locationsEntity[indexPath.row]
        let city = location.cityName
        let lat = location.lat
        let lon = location.lon
        presenter.getWeatherForCity(city: city, lat: lat, lon: lon)
        presenter.dismissFavouritesScreen()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch indexPath.row {
        case 0:
            return .none
        default:
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeCity(index: indexPath.row - 1)
        }
    }
}

extension FavouritesViewController: FavouritesPresenterOutput {
    func noCityResult() {
        showNoSearchResultAlert()
    }
    
    func setBackground() {
        UIView.transition(with: citiesTable, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.citiesTable.reloadData()
        }, completion: nil)
    }
    
    func setLocations() {
        UIView.transition(with: citiesTable, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.citiesTable.reloadData()
        }, completion: nil)
    }
}

extension FavouritesViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let cityName = searchBar.text else { return }
        presenter.addCity(city: cityName)
        searchBar.text = ""
    }
}

