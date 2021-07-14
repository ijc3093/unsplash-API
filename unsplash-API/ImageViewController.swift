//
//  ImageViewController.swift
//  unsplash-API
//
//  Created by Ike Chukz on 7/13/21.
//

import UIKit

class ImageViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    let imageView:UIImageView = {
         let imageView = UIImageView()
        return imageView
        
    }()
    
    let nameLabel:UILabel = {
        let name = UILabel()
        return name
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: 20, width: view.frame.size.width - imageView.frame.origin.x, height: view.frame.size.height-20)
        nameLabel.frame = CGRect(x: 0, y: 200, width: view.frame.size.width - imageView.frame.origin.x, height: view.frame.size.height-20)
    }
    
    func addSubView(){
        imageView.contentMode = .scaleAspectFit
        nameLabel.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        view.addSubview(nameLabel)
    }
    func config(with urlString:String){
        
        guard let url = URL(string: urlString)else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, resp, error) in
            guard let data = data , error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
                
            }
        }
        task.resume()
    }

    
//    func config2(with description:String){
//        
//        guard let description = URL(string: description)else{
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: description) { (data, resp, error) in
//            guard let data = data , error == nil else {
//                return
//            }
//            DispatchQueue.main.async {
//                //let name = UILabel(data: data)
//                self.nameLabel.text = description
//                
//            }
//        }
//        task.resume()
//    }

   

}
