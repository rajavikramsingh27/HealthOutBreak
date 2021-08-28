//  StatisticsViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.



import UIKit
import CoreLocation
import GoogleMaps
//import AAInfographics
import SwiftMessageBar
import Charts

class StatisticsViewController:BaseViewController {
    
    @IBOutlet weak var collStatistics:UICollectionView!
    @IBOutlet weak var tblStatistics:UITableView!
    @IBOutlet weak var btnMenu:UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewForChart: LineChartView!
    
    @IBOutlet weak var heightChart:NSLayoutConstraint!
    @IBOutlet weak var heightStatisticsList:NSLayoutConstraint!
    
    var arrStatistics = ["All","Today","This Week"]
    var arrStatisticsSelected = [Bool]()
    
    var arrStatisticsTbl = ["Confirmed","Deaths","Recovered"]
    var arrStatisticsTblCount = [String]() //["529,591","23,969","121,285"]
    var arrStatisticsTblBG = ["BlueStatistics.png","orangeStatistics.png","redStatistics.png"]
    //    var aaChartModel: AAChartModel!
    
    var locationManager = CLLocationManager()
    var is_location = false
    
    var currentLocation = CLLocationCoordinate2D(latitude: 26.912259, longitude: 75.787359)
    //    var aaChartView: AAChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
        
        for i in 0..<arrStatistics.count {
            if i == 0 {
                arrStatisticsSelected.append(true)
            } else {
                arrStatisticsSelected.append(false)
            }
        }
        
        
//        setMarkersOnMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        is_location = false
        
        self.tabBarController?.tabBar.isHidden = false
        
        let allItems = self.tabBarController?.tabBar.items!
        for i in 0..<allItems!.count {
            allItems![i].title = ""
            if i == 2 {
                allItems![i].title = "Statistics"
            }
        }
        globalStaticsData()
        locationPermission()
    }
    
    @IBAction func openMenu(_ sender: Any) {
        slideMenuController()?.openLeft()
    }
    
    @IBAction func btnCheckLocation(_ sender:UIButton) {
        //        let vc = storyboard?.instantiateViewController(withIdentifier:"StatisticsLocationViewController") as! StatisticsLocationViewController
        //        navigationController?.pushViewController(vc, animated:true)
    }
    
    
    
    func globalStaticsData() {
        showLoader()
        APIFunc.getAPIWithoutBaseURL("https://api.coronatab.app/places/earth/data", [:]) { (json) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionaryObject == nil {
                    return
                }
                
                let decoder = JSONDecoder()
                if let jsonData = json["data"].description.data(using: .utf8) {
                    do {
                        globalStatisticData = try decoder.decode([GlobalStatisticData].self, from: jsonData)
                        
                        if let jsonData = json["meta"]["projected"].description.data(using: .utf8) {
                            globalStatisticProjected = try decoder.decode([GlobalStatisticData].self, from: jsonData)
                        } else {
                            globalStatisticProjected.removeAll()
                        }
                        
                        globalStatisticData = globalStatisticData+globalStatisticProjected
                        self.setUpAAChartView()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
    }
    
}



extension StatisticsViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = arrStatistics[indexPath.row].sizeText(UIFont(name:"Rockwell", size:16.0)!)
        let widht = size.width+CGFloat(50)
        return CGSize (width:widht, height:45)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrStatistics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! SignUpAddInfoCollectionCell
        
        cell.infoLbl.text = arrStatistics[indexPath.row]
        cell.containerView.backgroundColor = arrStatisticsSelected[indexPath.row] ? hexStringToUIColor(hex:"#4C2AB1") : hexStringToUIColor(hex:"#C1C1C1")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collStatistics {
            for i in 0..<arrStatisticsSelected.count {
                if i == indexPath.row {
                    arrStatisticsSelected[i] = true
                } else {
                    arrStatisticsSelected[i] = false
                }
            }
            setUpAAChartView()
            collStatistics.reloadData()
        }
    }
    
}



