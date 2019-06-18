//
//  RepositoriesTableViewController.swift
//  GithubRepositoriesApp
//
//  Created by Bar kozlovski on 10/06/2019.
//  Copyright © 2019 Bar kozlovski. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class RepositoriesTableViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    

    //MARK: Variables
    
    @IBOutlet weak var repositoriesTableView: UITableView!
    var refresher: UIRefreshControl!
    var repositoriesList = [Repository]()
    var pageValues = Page()
    
    
    
    
    //MARK: viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create the url and send the request and create the refresher
        
        let urlObj = createUrl(page: pageValues.currentPage)
        createRefresher()
        getRepositoriesFromGithub(url:urlObj)
    }
    

    
    
    
    //MARK: Refresher
    
    
    
    //Create the UIRefreshControl and define the func populate
    
    func createRefresher(){
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(self.populate), for: UIControl.Event.valueChanged)
        repositoriesTableView.addSubview(refresher)
    }
    
    //Func for refreshing the List and delete all the unupdated list
    
    @objc func populate()
    {
        repositoriesList.removeAll(keepingCapacity: true)
        
        pageValues.currentPage = 1
        pageValues.nextPage = 1
        pageValues.lastPage = 2
        
        let urlObj = createUrl(page: pageValues.currentPage)
        getRepositoriesFromGithub(url:urlObj)
        DispatchQueue.main.async {
            self.repositoriesTableView.reloadData()
        }
        refresher.endRefreshing()
    }
    
     //MARK:  API Request's and Parsing
    
    func createUrl(page:Int) -> URL{
        let api = "https://api.github.com"
        let endPoint = "/search/repositories?sort=stars&q=language:&order=desc&per_page=30&page=\(page)"
        let url = URL(string: api + endPoint)
        return url!
    }
    
    //Get repositories from Github using Alamofire library and send the info for parsing
    
    func getRepositoriesFromGithub(url:URL){
        if pageValues.nextPage != pageValues.lastPage {
            Alamofire.request(url).responseJSON { response in
                
                if let headers = response.response?.allHeaderFields as? [String: String]{
                    let header = headers["Link"]
                    self.headerParsingConverter(header: header!)}
                
                if response.result.value != nil{
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    DispatchQueue.main.async {
                        self.jsonParsing(json: swiftyJsonVar)
                        self.repositoriesTableView.reloadData()
                    }}}}
        
    }
    
    
    // Bring the next data by nextInt value
    
    func nextGetRequest() {
        let url = createUrl(page: pageValues.nextPage)
        getRepositoriesFromGithub(url:url)
    }
    
    
    //Take the heater form the Get request and parse them for using in the next and last URL's
    
    func headerParsingConverter(header:String){
        
        let linkHeaderGithub = header
        let links = linkHeaderGithub.components(separatedBy: ",")
        var headerDictionary: [String: String] = [:]
        links.forEach({
            let components = $0.components(separatedBy:"; ")
            let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            headerDictionary[components[1]] = cleanPath
        })
        let nextPagePath = headerDictionary["rel=\"next\""]!
        var lastPagePath = headerDictionary["rel=\"last\""]!
        let tempString = lastPagePath.suffix(lastPagePath.count-2)
        lastPagePath = String(tempString)
        var nextArray = nextPagePath.components(separatedBy:"&page=")
        var lastArray = lastPagePath.components(separatedBy:"&page=")
        
        pageValues.nextPage = Int(nextArray[1])!
        pageValues.lastPage = Int(lastArray[1])!
        
        print("Last page:\(pageValues.lastPage)")
        print("Next page:\(pageValues.nextPage)")
    }
    
    
    //jsonParsing to convert all the data and put him inside the repositories list
    
    func jsonParsing(json:JSON){
        
        let items = json["items"]
        let itemsNum = items.array?.count
        var reposetoriesOnePageCounter = 0
        while reposetoriesOnePageCounter != itemsNum {
            let repos = Repository()
            repos.avatar_url = items[reposetoriesOnePageCounter]["owner"]["avatar_url"].url!
            repos.stargazers_count =  items[reposetoriesOnePageCounter]["stargazers_count"].intValue
            repos.id = items[reposetoriesOnePageCounter]["id"].intValue
            repos.full_name = items[reposetoriesOnePageCounter]["full_name"].stringValue
            repos.score = items[reposetoriesOnePageCounter]["score"].doubleValue
            repos.watchers = items[reposetoriesOnePageCounter]["watchers"].intValue
            repos.created_at = items[reposetoriesOnePageCounter]["created_at"].stringValue
            if items[reposetoriesOnePageCounter]["description"].stringValue == ""{
                repos.description = "No description or website provided."}
            else{repos.description = items[reposetoriesOnePageCounter]["description"].stringValue}
            
            //Add all the data to the reposetories list
            
            repositoriesList.append(repos)
            reposetoriesOnePageCounter = reposetoriesOnePageCounter + 1
        }}
    
    
    
    //MARK:  TableView functions
    
    
    
    //Number of rows function
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoriesList.count
    }
    
    
    //The cellForRowAt function puts all the informtion inside all the label and the rounded image
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let repoCell = repositoriesTableView.dequeueReusableCell(withIdentifier: "repoCell") as? RepositoriesTableViewCell else{return UITableViewCell()}
        
        self.rounded(imageToRound: repoCell.ownerImage)
        
        repoCell.ownerAndRepositoryName.text =  repositoriesList[indexPath.row].full_name
        repoCell.descLabel.text = repositoriesList[indexPath.row].description
        repoCell.ranking.text = "\u{2605}" + String(describing:repositoriesList[indexPath.row].stargazers_count)
        repoCell.descLabel.adjustsFontSizeToFitWidth  = true
        repoCell.ownerAndRepositoryName.adjustsFontSizeToFitWidth = true
        
        
        //This part using Kingfisher and put a placeholder image until the image reload or if the url is empty
        
        let url = self.repositoriesList[indexPath.row].avatar_url
        let processor = DownsamplingImageProcessor(size: repoCell.ownerImage.image!.size)
            >> RoundCornerImageProcessor(cornerRadius: 20)
        repoCell.ownerImage.kf.indicatorType = .activity
        repoCell.ownerImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Github"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        return repoCell
    }
    
    
    
    
    
    //Chack if the list is allmost in the end and then call the next func to bring more data
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement = repositoriesList.count - 10
        if indexPath.row == lastElement {
            nextGetRequest()
        }}
    
    
    
    
    //Passing the data to the DetailsViewController when tapping to a cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            
            controller.dataToShow = self.repositoriesList[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }}
    
    
}


