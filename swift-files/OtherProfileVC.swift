class OtherProfileVC: UIViewController {

   @IBOutlet weak var backButtonToFriendList: UIButton!
   @IBOutlet weak var profilePictureImage: UIImageView!
   @IBOutlet weak var addFriend: UIButton!

   @IBOutlet weak var userNameLabel: UILabel!
   var userNameLabelFromFriendList: String?
   var uidFromFriendList: String?
   var userToShow: User = User()

   @IBAction func addFriendAction(_ sender: UIButton) {

       //Check if somebody is a friend first
       let friendRequestsRef = firestoreRef.collection("friendRequests").document(userToShow.uid).collection("userFriendRequests").document()
       friendRequestsRef.setData(["receiverUid":userToShow.uid, "receiverUsername": userToShow.username, "senderUid": globalUser.uid, "senderUsername": globalUser.username], merge: true)

   }

   @IBAction func backButtonToFriendListAction(_ sender: UIButton) {
       self.performSegue(withIdentifier: "backToFriendList", sender: self)

   }

   override func viewDidLoad() {
       super.viewDidLoad()

       self.makingRoundedImageProfileWithRoundedBorder()

   }

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       userToShow.uid = uidFromFriendList!
       userToShow.username = userNameLabelFromFriendList
       self.userNameLabel.text = userToShow.username

       let imageView: UIImageView = self.profilePictureImage

       userToShow.getUser() { (isSuccess) in

           if (isSuccess) {
               // set image if success
               imageView.sd_setImage(with: URL(string: self.userToShow.photoURL ?? "")) { (image, error, cache, urls) in
                   if (error != nil) {
                       imageView.image = UIImage(named: "reeal")
                   } else {
                       imageView.image = image
                   }
               }


           } else {
               imageView.image = UIImage(named: "reeal")
           }

       }

   }

   private func makingRoundedImageProfileWithRoundedBorder() {

       self.profilePictureImage.layer.cornerRadius = self.profilePictureImage.frame.height / 2

       self.profilePictureImage.clipsToBounds = true

       // Adding a border to the image profile
       self.profilePictureImage.layer.borderWidth = 3.0
       self.profilePictureImage.layer.borderColor = UIColor.white.cgColor;
   }


}