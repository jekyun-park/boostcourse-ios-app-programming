//
//  ViewController.swift
//  WeatherToday
//
//  Created by 박제균 on 2022/01/26.
//

/* Todo
 - 화면1: 세계 국가 리스트 [x]
 - navigation item 타이틀: 세계 날씨 [x]
 - 테이블뷰 셀 : 국기 이미지, 국가 이름 [x]
 - 악세서리뷰: 다음 화면으로 이동 가능 [x]
 - 선택시 화면2로 전환 [x]
 */


import UIKit

class CountryViewController: UIViewController {

    @IBOutlet weak var countryTableView: UITableView!
    let cellIdentifier: String = "cell"
    var countries: [Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "세계 날씨"
        
        countries = decodeJSON(&countries, "countries")
        self.countryTableView.reloadData()
    }
}

// MARK: - TableView
extension CountryViewController: UITableViewDataSource, UITableViewDelegate {

    // Row 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }

    // cell에 담아줄 국기 이미지, 국가 이름 label
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = countryTableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        let country: Country = self.countries[indexPath.row]

        cell.imageView?.image = UIImage(named: country.flagImageName)
        cell.textLabel?.text = country.koreanName

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry: Country = self.countries[indexPath.row]

        guard let cityViewController: CityViewController = storyboard?.instantiateViewController(withIdentifier: "cityViewController") as? CityViewController else {
            return
        }

        cityViewController.country = selectedCountry
        navigationController?.pushViewController(cityViewController, animated: true)
    }

}

// MARK: - Decode JSON
func decodeJSON(_ target: inout [Country], _ dataAssetName: String) -> [Country] {
    let jsonDecoder: JSONDecoder = JSONDecoder()
    var countries: [Country] = []

    guard let countriesAsset: NSDataAsset = NSDataAsset(name: dataAssetName) else {
        return countries
    }

    do {
        countries = try jsonDecoder.decode([Country].self, from: countriesAsset.data)
    } catch {
        print(error.localizedDescription)
    }
    
    return countries
}
