import UIKit

class CharacterCell: UICollectionViewCell {
    static let identifier = "CharacterCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stylesLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!

    func configure(with character: CharacterModel) {
        imageView.image = UIImage(named: character.imageName)
        nameLabel.text = character.name
        stylesLabel.text = "\(character.styleCount) styles"
    }
}

struct CharacterModel {
    let imageName: String
    let name: String
    let styleCount: Int
}

class AICreatorVideoListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    let spaceBetweenCells: CGFloat = 2.0 // Very minimal spacing
        let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom:20, right: 20) // Minimal section insets


    private let characters: [CharacterModel] = [
        CharacterModel(imageName: "jason", name: "Jason", styleCount: 5),
        CharacterModel(imageName: "mia", name: "Mia", styleCount: 5),
        CharacterModel(imageName: "grace", name: "Grace", styleCount: 5),
        CharacterModel(imageName: "isabella", name: "Isabella", styleCount: 5)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.navigationItem.hidesBackButton = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10//characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else {
            fatalError("Unable to dequeue CharacterCell")
        }
       // cell.configure(with: characters[indexPath.row])
      //  cell.contentView.backgroundColor = .red // Or any color
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let itemsPerRow: CGFloat = 2
            let totalSpace = spaceBetweenCells * (itemsPerRow - 1) + sectionInsets.left + sectionInsets.right
            let width = (collectionView.bounds.width - totalSpace) / itemsPerRow
            let height = width * 1.4 // Adjust the height ratio as needed
            return CGSize(width: width, height: height)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return spaceBetweenCells
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return spaceBetweenCells
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("Selected: \(characters[indexPath.row].name)")
        }
    

}

