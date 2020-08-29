class FriendsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

   override func viewDidLoad() {}
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)

       userFriends.removeAll()
       globalUser.getFriends() { (isSuccess) in
           if (isSuccess) {
               self.friendsTableView.reloadData()
           }

       }
   }

   @IBOutlet weak var backButton: UIButton!
   @IBOutlet weak var friendsTableView: UITableView!

   @IBAction func backToProfile(_ sender: UIButton) {
       self.performSegue(withIdentifier: "backToProfile", sender: self)
   }

   var otherProfileUserName: String!
   var otherProfileUid: String!

   // MARK: - Table View Conform Methods here
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return userFriends.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       let cell = tableView.dequeueReusableCell(withIdentifier: "FriendViewCell", for: indexPath) as! FriendViewCell

       let row = indexPath.row
       cell.textLabel?.text = userFriends[row].username

       return cell
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


       otherProfileUserName = userFriends[indexPath.row].username
       otherProfileUid = userFriends[indexPath.row].uid

       self.performSegue(withIdentifier: "otherProfileFromFriendList", sender: self)

   }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?){
       if let destination = segue.destination as? OtherProfileVC {
           destination.userNameLabelFromFriendList = otherProfileUserName
           destination.uidFromFriendList = otherProfileUid
       }

//        if (segue.identifier == "otherProfileFromFriendList") {
           // initialize new view controller and cast it as your view controller
//            var viewController = segue.destinationViewController as AnotherViewController
           // your new view controller should have property that will store passed value
//            viewController.passedValue = valueToPass
//        }
   }





}
