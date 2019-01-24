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

class StatisticsCell: UITableViewCell {
    
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
    }
    
    
    func setupChartData() {
        
        if Health.shared.exerciseHistory.isEmpty {
            DispatchQueue.main.async {
                self.barChart.data = nil
            }
            return
        }
        
        var dataEntriesAllExerciseReminders: [BarChartDataEntry] = []
        var dataEntriesCompletedExercises: [BarChartDataEntry] = []
        
        let today = Date()
        let yesterday = Date().addingTimeInterval(-86400)
        let twoDaysAgo = Date().addingTimeInterval(-172800)
        let threeDaysAgo = Date().addingTimeInterval(-259200)
        let fourDaysAgo = Date().addingTimeInterval(-345600)
        let fiveDaysAgo = Date().addingTimeInterval(-432000)
        let sixDaysAgo = Date().addingTimeInterval(-518400)
        
        var totalExercises: [Int] = [0, 0, 0, 0, 0, 0, 0]
        var completedExercises: [Int] = [0, 0, 0, 0, 0, 0, 0]
    
        for exercise in Health.shared.exerciseHistory {
            
            // Only show entries from last week
            guard exercise.time.timeIntervalSinceNow >= -7*24*60*60 else { continue }
            
            if Calendar.current.isDate(exercise.time, inSameDayAs: today) {
                totalExercises[0] += 1
                if exercise.completed {
                    completedExercises[0] += 1
                }
            } else if Calendar.current.isDate(exercise.time, inSameDayAs: yesterday) {
                totalExercises[1] += 1
                if exercise.completed {
                    completedExercises[1] += 1
                }
            } else if Calendar.current.isDate(exercise.time, inSameDayAs: twoDaysAgo) {
                totalExercises[2] += 1
                if exercise.completed {
                    completedExercises[2] += 1
                }
            } else if Calendar.current.isDate(exercise.time, inSameDayAs: threeDaysAgo) {
                totalExercises[3] += 1
                if exercise.completed {
                    completedExercises[3] += 1
                }
            } else if Calendar.current.isDate(exercise.time, inSameDayAs: fourDaysAgo) {
                totalExercises[4] += 1
                if exercise.completed {
                    completedExercises[4] += 1
                }
            } else if Calendar.current.isDate(exercise.time, inSameDayAs: fiveDaysAgo) {
                totalExercises[5] += 1
                if exercise.completed {
                    completedExercises[5] += 1
                }
            } else if Calendar.current.isDate(exercise.time, inSameDayAs: sixDaysAgo) {
                totalExercises[6] += 1
                if exercise.completed {
                    completedExercises[6] += 1
                }
            }
        }
        
        for (i, exercise) in totalExercises.enumerated() {
            dataEntriesAllExerciseReminders.append(BarChartDataEntry(x: Double(i), y: Double(exercise)))
        }
        
        for (i, exercise) in completedExercises.enumerated() {
            dataEntriesCompletedExercises.append(BarChartDataEntry(x: Double(i), y: Double(exercise)))
        }
        
        let totalChartDataSet = BarChartDataSet(values: dataEntriesAllExerciseReminders, label: "Exercise Recommendations")
        let completedChartDataSet1 = BarChartDataSet(values: dataEntriesCompletedExercises, label: "Completed Exercises")
        
        totalChartDataSet.setColor(.lightGray)
        completedChartDataSet1.setColor(.red)
        totalChartDataSet.drawValuesEnabled = false
        completedChartDataSet1.drawValuesEnabled = false
        
        let dataSets: [BarChartDataSet] = [totalChartDataSet, completedChartDataSet1]
        
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        chartData.barWidth = barWidth
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barChart.xAxis.axisMaximum = gg * Double(6)
        barChart.xAxis.axisMinimum = 0

        chartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        chartData.notifyDataChanged()
        
        DispatchQueue.main.async {
            self.barChart.data = chartData
            self.barChart.animate(yAxisDuration: 1.5)
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
    
    let timeIntervals: [Float] = [30, 60, 90, 120, 150, 180, 1/6]
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
        cell.textLabel?.text = "\(Int(timeIntervals[indexPath.row])) min"
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
    func selectedTimeInterval(minutes: Float)
}
