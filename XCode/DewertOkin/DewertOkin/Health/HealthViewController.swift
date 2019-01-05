//
//  HealthViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 28.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit

private let recommendationsLabel = "recommendationsLabel"
private let stepsLabel = "stepsLabel"

class HealthViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Health"

        self.collectionView!.register(RecommendationsLabelCell.self, forCellWithReuseIdentifier: recommendationsLabel)
        self.collectionView!.register(StepsViewCell.self, forCellWithReuseIdentifier: stepsLabel)

        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        Health.shared.getLastDaysStepsInHourIntervals { resultsArray in
            print(resultsArray)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 2
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
        default: return UICollectionViewCell()
        }
       return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
