//
//  WorkersVC.swift
//  cinema
//
//  Created by Владислав on 4/19/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit
import Alamofire

class WorkersVC: PopupVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var cinemaNameTextField: UITextField!
    @IBOutlet var salaryTextField: UITextField!
    @IBOutlet var workersTableView: UITableView!
    
    var getWorkersRequest: Alamofire.DataRequest?
    
    var selectedWorker: Worker!
    
    var workers: [Worker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addWorkerButtonImage = UIImage(named: "add")
        let addWorkerButton = UIBarButtonItem(image: addWorkerButtonImage, style: .plain, target: self, action: #selector(addUserButtonPressed))
        addWorkerButton.tintColor = #colorLiteral(red: 0.8717461228, green: 0.8868257403, blue: 0.8863963485, alpha: 1)
        self.navigationItem.rightBarButtonItem = addWorkerButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getWorkersRequest?.cancel()
    }

    @IBAction func okButtonPressed(_ sender: Any) {
        let cinemaName = cinemaNameTextField.text ?? ""
        let salary = Int(salaryTextField.text ?? "0")!
        getWorkersRequest = Requests.instance.getWorkers(cinemaName: cinemaName, salary: salary, completion: { (success, workers) in
            self.getWorkersRequest = nil
            if !success { return }
            
            if let workers = workers {
                self.workers = workers
                self.workersTableView.reloadData()
            }
        })
    }
    
    @objc func addUserButtonPressed() {
        performSegue(withIdentifier: "addWorkerSegue", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workerCell", for: indexPath) as! WorkerCell
        let worker = workers[indexPath.row]
        cell.setUpCell(worker: worker)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWorker = workers[indexPath.row]
        performSegue(withIdentifier: "editWorkerSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addWorkerSegue" {
            if let destVC = segue.destination as? AddWorkerVC {
                destVC.rootViewController = self
            }
        } else if segue.identifier == "editWorkerSegue" {
            if let destVC = segue.destination as? EditWorkerVC {
                destVC.phoneNumber = selectedWorker.phoneNumber
            }
        }
    }
}

class WorkerCell: UITableViewCell {
    
    @IBOutlet var workerNameLabel: UILabel!
    @IBOutlet var workerDateLabel: UILabel!
    @IBOutlet var workerSexLabel: UILabel!
    @IBOutlet var workerPhoneNumberLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    
    func setUpCell(worker: Worker) {
        workerNameLabel.text = worker.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = Date(timeIntervalSince1970: Double(worker.date))
        workerDateLabel.text = dateFormatter.string(from: date)
        workerSexLabel.text = worker.sex
        workerPhoneNumberLabel.text = worker.phoneNumber
        positionLabel.text = worker.position
    }
    
}
