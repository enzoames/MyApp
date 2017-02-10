//
//  PhotosViewController.swift
//  myApp
//
//  Created by Enzo Ames on 2/1/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit
import AFNetworking


class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //||||||||||||||||||||||||||||||||
    //|||||||||||VARIABLES||||||||||||
    //||||||||||||||||||||||||||||||||
    
    
    var posts: [NSDictionary] = []
    
    @IBOutlet weak var tableView: UITableView!

    var isMoreDataLoading = false
    
    var currentOffset: Int = 0
    
    //||||||||||||||||||||||||||||||||||||
    //|||||||||||VIEW DID LOAD||||||||||||
    //||||||||||||||||||||||||||||||||||||
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: Selector(("refresh")), for: UIControlEvents.valueChanged)
        
        
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 240;

        
        makeNetworkRequest(refreshControl: refreshControl)

        self.tableView.reloadData()
        
    }
    
    
    //||||||||||
    //||||||||||
    //||||||||||
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //||||||||||||||||||||||||||||||||||||||||
    //|||||||||||MAKE NETWORK REQUEST|||||||||
    //||||||||||||||||||||||||||||||||||||||||
    
    func makeNetworkRequest(refreshControl: UIRefreshControl?)
    {
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(currentOffset)")
        
        let request = URLRequest(url: url!)
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask ( with: request as URLRequest,completionHandler:
        {
            (data, response, error) in
            
            if let data = data
            {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary
                {
                    //print("responseDictionary: \(responseDictionary)")
                        
                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                    // This is how we get the 'response' field
                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                    // This is where you will store the returned array of posts in your posts property
                    self.posts.append(contentsOf: responseFieldDictionary["posts"] as! [NSDictionary])
                    
                    self.currentOffset += 20

                }
                
                self.tableView.reloadData()
                if let refreshControl = refreshControl
                {
                    refreshControl.endRefreshing()
                }
            }
        });
        
        task.resume()
        
    }
    
    
    //||||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||REFRESH CONTROL ACTION|||||||||||
    //||||||||||||||||||||||||||||||||||||||||||||
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl)
    {
        makeNetworkRequest(refreshControl: refreshControl)
    }
    
    
    //||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||TABLEVIEW FUNCTIONS||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        let post = posts[indexPath.row]
        
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        {
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            
            
            if let imageUrl = URL(string: imageUrlString!)
            {
                // URL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
                cell.posterView.setImageWith(imageUrl)
                
            }
            else
            {
                // URL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }
            
        }
        else
        {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
        
        // Configure YourCustomCell using the outlets that you've defined.
        
        return cell
    }
    
    
    //deselects the element that was previously selected
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
    
    
    //||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||PREPARE FOR SEGUE||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let cell2 = sender as! PhotoCell
        
        //let pp = posts[indexPath!.row]
        
        let vc = segue.destination as! PhotoDetailsViewController
        
        vc.photo = cell2.posterView.image
        
        
        //detailsViewController.moviesDict = singleMovie //moviesDict is originally from detailsViewController
    }
    
    
    
    
    //|||||||||||||||||||||||||||||||||||||||
    //|||||||||||SCROLL FUNCTION|||||||||||||
    //|||||||||||||||||||||||||||||||||||||||
    
    func loadMoreData() {
        
        // ... Create the NSURLRequest (myRequest) ...
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(currentOffset)")
        
        let request = URLRequest(url: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue:OperationQueue.main)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler:
            {
                (data, response, error) in
                
                // Update flag
                self.isMoreDataLoading = false
                
                // ... Use the new data to update the data source ...
                if let data = data
                {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary
                    {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        //append the newly fetched data to the posts dictionary
                        self.posts.append(contentsOf: responseFieldDictionary["posts"] as! [NSDictionary])
                         self.currentOffset += 20
                    }
                }
                
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                
        });
        task.resume()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        // Handle scroll behavior here
        if (!isMoreDataLoading)
        {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging)
            {
                isMoreDataLoading = true
                // Code to load more results
                loadMoreData()
            }
        }
    }

    
    
    
    
    
    
    
    

}









