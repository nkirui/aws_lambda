from flask import Flask,render_template,request
from flask_bootstrap import Bootstrap
import smtplib
from decouple import config


app = Flask(__name__)
app.config["DEBUG"] = True 
email_server = config("EMAIL_SERVER")
email_port = config("EMAIL_PORT")
email_host = config("EMAIL_HOST")
password = config("EMAIL_HOST_PASSWORD")
notification_email = config("EMAIL_NOTIFICATION")


Bootstrap(app)


@app.route('/', methods=['GET'])
def home():
    
    title_name = "Subscribe to YODO1 email Newsletter"

    return render_template('subscribe.html',title_name=title_name)

@app.route('/',methods=["POST","GET"])
def subscribe():

    try:
        email = request.form.get("email")   
        comment = request.form.get("comment") 
        subject = "You have been subscribed to  our email newsletter"
        server = smtplib.SMTP(email_server,email_port)
        server.starttls()
        server.login(email_host,password)
        message = f'Subject: {subject} \n\n {comment}'
        server.sendmail(email_host, email, message)  
        server.quit()
    except:
        raise ValueError("invalid email")
  
    else:
        email_alert()  
        return render_template("thankyou.html",email=email)

def email_alert():

    try:
         
        subject = "A user has subscribed to our email newsletter"
        server = smtplib.SMTP(email_server,email_port)
        server.starttls()
        server.login(email_host,password)
        message = f'Subject: {subject} \n\n'
        server.sendmail(email_host, notification_email, message)  
        server.quit()
    except:
        raise ValueError("invalid email")


if __name__ == '__main__':
    app.run(port=5000)

