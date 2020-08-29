class VerifyUserVC: UIViewController {

   @IBOutlet weak var verifyUserButton: UIButton!
   @IBOutlet weak var verifiedUserContinueButton: UIButton!

   override func viewDidLoad() {
       super.viewDidLoad()

       // Do any additional setup after loading the view.
   }

   @IBAction func verifyAccount(_ verifyUserButton: UIButton) {
       authRef.currentUser?.sendEmailVerification() { (error) in
           if error == nil {
               print("Successfully sent verification email")
           }
       }
   }

   @IBAction func continueToHome(_ verifiedUserContinueButton: UIButton)
   {

       var runCount = 0

       //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

       Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
           authRef.currentUser?.reload()
           if (authRef.currentUser?.isEmailVerified)!
           {
               print("Verified user.. Yay!!")
               //isVerified = true
               timer.invalidate()
               self.performSegue(withIdentifier: "verificationToHome", sender: self)
           }
           else
           {
               print("Not yet verified. Continuing")
           }
           runCount += 1
           if runCount == 10 {
               let alertController = UIAlertController(title: "Error", message: "Please verify email ID to proceed", preferredStyle: .alert)
               let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)

               alertController.addAction(defaultAction)
               self.present(alertController, animated: true, completion: nil)
               timer.invalidate()
           }

       }
   }
}
