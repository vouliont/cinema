//
//  FilmsVC.swift
//  cinema
//
//  Created by Владислав on 2/25/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit
import Alamofire

class FilmsListVC: PopupVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var filmsTableView: UITableView!
    
    private enum SegueNames: String {
        case showFilmSegue = "showFilmSegue"
    }
    
    var cinemaId: Int?
    var partsOfDay: [PartsOfDay]?
    
    private var getGenresRequest: Alamofire.DataRequest?
    private var getFilmsRequest: Alamofire.DataRequest?
    
    private var films: [Film] = []
    private let filmsFilterHeaders = [
        "Жанры",
        "Часть дня"
    ]
    private var filmsFilterCells: [FilterCell] = []
    private var filmsFilterVC: FilterVC!
    private var selectedFilm: Film?
    
    private var filterButton: UIBarButtonItem!
    
    private let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterButtonImg = UIImage(named: "filter")
        filterButton = UIBarButtonItem(image: filterButtonImg, style: .plain, target: self, action: #selector(openFilterButtonPressed))
        filterButton.tintColor = #colorLiteral(red: 0.8717461228, green: 0.8868257403, blue: 0.8863963485, alpha: 1)
        
        getFilmsRequest = Requests.instance.getFilms(cinemaId: cinemaId, completion: { success, films in
            if success {
                self.films = films!
                self.filmsTableView.reloadData()
            }
            self.getFilmsRequest = nil
        })
        
        filmsFilterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "filterVC") as? FilterVC
        filmsFilterVC.didMove(toParent: self)
        self.addChild(filmsFilterVC)
        
        getGenresRequest = Requests.instance.getGenres(completion: { success, genres in
            if !success { return }
            
            self.filmsFilterCells = [
                FilterCell(identifier: "selectCell", items: genres!.map({ genre -> SelectFilter in
                    return SelectFilter(data: genre, typeObjects: .Genre);
                })),
                FilterCell(identifier: "selectCell", items: PartsOfDay.allCases.map({ partOfDay -> SelectFilter in
                    return SelectFilter(data: partOfDay, typeObjects: .PartOfDay)
                }))
            ]
            self.filmsFilterVC.headers = self.filmsFilterHeaders
            self.filmsFilterVC.data = self.filmsFilterCells
            self.filmsFilterVC.filtersTableView.reloadData()
            self.filmsFilterVC.applyButton.addTarget(self, action: #selector(self.applyFiltersButtonPressed), for: .touchUpInside)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.parent is CinemaFilmsVC {
            tabBarController?.navigationItem.rightBarButtonItem = filterButton
            tabBarController?.navigationItem.title = "Фильмы"
        } else {
            self.navigationItem.rightBarButtonItem = filterButton
        }
        
        filmsFilterVC.view.bounds = self.view.bounds
        filmsFilterVC.view.frame.origin.x = screenSize.width
        filmsFilterVC.view.frame.origin.y = 0
        self.view.addSubview(filmsFilterVC.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        filmsFilterVC.toggleFilter(false)
        getFilmsRequest?.cancel()
        getGenresRequest?.cancel()
    }
    
    @objc func openFilterButtonPressed() {
        filmsFilterVC.toggleFilter()
    }
    
    @objc func applyFiltersButtonPressed() {
        self.view.endEditing(true)
        
        var genres: [Genre] = []
        filmsFilterCells[0].items.forEach { genre in
            guard let genre = genre as? SelectFilter else { return }
            if genre.isOn {
                genres.append(genre.data as! Genre)
            }
        }
        
        var partsOfDay: [PartsOfDay] = []
        filmsFilterCells[1].items.forEach { partOfDay in
            guard let partOfDay = partOfDay as? SelectFilter else { return }
            if partOfDay.isOn {
                partsOfDay.append(partOfDay.data as! PartsOfDay)
            }
        }
        self.partsOfDay = partsOfDay
        
        getFilmsRequest = Requests.instance.getFilms(cinemaId: cinemaId, genres: genres, partsOfDay: partsOfDay, completion: { success, films in
            self.films = films ?? []
            self.filmsTableView.reloadData()
            self.filmsFilterVC.toggleFilter(false)
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as! FilmCell
        
        let film = films[indexPath.row]
        cell.setupCell(film: film)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilm = films[indexPath.row]
        performSegue(withIdentifier: SegueNames.showFilmSegue.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueNames.showFilmSegue.rawValue {
            if let filmVC = segue.destination as? FilmVC {
                filmVC.filmId = selectedFilm!.id
                filmVC.cinemaId = cinemaId
                filmVC.partsOfDay = partsOfDay
            }
        }
    }
    
}

class FilmCell: UITableViewCell {
    
    @IBOutlet var filmImage: UIImageView!
    @IBOutlet var filmName: UILabel!
    @IBOutlet var filmGenres: UILabel!
    @IBOutlet var filmFormats: UILabel!
    
    func setupCell(film: Film) {
        filmName.text = film.name
        filmGenres.text = film.genres.map({ genre -> String in
            return genre.name
        }).joined(separator: ", ")
        filmFormats.text = film.formats.map({ format -> String in
            return format.name
        }).joined(separator: ", ")
        filmImage.image = UIImage(named: "logo")
    }
    
}
