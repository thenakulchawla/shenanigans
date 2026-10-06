The below api is written in `python-flask`.

### Instructions

If you are here, you already have a `repl.it` link.
Place the `.env` file provided in the root of the directory. 
That helps in connecting to the `mongo-atlas` cluster where the data is stored.

### Technologies Used

- Python Flask
- Mongo Db

### Reasons

- **Python**: I find writing fast MVPs very easy in python, 
  since I don't have to worry too much about the data types and I can focus more on the logic.
  The time provided for this specific assignment helped me make the decision to python.
  
- **Flask**: Flask is a rest framework which focuses only on building apis. 
  It uses the Unix philosophy of doing one thing and doing that thing well.
  My one thing here was to build the given `api` and since I am already familiar 
  with the framework I chose this.
  
- **MongoDb**: I have recently been venturing into noSQL databases in my spare time, 
  and had been using mongodb for some projects. I had this already set up in my cluster
  on a kubernetes cluster and all I had to do was create a collection on it and test my api quickly.
  Some other reasons: 
  - Since the snippet here is a document, possible a text document, using mongo 
    seemed like a better choice than a SQL database since in case indexing is required at a later stage, 
    it can be used in a bag of words model

- **Not using Go**: I have used go in the past experience,
  however after moving to my current job, my main language has been Java. I absolutely love the language, 
  but I am not proficient enough to write and test an api within 2 hours. I am familiar with mongoengine on python
  but integrating that with go would have taken more time. For a production scalable system with more time 
  to build I would have loved to used Go
  
### Assumptions

- I have tested very simple test cases given in the README file.

### Error Handling

- Error handling is done using try-catch and throw exceptions. I would have liked to throw error codes
 so to maintain uniformity and easier to understand when something goes wrong.
  


