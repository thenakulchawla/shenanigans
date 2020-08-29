class SearchFriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

   @IBOutlet weak var searchFriendTableView: UITableView!
   @IBOutlet weak var searchFriendSearchBar: UISearchBar!

   @IBOutlet weak var cancelButton: UIButton!
   @IBAction func cancelButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "backToFriendListFromSearch", sender: self)
   }

   var otherProfileUserName: String!
   var otherProfileUid: String!

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return searchFriends.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFriendCell", for: indexPath) as! SearchFriendCell

       cell.textLabel?.text = searchFriends[indexPath.row].username

       return cell
   }

   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       print("Enter searchBarButtonClicked")

       searchFriends.removeAll()

       let userToSearch: String = searchBar.text!
       searchUserName(userToSearch: userToSearch) { (isSuccess) in
           if (isSuccess) {
               self.searchFriendTableView.reloadData()
           }
       }


       print("Exit searchBarButtonClicked")


   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


       otherProfileUserName = searchFriends[indexPath.row].username
       otherProfileUid = searchFriends[indexPath.row].uid

       self.performSegue(withIdentifier: "showProfileFromSearch", sender: self)

   }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?){
       if let destination = segue.destination as? OtherProfileVC {
           destination.userNameLabelFromFriendList = otherProfileUserName
           destination.uidFromFriendList = otherProfileUid
       }

   }


   override func viewDidLoad() {
       super.viewDidLoad()

       searchFriendSearchBar.delegate = self


   }

   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       print("releasing resource xyz")
       // Dispose of any resources that can be recreated.
   }





}
