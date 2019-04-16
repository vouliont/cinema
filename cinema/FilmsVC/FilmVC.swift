//
//  Film.swift
//  cinema
//
//  Created by Владислав on 2/25/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit
import Alamofire

class FilmVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var filmNameLabel: UILabel!
    @IBOutlet var filmGenresLabel: UILabel!
    @IBOutlet var filmDirectorLabel: UILabel!
    @IBOutlet var filmDurationLabel: UILabel!
    @IBOutlet var filmImageView: BorderedImageView!
    @IBOutlet var filmDescriptionLabel: UILabel!
    
    @IBOutlet var sessionsCollectionView: UICollectionView!
    @IBOutlet var sessionsCollectionViewHeight: NSLayoutConstraint!
    
    var getFilmRequest: Alamofire.DataRequest?
    var getSessionsRequest: Alamofire.DataRequest?
    
    var filmId: Int!
    var cinemaId: Int?
    var partsOfDay: [PartsOfDay]?
    var sessionsHeaders: [String] = []
    var sessionsData: [[Double]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getFilmRequest = Requests.instance.getFilm(filmId: filmId, completion: { success, film in
            if !success { return }
            
            self.setUpView(film: film!)
        })
        
        getSessionsRequest = Requests.instance.getSessions(filmId: filmId, cinemaId: cinemaId, partsOfDay: partsOfDay ?? [], completion: { success, sessionsHeaders, sessionsData in
            if !success { return }
            
            self.sessionsHeaders = sessionsHeaders!
            self.sessionsData = sessionsData!
            
            self.sessionsCollectionView.reloadData()
            self.sessionsCollectionView.sizeToFit()
            self.sessionsCollectionViewHeight.constant = self.sessionsCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getFilmRequest?.cancel()
    }
    
    func setUpView(film: [String: Any]) {
        filmNameLabel.text = film["name"] as? String
        filmGenresLabel.text = (film["genres"] as! [String]).joined(separator: ", ")
        filmDirectorLabel.text = film["director"] as? String
        filmDurationLabel.text = "\(film["duration"] as? Int ?? 0) мин."
        filmDescriptionLabel.text = film["description"] as? String
    }
    
    // UICollectionViewDelegate, UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sessionsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sessionsHeaderView", for: indexPath) as? SessionsHeaderView else { fatalError() }
            let headerTitle = sessionsHeaders[indexPath.section]
            headerView.sessionsHeaderLabel.text = headerTitle
            return headerView
        default:
            assert(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessionsData[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sessionCell", for: indexPath) as! SessionCell
        
        cell.setUpCell(time: sessionsData[indexPath.section][indexPath.row])
        
        return cell
    }

}

class SessionCell: UICollectionViewCell {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    func setUpCell(time: Double) {
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: date)
        
        let now = Date()
        let calendar = Calendar.current
        let todayDate = calendar.dateComponents([.day], from: now).day!
        let filmDate = calendar.dateComponents([.day], from: date).day!
        
        switch (filmDate - todayDate) {
        case 0:
            dateLabel.text = "Сегодня"
        case 1:
            dateLabel.text = "Завтра"
        default:
            dateFormatter.dateFormat = "dd.MM"
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        timeLabel.text = timeString
    }
}
