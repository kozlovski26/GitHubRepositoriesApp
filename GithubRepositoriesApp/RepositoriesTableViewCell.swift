//
//  RepositoriesTableViewCell.swift
//  GithubRepositoriesApp
//
//  Created by Bar kozlovski on 10/06/2019.
//  Copyright © 2019 Bar kozlovski. All rights reserved.
//

import UIKit

class RepositoriesTableViewCell: UITableViewCell {
    
    //MARK: Label's and UIImageView
    
    @IBOutlet weak var ranking: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ownerAndRepositoryName: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
