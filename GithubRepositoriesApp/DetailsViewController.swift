//
//  DetailsViewController.swift
//  GithubRepositoriesApp
//
//  Created by Bar kozlovski on 10/06/2019.
//  Copyright © 2019 Bar kozlovski. All rights reserved.
//

import UIKit
import Kingfisher
class DetailsViewController: UIViewController {
    
     //MARK:  Variables

    var dataToShow = Repository()
    
    
    @IBOutlet weak var imageOfOwner: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    
    //MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createdAtCasting()
        dataToLabels()
    }
    
    
    //MARK: Show the data and Casting
    
    
    
    //Change the created date to DD/MM/YY
    
    func createdAtCasting(){
        var date = dataToShow.created_at.prefix(10).split(separator: "-")
        dataToShow.created_at = "\(date[2])-\(date[1])-\(date[0])"
    }
    
    
    //Puts all the data in the label's and UIImage
    
    func dataToLabels(){
        
      
       scoreLabel.attributedText = changeSize(start: "Score: ", data:String(describing: dataToShow.score.rounded()) , size: 25)
        watchersLabel.attributedText = changeSize(start: "\u{1F441} Watch: ", data:String(describing: dataToShow.watchers) , size: 25)
         createdAtLabel.attributedText = changeSize(start: "Created at: ", data:String(describing: dataToShow.created_at) , size: 25)
        
        rounded(imageToRound: imageOfOwner)
        self.imageOfOwner.kf.setImage(with: self.dataToShow.avatar_url)
       
        
        
    }

}

 //MARK:  Design extension

extension UIViewController{
    
    
    //Change the size of part of the label
    
    func changeSize(start:String,data:String,size:CGFloat) -> NSMutableAttributedString
    {
        
        let startText = start
        let StartString = NSMutableAttributedString(string:startText)
        
        let dataText  = data
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize:size)]
        let attributedString = NSMutableAttributedString(string:dataText, attributes:attrs)
        
        StartString.append(attributedString)
        return StartString
        
    }
    
    //rounded UIImage
    
    func rounded(imageToRound:UIImageView){
        imageToRound.layer.borderWidth = 1
        imageToRound.layer.masksToBounds = false
        imageToRound.layer.borderColor = UIColor.black.cgColor
        imageToRound.layer.cornerRadius = imageToRound.frame.height/2
        imageToRound.clipsToBounds = true
        
    }
    
    
    
}



