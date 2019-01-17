//
//  HealthViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 28.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import Charts
import UserNotifications

private let recommendationsLabel = "recommendationsLabel"
private let stepsLabel = "stepsLabel"
private let defaultCell = "defaultCell"

class HealthViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Health"
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleRefresh))], animated: true)
        
        self.collectionView!.register(RecommendationsLabelCell.self, forCellWithReuseIdentifier: recommendationsLabel)
        self.collectionView!.register(StepsViewCell.self, forCellWithReuseIdentifier: stepsLabel)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultCell)

        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        setupChartData()
    }
    
    let dataEntry = [BarChartDataEntry(x: 10, y: 100)]
    
    let barChartView: BarChartView = {
        let view = BarChartView()
        view.drawValueAboveBarEnabled = true
        view.legend.enabled = false
        view.leftAxis.axisMinimum = 0
        view.leftAxis.drawZeroLineEnabled = true
        view.setScaleEnabled(false)
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.noDataText = "No step data available."
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupChartData() {
        
        var barChartDataSet = BarChartDataSet(values: dataEntry, label: "testData")
        var barChartData = BarChartData(dataSet: barChartDataSet)
        var stepDataArray: [BarChartDataEntry] = []
        
        Health.shared.getLastDaysStepsInHourIntervals { resultsArray in
            print(resultsArray)
            
            if resultsArray.filter({ !$0.isZero }).isEmpty {
                DispatchQueue.main.async {
                    self.barChartView.data = nil
                }
                return
            }
            
            var iterator = 0
            for result in resultsArray {
                stepDataArray.append(BarChartDataEntry(x: Double(iterator), y: result))
                iterator += 1
            }
            barChartDataSet = BarChartDataSet(values: stepDataArray, label: "Steps")
            barChartDataSet.setColor(.red)
            barChartDataSet.drawValuesEnabled = false
            barChartData = BarChartData(dataSet: barChartDataSet)
            DispatchQueue.main.async {
                self.barChartView.data = barChartData
            }
        }
    }
    
    @objc
    private func handleRefresh() {
        barChartView.data = nil
        setupChartData()
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendationsLabel, for: indexPath) as? RecommendationsLabelCell {
                return cell
            }
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stepsLabel, for: indexPath) as? StepsViewCell {
                return cell
            }
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCell, for: indexPath)
            cell.addSubview(barChartView)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": barChartView]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": barChartView]))

            return cell
        default: return UICollectionViewCell()
        }
       return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 2 {
            return CGSize(width: view.frame.width, height: 300)
        }
        
        return CGSize(width: view.frame.width, height: 44)
    }

}

class RecommendationsLabelCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        let recommendationsLabel: UILabel = {
            let label = UILabel()
            label.text = "Enable recommendations"
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let recommendationsSwitch: UISwitch = {
            let newSwitch  = UISwitch()
            newSwitch.isOn = true
            newSwitch.addTarget(self, action: #selector(handleRecommendationsSliderChange), for: .valueChanged)
            newSwitch.translatesAutoresizingMaskIntoConstraints = false
            return newSwitch
        }()
        
        addSubview(recommendationsLabel)
        addSubview(recommendationsSwitch)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-[v1]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : recommendationsLabel, "v1" : recommendationsSwitch]))
        addConstraint(NSLayoutConstraint(item: recommendationsLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    @objc func handleRecommendationsSliderChange(sender: UISwitch) {
        if sender.isOn {
            print("Switch is on")
        } else {
            print("Switch is off")
        }
    }
}

class StepsViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stepsTextLabel: UILabel = {
            let label = UILabel()
            label.text = "Steps taken since sitting down"
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let stepsAmountLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.textAlignment = .right
            label.textColor = .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        Health.shared.getStepsForTimeInterval(timeInSeconds: 3600) { steps in
            if let steps = steps {
                stepsAmountLabel.text = String(Int(steps))
            }
        }
        
        addSubview(stepsTextLabel)
        addSubview(stepsAmountLabel)

        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-[v1]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : stepsTextLabel, "v1" : stepsAmountLabel]))
        addConstraint(NSLayoutConstraint(item: stepsTextLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
