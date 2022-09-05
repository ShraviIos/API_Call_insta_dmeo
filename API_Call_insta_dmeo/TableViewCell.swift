

import UIKit

class TableViewCell: UITableViewCell {


    @IBOutlet var herosimg: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnAdd: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code    }
        func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    }
}
