//
//  DoctorCell.swift
//  Music App
//
//  Created by MAC on 12/11/2021.
//

import UIKit

class DoctorCell: UITableViewCell {

    @IBOutlet weak var doctorImage:UIImageView!
    @IBOutlet weak var docName:UILabel!
    @IBOutlet weak var docSpeciality:UILabel!
    @IBOutlet weak var docInfo:UILabel!
    
    var getDoctorList:Doctor? = nil{
        didSet{
            if let getDoctors = getDoctorList{
                DispatchQueue.main.async {
                    self.docName.text = getDoctors.name
                    self.docSpeciality.text = getDoctors.speciality
                    self.docInfo.text = getDoctors.bio
                    //doctor iamge is not working
                    self.doctorImage.image = UIImage(named: getDoctors.profileImageUrl)
                }
            }
        }
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doctorImage.layer.cornerRadius = doctorImage.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
