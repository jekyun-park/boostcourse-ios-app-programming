//
//  RegionViewController.swift
//  WeatherToday
//
//  Created by 박제균 on 2022/01/26.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var cityTableView: UITableView!

    let cityCellIdentifier: String = "cityCell"
    var country: Country?
    var cities: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let countryKoreanName: String = country?.koreanName else {
            return
        }
        guard let countryAssetName: String = country?.assetName else {
            return
        }

        self.navigationItem.title = "\(countryKoreanName)"

        // MARK: - Decode JSON
        let jsonDecoder: JSONDecoder = JSONDecoder()

        guard let countryAsset: NSDataAsset = NSDataAsset(name: "\(countryAssetName)") else {
            return
        }

        do {
            self.cities = try jsonDecoder.decode([City].self, from: countryAsset.data)
        } catch {
            print(error.localizedDescription)
        }

        self.cityTableView.reloadData()
    }
}

// MARK: - TableView

extension CityViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell: CityTableViewCell = cityTableView.dequeueReusableCell(withIdentifier: cityCellIdentifier, for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }

//        let cell: CityTableViewCell = cityTableView.dequeueReusableCell(withIdentifier: cityCellIdentifier, for: indexPath)
//        as? CityTableViewCell
        // 강제 추출 하지않기

        let city: City = self.cities[indexPath.row]

        cell.weatherImageView.image = UIImage(named: city.description)
        cell.cityNameLabel.text = city.cityName
        cell.temperatureLabel.text = city.temperatureString
        cell.rainFallProbabilityLabel.text = city.rainFallProbabilityString
        if city.rainFallProbability > 50 { cell.rainFallProbabilityLabel.textColor = .orange }
        if city.celsius < 10 { cell.temperatureLabel.textColor = .blue }

        return cell
    }

    // 셀 선택시 화면3으로 이동, 화면3에 객체 전달.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity: City = self.cities[indexPath.row]

        guard let detailViewController: DetailViewController = storyboard?.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController else {
            return
        }

        detailViewController.cityWeatherInformation = selectedCity
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