extension StatisticsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStatisticsTblCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for:indexPath) as! StatisticsTableViewCell
        
        cell.lblStaName.text = arrStatisticsTbl[indexPath.row]
        cell.lblStaCount.text = arrStatisticsTblCount[indexPath.row]
        cell.imgBG.image = UIImage (named:arrStatisticsTblBG[indexPath.row])
        
        return cell
    }
    
    func setMarkersOnMap() {
        self.mapView.clear()
        
        let markerCurrent = GMSMarker()
        
        let markerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 52))
        let image = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 52))
        image.image = #imageLiteral(resourceName: "Group 1818.png")
        markerView.addSubview(image)
        markerView.bringSubviewToFront(image)
        markerCurrent.iconView = markerView
        markerCurrent.position = currentLocation
        markerCurrent.map = self.mapView
        
        let cameraPosition = GMSCameraPosition.init(latitude:currentLocation.latitude, longitude:currentLocation.longitude, zoom:5)
        mapView.animate(to: cameraPosition)
        
        for i in 0..<statistics.count {
            let latDouble = Double(statistics[i].lat)!
            let longDouble = Double(statistics[i].lng)!
            
            let cordStatistics = CLLocationCoordinate2D (latitude: latDouble, longitude: longDouble)
            
            let marker = GMSMarker()
            let markerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            markerView.layer.borderColor = UIColor.black.cgColor
            markerView.layer.borderWidth = 1.0
            markerView.layer.masksToBounds = true
            markerView.layer.cornerRadius = 8
            
            if statistics[i].caseType.lowercased() == "Potential".lowercased() && statistics[i].status == "1" {
                //                blue
                markerView.backgroundColor = hexStringToUIColor(hex: "#1EC3FF")
            } else if statistics[i].caseType.lowercased() == "Confirmed".lowercased() && statistics[i].status == "1" {
                //                blue
                markerView.backgroundColor = hexStringToUIColor(hex: "#1EC3FF")
            } else if statistics[i].caseType.lowercased() == "Potential".lowercased() {
                //               orange
                markerView.backgroundColor = hexStringToUIColor(hex: "#FF7E29")
            } else if statistics[i].caseType.lowercased() == "Confirmed".lowercased() {
                //                red
                markerView.backgroundColor = hexStringToUIColor(hex: "#FB5151")
            }
            
            marker.iconView = markerView
            marker.position = cordStatistics
            marker.map = self.mapView
        }
        
    }
    
    func setUpAAChartView() {
        viewForChart.isUserInteractionEnabled = false
        viewForChart.xAxis.drawAxisLineEnabled = false
        viewForChart.xAxis.drawLimitLinesBehindDataEnabled = false
        viewForChart.xAxis.gridColor = UIColor(red:220/255, green:220/255,blue:220/255,alpha:1)
        viewForChart.xAxis.gridLineWidth = 0.5
        viewForChart.xAxis.drawGridLinesEnabled = false
        viewForChart.xAxis.drawLabelsEnabled = false
        viewForChart.leftAxis.removeAllLimitLines()
        viewForChart.leftAxis.drawZeroLineEnabled = false
        viewForChart.leftAxis.zeroLineWidth = 0
        viewForChart.leftAxis.drawTopYLabelEntryEnabled = true
        viewForChart.leftAxis.drawAxisLineEnabled = true
        viewForChart.leftAxis.drawGridLinesEnabled = false
        viewForChart.leftAxis.drawLabelsEnabled = true
        viewForChart.leftAxis.drawLimitLinesBehindDataEnabled = false
        viewForChart.rightAxis.removeAllLimitLines()
        viewForChart.rightAxis.drawZeroLineEnabled = false
        viewForChart.leftAxis.zeroLineWidth = 0
        viewForChart.rightAxis.drawTopYLabelEntryEnabled = false
        viewForChart.rightAxis.drawAxisLineEnabled = false
        viewForChart.rightAxis.drawGridLinesEnabled = false
        viewForChart.rightAxis.drawLabelsEnabled = false
        viewForChart.rightAxis.drawLimitLinesBehindDataEnabled = false
        
        
        var date = [String]()
        var cases = [Int]()
        var recovered = [Int]()
        var deaths = [Int]()
        
        arrStatisticsTblCount.removeAll()
        for i in 0..<globalStatisticData.count {
            let date1 = globalStatisticData[i].date.dateFromString("yyyy-MM-dd").dateToString("yyyy MMM dd")
            let dateEndDate = globalStatisticData[i].date.dateFromString("yyyy/MM/dd")
            let diffInDays = Calendar.current.dateComponents([.day,.hour], from:Date(), to:dateEndDate)
            
            if arrStatisticsSelected[0] {
                if diffInDays.day! <= 0 && diffInDays.hour! < 0 {
                    date.append(date1)
                    cases.append(globalStatisticData[i].cases)
                    recovered.append(globalStatisticData[i].recovered)
                    deaths.append(globalStatisticData[i].deaths)
                }
            } else if arrStatisticsSelected[1] {
                if (diffInDays.day! == -1 || diffInDays.day! == 0) && diffInDays.hour! < 0 {
                    date.append(date1)
                    cases.append(globalStatisticData[i].cases)
                    recovered.append(globalStatisticData[i].recovered)
                    deaths.append(globalStatisticData[i].deaths)
                }
            } else if arrStatisticsSelected[2] {
                if diffInDays.hour! < 0 && diffInDays.day! > -7 {
                    date.append(date1)
                    cases.append(globalStatisticData[i].cases)
                    recovered.append(globalStatisticData[i].recovered)
                    deaths.append(globalStatisticData[i].deaths)
                }
            }
        }
        
        let data = LineChartData()
        var lineChartEntry1 = [ChartDataEntry]()
        
        for i in 0..<cases.count {
            lineChartEntry1.append(ChartDataEntry(x: Double(i), y: Double(cases[i])))
        }
        let line1 = LineChartDataSet(entries: lineChartEntry1, label: "Confirmed")
        line1.drawCirclesEnabled = false
        line1.lineWidth = 5.0
        line1.colors = [hexStringToUIColor("#1EC3FF")]
        line1.fillFormatter = nil
        line1.drawFilledEnabled = true
        line1.fillColor = NSUIColor(cgColor: hexStringToUIColor("#1EC3FF").cgColor)
        line1.drawValuesEnabled = false
        data.addDataSet(line1)

        
        if (deaths.count > 0) {
            var lineChartEntry2 = [ChartDataEntry]()
            for i in 0..<deaths.count {
                lineChartEntry2.append(ChartDataEntry(x: Double(i), y: Double(deaths[i])))
            }
            let line2 = LineChartDataSet(entries: lineChartEntry2, label: "Deaths")
            line2.drawCirclesEnabled = false
            line2.lineWidth = 5.0
            line2.colors = [hexStringToUIColor("#FB5151")]
            line2.fillFormatter = nil
            line2.drawFilledEnabled = true
            line2.drawValuesEnabled = false
            line2.fillColor = NSUIColor(cgColor: hexStringToUIColor("#FB5151").cgColor)
            data.addDataSet(line2)
        }
        if (recovered.count > 0) {
            var lineChartEntry3 = [ChartDataEntry]()
            for i in 0..<recovered.count {
                lineChartEntry3.append(ChartDataEntry(x: Double(i), y: Double(recovered[i]) ))
            }
            let line3 = LineChartDataSet(entries: lineChartEntry3, label: "Recovered")
            line3.drawCirclesEnabled = false
            line3.lineWidth = 5.0
            line3.colors = [hexStringToUIColor("#FF7E29")]
            line3.fillColor = NSUIColor(cgColor: hexStringToUIColor("#FF7E29").cgColor)
            line3.drawFilledEnabled = true
            line3.fillFormatter = nil
            line3.drawValuesEnabled = false
            data.addDataSet(line3)
        }
        self.viewForChart.data = data
       
        if arrStatisticsSelected[0]{
            arrStatisticsTblCount.append("\(globalStatisticData.last!.cases)")
            arrStatisticsTblCount.append("\(globalStatisticData.last!.deaths)")
            arrStatisticsTblCount.append("\(globalStatisticData.last!.recovered)")

        }else if arrStatisticsSelected[1]{
        
            arrStatisticsTblCount.append("\(globalStatisticData.last!.cases - globalStatisticData[globalStatisticData.count-2].cases)")
            arrStatisticsTblCount.append("\(globalStatisticData.last!.deaths - globalStatisticData[globalStatisticData.count-2].deaths)")
            arrStatisticsTblCount.append("\(globalStatisticData.last!.recovered - globalStatisticData[globalStatisticData.count-2].recovered)")

        }else if arrStatisticsSelected[2]{
            arrStatisticsTblCount.append("\(globalStatisticData.last!.cases - globalStatisticData[globalStatisticData.count-8].cases)")
            arrStatisticsTblCount.append("\(globalStatisticData.last!.deaths - globalStatisticData[globalStatisticData.count-8].deaths)")
            arrStatisticsTblCount.append("\(globalStatisticData.last!.recovered - globalStatisticData[globalStatisticData.count-8].recovered)")

        }
        heightStatisticsList.constant = 270

        
        tblStatistics.reloadData()
    }
    
}



