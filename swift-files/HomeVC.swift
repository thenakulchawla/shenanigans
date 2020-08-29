class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var searchButton: UIButton!
//    @IBAction func searchButtonAction(_ sender: UIButton) {
//        self.searchBar.isHidden = false
//    }

   @IBOutlet weak var homeCollectionView: UICollectionView!

   override func viewDidLoad() {
       super.viewDidLoad()

      // Put it in viewWillAppear, create a set of feed keys to see if something doesn't exist only then append to list
       globalUser.getUserFeed() {(isSuccess) in
           if (isSuccess) {
               self.homeCollectionView?.reloadData()
           }
       }

       homeCollectionView.isPagingEnabled = true
   }

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)

//        self.searchBar.isHidden = true

   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)

       for cell in homeCollectionView.visibleCells {
           (cell as! HomePostCell).playerView?.player?.pause()
       }
   }

   // MARK: - CollectionView

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return userFeed.count

   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

       // get a reference to our storyboard cell
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homePostCell", for: indexPath as IndexPath) as! HomePostCell

       // TODO: change to cloud URL after fixing UI
       let postUrlString = Bundle.main.path(forResource: "hello", ofType: "mp4")
       let postUrl = URL(fileURLWithPath: (postUrlString  ?? ""))

//        let postUrlString = userFeed[indexPath.item].reelUrl
//        let postUrl = URL(string: postUrlString)!

       //Video player : hard coded video
       let avPlayer = AVPlayer(url: postUrl)

       // Setting cell and player
       cell.layer.borderWidth = 20
       cell.layer.borderColor = UIColor.clear.cgColor
       cell.layer.cornerRadius = 8
       cell.playerView.playerLayer.player = avPlayer
       cell.playerView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
       cell.userNameLabel.text = "@" + userFeed[indexPath.item].username

       return cell

   }

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

       if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCell {
           cell.playerView.player?.play()
       }

       //TODO: Change so this is only executed when the user is inline.
       // cell.playerView.player?.play()
       // handle tap events
       print("You selected cell #\(indexPath.item)!")

   }


   func scrollViewDidScroll(_ scrollView: UIScrollView) {
       for cell in homeCollectionView.visibleCells {
           (cell as! HomePostCell).playerView?.player?.pause()
       }
   }

   // MARK: - CollectionViewFlowLayout
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets.zero
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: homeCollectionView.bounds.width, height: homeCollectionView.bounds.height)
   }

   func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 0
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 0
   }

   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
   }
}
