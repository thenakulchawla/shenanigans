import UIKit
import Firebase
import FirebaseUI
import AVKit

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout { // //     @IBOutlet weak var profileCollectionView: UICollectionView!

   // MARK: - declarations
   @IBOutlet weak var profileImageView: UIImageView!
   @IBOutlet weak var profilePickerButton: UIButton!

   @IBOutlet weak var userNameLabel: UILabel!

   @IBOutlet weak var friendsCountButton: UIButton!
   @IBOutlet weak var reelsCountLabel: UILabel!


   //TODO: Move to firebaseAuthManager
   var handle: AuthStateDidChangeListenerHandle?


   // MARK: - CollectionView

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 20
//        return userReels.count
   }


   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

//        print("Enter ProfileVC collectionView cellForItemAt")

       // get a reference to our storyboard cell
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPostCell", for: indexPath as IndexPath) as! UserPostCell

       // TODO: change to cloud URL after fixing UI
       let postUrlString = Bundle.main.path(forResource: "hello", ofType: "mp4")
       let postUrl = URL(fileURLWithPath: (postUrlString  ?? ""))

//        let postUrlString = userReels[indexPath.item].reelUrl
//        let postUrl = URL(string: postUrlString)!


       let avPlayer = AVPlayer(url: postUrl)


//        Setting up cell stuff
//        cell.layer.borderColor = UIColor.black.cgColor
       cell.layer.borderWidth = 0
       cell.layer.borderColor = UIColor.clear.cgColor
       cell.layer.cornerRadius = 8



       let screenSize: CGRect = profileCollectionView.bounds
       let screenWidth = screenSize.width
       cell.playerView.frame.size = CGSize(width: (screenWidth/3.0), height: ( screenWidth/3.0) * 1.5  )
       //        Setting cell's player
       cell.playerView.playerLayer.player = avPlayer
       cell.playerView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

//        print("Exit ProfileVC collectionView cellForItemAt")

       return cell

   }

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


       if let cell = collectionView.cellForItem(at: indexPath) as? UserPostCell {
           cell.playerView.player?.play()
       }

       //TODO: Change so this is only executed when the user is inline.
//        cell.playerView.player?.play()

       // handle tap events
       print("You selected cell #\(indexPath.item)!")
   }

   // MARK: - CollectionViewFlowLayout
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let screenSize: CGRect = profileCollectionView.bounds

       let screenWidth = screenSize.width
       return CGSize(width: (screenWidth/3.0), height: (screenWidth/3.0) * 1.5);

//        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
   }

   func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 0
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 0

   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets.zero
   }



   // MARK: - ImagePicker
   let imagePicker = UIImagePickerController()

   @IBAction func profilePickerAction(_ profilePickerButton: UIButton) {

       imagePicker.allowsEditing = true
       imagePicker.sourceType = .photoLibrary

       present(imagePicker, animated: true, completion: nil)
   }

   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

       if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           profileImageView.contentMode = .scaleAspectFit
           profileImageView.image = pickedImage
       }

       dismiss(animated: true, completion: nil)

       if let data = profileImageView.image?.jpegData(compressionQuality: 0.1) {
           let number = Int.random(in: 0 ... 1000000) as NSNumber
           FirebaseStorageManager().uploadImageData(data: data, serverFileName: number.stringValue) { (isSuccess, url) in
               print("uploadImageData: \(isSuccess), \(url as Any)")

           }
       }

   }

   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true, completion: nil)
   }

   private func makingRoundedImageProfileWithRoundedBorder() {

       self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2

       self.profileImageView.clipsToBounds = true

       // Adding a border to the image profile
       self.profileImageView.layer.borderWidth = 3.0
       self.profileImageView.layer.borderColor = UIColor.white.cgColor;
   }


   // MARK: - ViewController overrides
   override func viewDidLoad() {
       super.viewDidLoad()

       imagePicker.delegate = self

       self.makingRoundedImageProfileWithRoundedBorder()

       let imageView: UIImageView = self.profileImageView

       imageView.sd_setImage(with: URL(string: globalUser.photoURL ?? "")) { (image, error, cache, urls) in
           if (error != nil) {
               imageView.image = UIImage(named: "reeal")
           } else {
               imageView.image = image
           }
       }

   }

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)

       globalUser.getUserReels() { (isSuccess) in

           if (isSuccess) {
               self.profileCollectionView.reloadData()

           }
       }


       globalUser.getUser() {(isSuccess) in

           if (isSuccess) {

               self.userNameLabel.text = globalUser.username
               self.reelsCountLabel.text = String(globalUser.reelsCount)
               self.friendsCountButton.setTitle(String(globalUser.friendsCount), for: .normal)

           }

       }

       handle = authRef.addStateDidChangeListener { (auth, user) in
           // [START_EXCLUDE]
           let imageView: UIImageView = self.profileImageView
           //            imageView.sd_setImage(with: URL(string: (globalUser.photoURL)!), placeholderImage: UIImage(named: "reeal") )

           imageView.sd_setImage(with: URL(string: globalUser.photoURL ?? "")) { (image, error, cache, urls) in
               if (error != nil) {
                   imageView.image = UIImage(named: "reeal")
               } else {
                   imageView.image = image
               }

           }

           // [END_EXCLUDE]
       }

   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       // [START remove_auth_listener]
       authRef.removeStateDidChangeListener(handle!)
       // [END remove_auth_listener]
   }

   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
   }

   // MARK: - Navigation

   @IBAction func unwindToProfile(segue: UIStoryboardSegue) {

   }

}