//extension StatisticsViewController:AAChartViewDelegate{
//    open func aaChartViewDidFinishLoad(_ aaChartView: AAChartView) {
//        print("🙂🙂🙂, AAChartView Did Finished Load!!!")
//    }
//
//    open func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
//        //        print(
//        //            """
//        //
//        //            selected point series element name: \(moveOverEventMessage.name ?? "")
//        //            WARNING!!!!!!!!!!!!!!!!!!!! Touch Event Message !!!!!!!!!!!!!!!!!!!! WARNING
//        //            ==========================================================================================
//        //            ------------------------------------------------------------------------------------------
//        //            user finger moved over!!!,get the move over event message: {
//        //            category = \(String(describing: moveOverEventMessage.category));
//        //            index = \(String(describing: moveOverEventMessage.index));
//        //            name = \(String(describing: moveOverEventMessage.name));
//        //            offset = \(String(describing: moveOverEventMessage.offset));
//        //            x = \(String(describing: moveOverEventMessage.x));
//        //            y = \(String(describing: moveOverEventMessage.y));
//        //            }
//        //            +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//        //            """
//        //        )
//    }
//}



extension StatisticsViewController:CLLocationManagerDelegate {
    func locationPermission() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!.coordinate
        
        if !is_location {
            is_location = true
            setMarkersOnMap()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}



extension UIViewController {
    func viewWillDisappear(_ animated: Bool) {
        dismissLoader()
    }
    
    func viewDidDisappear(_ animated: Bool) {
        dismissLoader()
    }
    
}

