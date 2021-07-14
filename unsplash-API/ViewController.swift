//
//  ViewController.swift
//  unsplash-API
//
//  Created by Ike Chukz on 7/13/21.
//

import UIKit

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}


struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    //let regular: String
    let regular: String
}

private let reuseIdentifier = "cell"

class ViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    
    //let url = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=office&client_id=GlUv0ULAiVxudLTp1PPNos4VHZ_TDXb8wVHiZMlkatI"
    
    let alert = UIAlertController(title: "Error", message: "Check Your Internet Connection", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Error", style: .default, handler: nil)
    
    var results: [Result] = []
    var searchbar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        alert.addAction(alertAction)
        view.addSubview(searchbar)
        searchbar.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
        
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.dataSource = self
        
        //fetchPhoto()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchbar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
        //collectionView?.frame = view.bounds
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        if let text = searchbar.text{
            results = []
            collectionView?.reloadData()
            fetchPhoto(query: text)
            
        }
    }

    func fetchPhoto(query: String){
        
        let url = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(query)&client_id=GlUv0ULAiVxudLTp1PPNos4VHZ_TDXb8wVHiZMlkatI"
        
        guard let url = URL(string: url)else{
            return
        }
        let task = URLSession.shared.dataTask(with:url){[weak self]
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            //print("Got data")
            
            do{
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data) //from json in postman
                
                
                print(jsonResult.results.count)//See the print of the number (30) in the output. This number should be same in the unsplash for the photo
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionView?.reloadData()
                }
            
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let imageURLString = results[indexPath.row].urls.full
        let imageURLString = results[indexPath.row].urls.regular
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath
        )as? ImageCollectionViewCell
        else{
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLString)
        //cell.backgroundColor = .blue
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("This is just test")
         let imgUrl = results[indexPath.row].urls.regular
        
        let vc = storyboard?.instantiateViewController(identifier: "ImageViewController") as! ImageViewController
        vc.config(with: imgUrl)
        
       self.navigationController?.pushViewController(vc, animated: true)
    }
}

