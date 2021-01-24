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
   and deploy your ap, using this link `https://cloud.google.com/sdk/docs/install#deb`

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

## AUTOMATION IN AWS












