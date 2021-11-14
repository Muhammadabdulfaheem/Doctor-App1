//
//  PatientViewController.swift
//  Music App
//
//  Created by MAC on 10/11/2021.
//

import UIKit

class PatientViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var getDoctors :[Doctor] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: DoctorCell.self), bundle: .main), forCellReuseIdentifier: String(describing: DoctorCell.self))
        loadDoctors()
    }
    
    func loadDoctors(){

        NetworkingService.shared.getDoctorsList { (result) in
            switch result{
                case .success(let data):
                    self.getDoctors = data
                    print("doctors count \(data)",self.getDoctors.count)
                case .failure(let error):
                    print("not getting the doctor list",error.localizedDescription)
            }
        }
    }
}

extension PatientViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDoctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.configureDoctors(tableView, cellForRowAt: indexPath)
    }
    
    func configureDoctors(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let doctorCell = tableView.dequeueReusableCell(withIdentifier: String(describing: DoctorCell.self)) as? DoctorCell else{
            return UITableViewCell()
        }
        doctorCell.getDoctorList = self.getDoctors[indexPath.row]
        return doctorCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
}
