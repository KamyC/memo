
import UIKit

class BookListTableViewCell: UITableViewCell {

    @IBOutlet var bookNameLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bookNameLabel.font = UIFont(name: "03SmartFontUI", size: 22)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
