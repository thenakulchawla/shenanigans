import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SignUpVC: UIViewController {

   override func viewDidLoad() {
       super.viewDidLoad()

       signUpButton.isEnabled = true

       let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))

       view.addGestureRecognizer(tap)

       // Do any additional setup after loading the view.
   }

   @IBOutlet weak var email: UITextField!


   @IBOutlet weak var password: UITextField!
   @IBOutlet weak var confirmPassword: UITextField!
   @IBOutlet weak var signUpButton: UIButton!

   @IBOutlet weak var userName: UITextField!

   @IBAction func signUp(_ signUpButton: UIButton) {

       if password.text != confirmPassword.text {
           let alertController = UIAlertController(title: "Password - Confirm Password combination Incorrect", message: "Please re-type password", preferredStyle: .alert)
           let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)

           alertController.addAction(defaultAction)
           self.present(alertController, animated: true, completion: nil)

       } else {
           Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (authUser, error) in
               if error != nil {
                   let err = error! as NSError
                   switch err.code {
                   case AuthErrorCode.invalidEmail.rawValue:
                       print("invalid email")
                       let alertController = UIAlertController(
                           title: "Incorrect email ID format",
                           message: "Please re-type email ID",
                           preferredStyle: .alert)
                       let defaultAction = UIAlertAction(title: "Update email ID", style: .cancel, handler: nil)
                       alertController.addAction(defaultAction)
                       self.present(alertController, animated: true, completion: nil)
                   case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                       print("accountExistsWithDifferentCredential")
                       let alertController = UIAlertController(
                           title: "Email ID already in use!",
                           message: "A user is already registered with this email ID",
                           preferredStyle: .alert)
                       let loginAction = UIAlertAction(title: "Log in", style: .cancel, handler:  { _ in
                           self.performSegue(withIdentifier: "signUpToLogin", sender: nil)})
                       let defaultAction = UIAlertAction(title: "Re-type email", style: .default, handler: nil)
                       alertController.addAction(defaultAction)
                       alertController.addAction(loginAction)
                       self.present(alertController, animated: true, completion: nil)
                   case AuthErrorCode.emailAlreadyInUse.rawValue:
                       print("Email is alreay in use")
                       let alertController = UIAlertController(
                           title: "Email ID already in use!",
                           message: "A user is already registered with this email ID",
                           preferredStyle: .alert)
                       let loginAction = UIAlertAction(title: "Log in", style: .cancel, handler:  { _ in
                           self.performSegue(withIdentifier: "signUpToLogin", sender: nil)})
                       let defaultAction = UIAlertAction(title: "Re-type email", style: .default, handler: nil)
                       alertController.addAction(defaultAction)
                       alertController.addAction(loginAction)
                       self.present(alertController, animated: true, completion: nil)
                   default:
                       print("unknown error: \(err.localizedDescription)")
                       let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)

                       alertController.addAction(defaultAction)
                       self.present(alertController, animated: true, completion: nil)
                   }
               }
               else
               {
                   let userRef = firestoreRef.collection("users").document((authUser?.user.uid)!)
                   //dbRef.child("users").child((authUser?.user.uid)!)

                   let imageReference = storageRef.child("profilePictures/defaults/reeal.png")

                   imageReference.downloadURL { url, error in
                       if let error = error {
                           print(error)
                           // Handle any errors
                       } else {
                           // Get the download URL for 'images/stars.jpg'

                           globalUser.photoURL = url?.absoluteString

                           let currentUser = User( uid: (authUser?.user.uid)!, email: self.email.text!, username:self.userName.text!, photoURL: globalUser.photoURL, friendsCount: 0, friendRequestsCount: 0, reelsCount: 0 )

                           do {
                               try userRef.setData(from: currentUser)
                           } catch let error {
                               print("Error writing new User to Firestore: \(error)")
                           }

                           globalUser.updateUser(existingUser: currentUser)

                           if UIApplication.shared.isRegisteredForRemoteNotifications {
                               Cache().setToken()
                           }
                       }
                   }

                   print("Sign up Succesful")

                   self.performSegue(withIdentifier: "signUpVerification", sender: self)

               }
           }
       }
   }

}
