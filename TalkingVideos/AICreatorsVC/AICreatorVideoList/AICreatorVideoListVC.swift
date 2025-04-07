import UIKit
import AuthenticationServices
import SDWebImage

class CharacterCell: UICollectionViewCell {
    static let identifier = "CharacterCell"
    var viewModel: AICreatorVideoViewModel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
//    func configure(with thumbnail: Thumbnail) {
//        nameLabel.text = "Video"
//        loadImage(from: thumbnail.imageURL)
//    }
    
   
    
//    func configure(with thumbnail: Thumbnail, creatorName: String) {
//        let authService = AuthService()
//        viewModel = AICreatorVideoViewModel(authService: authService)
//        
//           nameLabel.text = creatorName
//        nameLabel.textColor = viewModel.randomColor()
//           loadImage(from: thumbnail.imageURL)
//       }
    
    func configure(with model: VideoDetailModel) {
        nameLabel.text = model.creatorName
           nameLabel.textColor = model.color
           imageView.image = nil // Prevent flickering

           //loadImage(from: model.thumbnail.imageURL)
        
        // Use SDWebImage for async image loading and caching
           if let url = URL(string: model.thumbnail.imageURL) {
               imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
           } else {
               imageView.image = UIImage(named: "placeholder")
           }
        
        
        }
    
//    private func loadImage(from urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        
//        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
//            guard let self = self, let data = data else { return }
//            DispatchQueue.main.async {
//                self.imageView.image = UIImage(data: data)
//            }
//        }.resume()
//    }
    
    
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            self.imageView.image = UIImage(named: "placeholder")
            return
        }

        // Cancel previous task if needed (not shown), or assign a tag for checking reuse
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let data = data {
                    self.imageView.image = UIImage(data: data)
                } else {
                    self.imageView.image = UIImage(named: "placeholder")
                }
            }
        }.resume()
    }
}

class AICreatorVideoListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: AICreatorVideoViewModel!
    var thumbnails: [Thumbnail] = []

    let spaceBetweenCells: CGFloat = 2.0
    let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.navigationItem.hidesBackButton = true

        let authService = AuthService()
        viewModel = AICreatorVideoViewModel(authService: authService)

        DispatchQueue.main.async {
                  CustomLoader.shared.showLoader(in: self)
            self.getTheListOfVideoApi()
              }
        
    }

    func getTheListOfVideoApi() {
        
        
            viewModel.getTheVideoList { [weak self] success in
                guard let self = self else { return }
                
                if success {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } else {
                    print("Failed to fetch video list")
                }
            }
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return viewModel.thumbnails.count
        return viewModel.videoDetails.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else {
//                   fatalError("Unable to dequeue CharacterCell")
//               }
//               
//               let thumbnail = viewModel.thumbnails[indexPath.row]
//              // cell.configure(with: thumbnail)
//        
//        let creatorName = indexPath.row < viewModel.supportedCreators.count ? viewModel.supportedCreators[indexPath.row] : "Unknown"
//
//               cell.configure(with: thumbnail, creatorName: creatorName)
        
        
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else {
                return UICollectionViewCell()
            }
        
//        // Ensure we're accessing a valid model
//        guard indexPath.row < viewModel.videoDetails.count else {
//            print("Invalid index: \(indexPath.row)")
//            return cell
//        }
//
//            let model = viewModel.createModel(at: indexPath.row)
//            cell.configure(with: model)
//            return cell
        
        
        guard indexPath.row < viewModel.videoDetails.count else {
               print("Invalid index: \(indexPath.row)")
               return cell
           }

           let model = viewModel.videoDetails[indexPath.row]
           cell.configure(with: model)
        

               return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let totalSpace = spaceBetweenCells * (itemsPerRow - 1) + sectionInsets.left + sectionInsets.right
        let width = (collectionView.bounds.width - totalSpace) / itemsPerRow
        let height = width * 1.4
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

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard indexPath.row < viewModel.thumbnails.count,
//              indexPath.row < viewModel.supportedCreators.count else {
//            print("Index out of range at row: \(indexPath.row)")
//            return
//        }
//        
//        // Create model and pass it to the next VC
//        let selectedModel = viewModel.createModel(at: indexPath.row)
//        
//        // Ensure storyboard and ViewController instantiation is valid
//        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "AICreatorContinueVC") as? AICreatorContinueVC else {
//            print("Failed to instantiate AICreatorContinueVC")
//            return
//        }
//        
//        detailVC.videoModel = selectedModel
//        navigationController?.pushViewController(detailVC, animated: true)
//    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Safely get the selected model
        guard indexPath.row < viewModel.videoDetails.count else {
            print("Index out of range at row: \(indexPath.row)")
            return
        }

        let selectedModel = viewModel.videoDetails[indexPath.row]

        // Instantiate the detail view controller
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "AICreatorContinueVC") as? AICreatorContinueVC else {
            print("Failed to instantiate AICreatorContinueVC")
            return
        }

        detailVC.videoModel = selectedModel
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func back_BtnAcn(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
}

