
import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var dataCount:Int = 10
    var oldDataCount: Int = 10

    var arrHeroes = [HeroStats]()
    var dataheroes = [HeroStats]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadjson{}
    }
  @objc func addData(){
      self.dataCount += 10
      for i in oldDataCount...dataCount - 1{
          if i < dataCount {
              self.dataheroes.append(arrHeroes[i])
              
          }
          self.oldDataCount = self.dataCount
          
      }
      self.tableView.reloadData()
      let index = IndexPath(row: dataCount - 11, section: 0)
      self.tableView.scrollToRow(at: index, at: .top, animated: true)
        
    }
    
    func downloadjson(completed:@escaping () -> ()) {
        let url = URL(string: "https://api.opendota.com/api/heroStats")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil{
                do {
                    self.arrHeroes = try JSONDecoder().decode([HeroStats].self, from: data!)
                    for i in 0...self.dataCount - 1 {
                        if i < self.dataCount {
                            self.dataheroes.append(self.arrHeroes[i])
                        }
                    }
                    DispatchQueue.main.async {
                        completed()
                        self.tableView.reloadData()
                    }
                }
                catch{
                    let alrt = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .destructive)
                    alrt.addAction(action)
                    self.present(alrt, animated: true)
                }
            }
        } .resume()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataheroes.count
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)as! TableViewCell
        cell.lblName.text = dataheroes[indexPath.row].localized_name
    
        if indexPath.row == dataheroes.count - 1  {
            cell.btnAdd.isHidden = false
            cell.lblName.isHidden = true
            cell.herosimg.isHidden = true
            
        }else{
            cell.btnAdd.isHidden = true
            cell.lblName.isHidden = false
            cell.herosimg.isHidden = false
            
        }
        cell.selectionStyle = .none
        cell.btnAdd.addTarget(self, action: #selector(addData), for: .touchUpInside)
       guard let url = URL(string: "https://api.opendota.com" + dataheroes[indexPath.row].img)
        else {
            return UITableViewCell()
        }
        let processor = DownsamplingImageProcessor(size: cell.herosimg.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        cell.herosimg.kf.indicatorType = .activity
        cell.herosimg.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
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
            cell.herosimg.contentMode = .scaleAspectFit
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == dataCount - 1{
           return 30
        }else {
            return self.view.bounds.height / 3
            }
        }
    
    
}

