//
//  ViewController.swift
//  Puzzle 15
//
//  Created by Vinitha Vijayan on 2/22/18.
//  Copyright © 2018 Vinitha Vijayan. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var finalStatusLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var movesCount = 0
    var timer: Timer?
    var startTime: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.prepareUI()
        DataManager.intstance.prepareDefaultData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 0.55 * screenWidth/CGFloat(kSize), height:  0.55 * screenWidth/CGFloat(kSize))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    //CollectionViewDataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DataManager.intstance.getData().count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.intstance.getData()[section].count
    }
    
    //CollectionViewDelegate Methods
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! Cell
        let data = DataManager.intstance.getData()[indexPath.section][indexPath.row]
        cell.setupCell(data: data, row: indexPath.section)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleMove(row: indexPath.section, column: indexPath.row)
    }
    
    func showDefaultData() {
        collectionView.reloadData()
    }
    
    func handleMove(row: Int, column: Int) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            startTime = NSDate()
        }
        
        if DataManager.intstance.isMoveSuccess(row: row, column: column) {
            collectionView.reloadData()
            movesCount += 1
            self.prepareUI()
        }
        
        if DataManager.intstance.isGameOver() {
            finalStatusLabel.text = "You Win"
            timer?.invalidate()
            timer = nil
            movesCount = 0
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(UInt64(10) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { () -> Void in
                self.finalStatusLabel.text = ""
                DataManager.intstance.prepareDefaultData()
                self.collectionView.reloadData()
                self.startTime = NSDate()
                self.updateTimer()
                self.prepareUI()
            }
        }
    }
    
    @IBAction func shuffleItems(_ sender: Any) {
        DataManager.intstance.shuffleData()
        self.collectionView.reloadData()
        self.movesCount = 0
        self.startTime = NSDate()
        self.timer?.invalidate()
        self.timer = nil
        self.updateTimer()
        self.prepareUI()
    }
    
    func prepareUI() {
        self.statusLabel.text = "Moves: \(movesCount)"
        self.finalStatusLabel.text = ""
    }
    
    @objc public func updateTimer() {
        if let time = startTime {
            let calendar = NSCalendar.current
           let dateComponents = calendar.dateComponents([.second], from: time as Date)
            self.timeLabel.text = "Time : \(dateComponents.second ?? 0)"
        } else {
           self.timeLabel.text = "Time : 0"
        }
        
         self.timeLabel.text = ""
    }
}
