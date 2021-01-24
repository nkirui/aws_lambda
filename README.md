# HOW TO USE AN AWS LAMBDA FUNCTION TO MONITOR STATUS OF ENDPOINTS?
#### A step-by-step guide

- First you have to set a ficticious web endpoint, for this we are going to use a flask framework and host our application in Google App Engine.

## INSTALLATION AND GUIDE

1. clone/download the project into the directory of your choice
2. Activate your virtual environment, for this case we use Pipenv

    $ pipenv install
    $ pipenv shell

3. To launch application

    $ export FLASK_APP=main.py
    $ flask run

    or:

    $ python main.py

4. Head to https://localhost:5000
- if it works!, well done, next we deploy it to GAE

## DEPLOYMENT TO GAE GUIDE

1. Create a Google Cloud account. If you don’t already have one, you can sign up for the GCP Free Tier and get a free $300 credit for trying it out,and finally create a project name .

2. Activate billing for the created project

3. Head to project settings, volumes and create the bucket-name

4. Activate the project shell

5. Install the gcloud SDK/CLI. The gcloud command-line tool gives you the ability to syncronize 
   and deploy your ap, using this link https://cloud.google.com/sdk/docs/install#deb

6. On your local project directory create a app.yml file  in your root folder, you can name it anything you so wish .

7. Enter the following in your app.yml

    ```
    runtime: python38

    handlers:
    - url: /.*
      script: auto ```

8. Now appload your project to the bucket storage,using files uploads  to upload all files in your root directory and upload folder to upload templates/ folder.

9. On your project shell terminal ,create a project directory..using `mkdir your-dir`
10. Now use `gsutil rsync -r gs://your-bucket ./your-dir` to syncronize your files in the bucket storage.
11. Use `cd your-dir` and `gcloud app deploy app.yml`
12. Finally follow the prompts to get the url ,and that is all for your setup, next is to detail the process for automation in the *aws lambda*

## AUTOMATION IN AWS GUIDE

#### So what is AWS-LAMBDA?
- If you are familiar with python,and any other programming language you must have interacted with lambda functions,so AWS use that concept to come up with a a feature that enables creating and deploy applications on demand,AWS will take the code compile it using its run environment and run the code as you wait for the results.

#### A step-by-step guide

- Login to AWS ,and head to AWS-LAMBDA service.
- Click on create function
- Choose one of the options to create your function,for this case we would use Author from scratch
1. Function name, enter your function name as your wish.
2. Runtime, Use python 3.8 for the time am writing this.
3. The rest use the defaults

#### Uploading/Writing the script 

1. After creating the function you will be redirected to a page where you can start writing/pasting or uploading your code.
2. For this case will just write the code directly on the code editor provided by AWS.
- This is a simple script that will use in our case to monitor the health of our api endpoint.

    ```
        import os
        import urllib3

        def check():
            http = urllib3.PoolManager()
            url = os.environ['url']
            status_code = http.request('GET', url)
            return status_code.status

        def lambda_handler(event, context):
            if check() != 200:
                raise Exception(f'Alert! the endpoint, {url} is down")

    ```
3. Note, on your lambda function you are able to reference envrironment variables. 
4. Finally click on test menu to establish if your script is working as expected,if the results is as expected  as successful..you have made it..!

#### Time to create monitors using cloudwatch triggers ,cloudwatch logs and cloudwatch alarms.

- At this juncture we don't know anything unless we come and log in to the platform and do a test or until our furious customer rings to you that he/she is unable to access your service, if they are happy enough to wait..or lest they give it a black shoulder and get other reliable service.

#### step 1. Triggering the lambda function using AWS cloudwatch eventsbridge.

- On the search bar type *Amazon EventBridge*
- Click on create event rule
- Enter rule name and the description
- Choose Invoke your targets on a schedule
- Enter 5 minutes
- The target to invoke should be Lambda function, and you give the name of your function.
- Finally create your event

#### step 2. Now using cloudwatch logs as a notification factor

-  Now that we have instructed our function to run periodically after every 5 minutes, but importantly is that we want to get the notifification when something got broken.

- As you might have wondered we could have written a script to do that,but common ..why re-invent the wheel when AWS has good utilities to do the same thing easily.

- So under monitoring tools tap,click logs
- Click view logs in cloudwatch,
- On the  dashboard, click metrics tab to see the various metrics that is provided.
- For this scenario we are going to use the metrics under LAMBDA, and sorted by the FUNCTION NAME.
- Next to confirm that indeed these metrics are captured well,go back to monitoring,logs tap and click view logs in cloudwatch,
- click search logs group, from the list of all the logs you will be able to see logs based on the metrics captured and we would create an alarm based on that metric,for this scenario it is an error message.

#### step 3. Using An Alarm for alert on email.

- Now that we have seen our function sends its output to the cloudwatch logs,we need to create an alarm to pick this info and inform us via email or even mobile,but for this scenario we are going to use email address.

1. On alarms,click create alarm, you will be prompted to choose the graph metric,
2. Click on LAMBDA,and by FUNCTION NAME
3. As you can remember we had seen some of the metrics in our function,so on the search bar, type the name of the function with the metric error.
4. next is to configure the notifications ,and email addresses which is a straight forward ,just make sure that on the alarm graph the static field should be ..sum instead of avarage.
5. That is all you can go back to the dashboard and see everything in action and you will be receiving email alert when the api endpoint is down.




















