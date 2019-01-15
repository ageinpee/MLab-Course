//
//  Companion+Extension.swift
//  DewertOkin
//
//  Created by Jan Robert on 15.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import UIKit
import Charts
import CoreData
import UserNotifications

extension CompanionTableViewController {
    
    // Handle the activity countdown
    // Call checkActivity in Health.shared
    
    
}

class StatisticsCell: UITableViewCell {
    
    let dataEntry = [BarChartDataEntry(x: 10, y: 100)]
    
    lazy var testView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var barChart: BarChartView = BarChartView(frame: .zero) {
        didSet {
            setupViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupChartData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        
        contentView.addSubview(barChart)
        
        contentView.addConstraint(NSLayoutConstraint(item: barChart, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: barChart, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[v0]-32-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":barChart]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0(200)]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":barChart]))
        
        layoutIfNeeded()
        layoutSubviews()
    }
    
    
    
    
    private func setupChartData() {
        
        var barChartDataSet = BarChartDataSet(values: dataEntry, label: "testData")
        var barChartData = BarChartData(dataSet: barChartDataSet)
        var stepDataArray: [BarChartDataEntry] = []
        
        Health.shared.getLastDaysStepsInHourIntervals { resultsArray in
            print(resultsArray)
            
            if resultsArray.filter({ !$0.isZero }).isEmpty {
                DispatchQueue.main.async {
                    self.barChart.data = nil
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
                self.barChart.data = barChartData
            }
        }
    }
}

class ReminderCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ReminderSection: String {
    case exerciseStatistics = "Exercise Statistics"
    case activityReminder = "Activity Reminder"
    case regularReminders = "Custom Reminders"
}

class TimeIntervalSelectionTableViewController: UITableViewController {
    
    let timeIntervals = [30, 60, 90, 120, 150, 180]
    let timeCell = "timeCell"
    
    var delegate: TimeIntervalSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        self.navigationItem.title = "Choose a Time Interval"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: timeCell)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: timeCell, for: indexPath)
        cell.textLabel?.text = "\(timeIntervals[indexPath.row]) min"
        cell.accessoryType = selectedRow.contains(indexPath) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeIntervals.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "How often do you want to be reminded?"
    }
    
    var selectedRow: [IndexPath] = [IndexPath(row: 0, section: 0)]
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let oldSelectedRow = selectedRow.first ?? IndexPath(row: 0, section: 0)
        
        selectedRow.removeAll()
        selectedRow.append(indexPath)
        
        delegate?.selectedTimeInterval(minutes: timeIntervals[indexPath.row])
        
        tableView.reloadRows(at: [oldSelectedRow, indexPath], with: .none)
        navigationController?.popViewController(animated: true)
    }
    
}

protocol TimeIntervalSelectionDelegate {
    func selectedTimeInterval(minutes: Int)
}
