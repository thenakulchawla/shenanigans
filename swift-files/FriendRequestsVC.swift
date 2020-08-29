import UIKit

class FriendRequestsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendRequestCellDelegate {

   override func viewDidLoad() {}

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)

       globalUser.getFriendRequests() { (isSuccess) in
           if (isSuccess) {
               self.friendRequestTableView.reloadData()
           }

       }
   }


   @IBOutlet weak var friendRequestTableView: UITableView!

   @IBOutlet weak var backButton: UIButton!

   @IBAction func backToProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backToProfile", sender: self)
   }


   // MARK: - Table View Conform Methods here
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return userFriendRequests.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestViewCell", for: indexPath) as! FriendRequestViewCell

       let row = indexPath.row
       cell.textLabel?.text = userFriendRequests[row].senderUsername

       cell.friendRequestCellDelegate = self
       cell.acceptRequest.tag = indexPath.row
       cell.denyRequest.tag = indexPath.row

       return cell
   }

   func didPressAcceptButton(_ tag: Int) {
       print("didPressAcceptButton")

       let senderUid: String = userFriendRequests[tag].senderUid

       let senderUser: User = User()
       senderUser.uid = senderUid
       senderUser.getUser() { (isSuccess) in
           if (isSuccess) {
               globalUser.acceptFriendRequest(senderUser: senderUser)
           }
       }

   }

   func didPressDenyButton(_ tag: Int) {
       print("didPressDenyButton")
       print(userFriendRequests[tag].senderUsername)
   }




}
