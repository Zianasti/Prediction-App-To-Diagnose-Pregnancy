from flask import Flask,render_template,request,session,redirect,url_for,flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash,check_password_hash
from flask_login import login_user,logout_user,login_manager,LoginManager
from flask_login import login_required,current_user
from sqlalchemy import Column, DECIMAL
import json
import pandas as pd
import numpy as np

import os
import pathlib
import requests
from flask import Flask, session, abort, redirect, request
from google.oauth2 import id_token
from google_auth_oauthlib.flow import Flow
from pip._vendor import cachecontrol
import google.auth.transport.requests

from datetime import datetime

import pickle
# # load the model from disk
filename = 'model_rfnew.pkl'
model = pickle.load(open(filename, 'rb'))

# MY db connection
local_server= True
app = Flask(__name__, static_url_path='/static')
app.secret_key='ziramed.com'


os.environ["OAUTHLIB_INSECURE_TRANSPORT"] = "1"  #this is to set our environment to https because OAuth 2.0 only supports https environments

GOOGLE_CLIENT_ID = "471549556565-0aa4lqujmsh8eele31gv7pq2gka4lbn2.apps.googleusercontent.com"  #enter your client id you got from Google console
client_secrets_file = os.path.join(pathlib.Path(__file__).parent, "client_secret.json")  #set the path to where the .json file you got Google console is

flow = Flow.from_client_secrets_file(  #Flow is OAuth 2.0 a class that stores all the information on how we want to authorize our users
    client_secrets_file=client_secrets_file,
    scopes=["https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/userinfo.email", "openid"],  #here we are specifing what do we get after the authorization
    redirect_uri="http://127.0.0.1:5000/callback"  #and the redirect URI is the point where the user will end up after the authorization
)

def login_is_required(function):  #a function to check if the user is authorized or not
    def wrapper(*args, **kwargs):
        if "google_id" not in session:  #authorization required
            return abort(401)
        else:
            return function()

    return wrapper

# this is for getting unique user access
login_manager=LoginManager(app)
login_manager.login_view='login'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# app.config['SQLALCHEMY_DATABASE_URL']='mysql://username:password@localhost/database_table_name'
# app.config['SQLALCHEMY_DATABASE_URI']='mysql://intelli3_root:Fahmi_123@localhost/intelli3_clinics'
app.config['SQLALCHEMY_DATABASE_URI']='mysql://root:@localhost/clinics'
db=SQLAlchemy(app)

# here we will create db models that is tables
# class Test(db.Model):
#     id=db.Column(db.Integer,primary_key=True)
#     name=db.Column(db.String(100))
#     email=db.Column(db.String(100))

class User(UserMixin,db.Model):
    id=db.Column(db.Integer,primary_key=True)
    username=db.Column(db.String(50))
    email=db.Column(db.String(50),unique=True)
    password=db.Column(db.String(1000))

class Patient(db.Model):
    id=db.Column(db.Integer,primary_key=True)
    nik=db.Column(db.String(50))
    pname=db.Column(db.String(50))
    dob=db.Column(db.Date)
    gender=db.Column(db.String(50))
    service=db.Column(db.String(50))
    email=db.Column(db.String(50))
    number=db.Column(db.String(12))
    address=db.Column(db.String(100))

class Categories(db.Model):
    cid=db.Column(db.Integer,primary_key=True)
    service=db.Column(db.String(100))

class Prediction(db.Model):
    aid=db.Column(db.Integer,primary_key=True)
    nik=db.Column(db.String(100))
    age=db.Column(db.Integer())
    sistole=db.Column(db.Integer())
    diastole=db.Column(db.Integer())
    bs=db.Column(DECIMAL(precision=4, scale=2))
    bod_temp=db.Column(DECIMAL(precision=4, scale=1))
    heart_rate=db.Column(db.Integer())
    result=db.Column(db.Integer())
  

class PredictionUser(db.Model):
    aid=db.Column(db.Integer,primary_key=True)
    email=db.Column(db.String(100))
    age=db.Column(db.Integer())
    sistole=db.Column(db.Integer())
    diastole=db.Column(db.Integer())
    bs=db.Column(DECIMAL(precision=4, scale=2))
    bod_temp=db.Column(DECIMAL(precision=4, scale=1))
    heart_rate=db.Column(db.Integer())
    result=db.Column(db.Integer())
    time=db.Column(db.DateTime, default=datetime.now, name='time')
    
class Recommendation(db.Model):
    rid=db.Column(db.Integer,primary_key=True)
    result=db.Column(db.Integer())
    saran=db.Column(db.String(2000))

class Information(db.Model):
    fid=db.Column(db.Integer,primary_key=True)
    result=db.Column(db.Integer())
    desc=db.Column(db.String(2000))   

class Trig(db.Model):
    tid=db.Column(db.Integer,primary_key=True)
    nik=db.Column(db.String(100))
    action=db.Column(db.String(100))
    timestamp=db.Column(db.String(100))

class Doctor(db.Model):
    did=db.Column(db.Integer,primary_key=True)
    nip=db.Column(db.String(50))
    dname=db.Column(db.String(50))
    dob=db.Column(db.Date)
    gender=db.Column(db.String(50))
    medical_specialty=db.Column(db.String(50))
    email=db.Column(db.String(50))
    number=db.Column(db.String(12))
    address=db.Column(db.String(100))
    
class Schedule_doctor(db.Model):
    sid=db.Column(db.Integer,primary_key=True)
    day=db.Column(db.Date)
    start_time=db.Column(db.Time)
    end_time=db.Column(db.Time)
    nip=db.Column(db.String(50))

    
@app.route('/')
def index(): 
    return render_template('index.html')

@app.route('/dashboard')
def dashboard(): 
    return render_template('dashboard.html')

@app.route('/home')
@login_required
def home(): 
    return render_template('home_user.html')

@app.route('/signup',methods=['POST','GET'])
def signup():
    if request.method == "POST":
        username=request.form.get('username')
        email=request.form.get('email')
        password=request.form.get('password')
        user=User.query.filter_by(email=email).first()
        if user:
            flash("Username Already Exist","warning")
            return render_template('signup.html')
        encpassword=generate_password_hash(password)

        new_user=db.engine.execute(f"INSERT INTO `user` (`username`,`email`,`password`) VALUES ('{username}','{email}','{encpassword}')")

        # this is method 2 to save data in db
        # newuser=User(username=username,email=email,password=encpassword)
        # db.session.add(newuser)
        # db.session.commit()
        flash("Signup Succesful, Login to proceed","success")
        return render_template('login.html')

    return render_template('signup.html')

@app.route('/login',methods=['POST','GET'])
def login():
    if request.method == "POST":
        email=request.form.get('email')
        password=request.form.get('password')
        user=User.query.filter_by(email=email).first()

        if email == 'admin@admin.com' and check_password_hash(user.password,password):
            flash("Kamu harus login sebagai user bukan admin, silahkan login kembali","danger")
            return render_template('login.html')

        if email != 'admin@admin.com' and check_password_hash(user.password,password):
            login_user(user)
            flash("Login Successful","primary")
            print(current_user.username)
            return render_template('home_user.html', email=email, username=current_user.username)

        else:
            flash("invalid credentials","danger")
            return render_template('login.html')

    return render_template('login.html')

@app.route("/login_google")  #the page where the user can login
def login_google():
    authorization_url, state = flow.authorization_url()  #asking the flow class for the authorization (login) url
    session["state"] = state
    return redirect(authorization_url)

def clear_list(lst):
    if lst:
        lst.clear()
    else:
        lst = []
    return lst

name_google = []
email_google = []

@app.route("/callback")  #this is the page that will handle the callback process meaning process after the authorization
def callback():
    flow.fetch_token(authorization_response=request.url)

    if not session["state"] == request.args["state"]:
        abort(500)  #state does not match!

    credentials = flow.credentials
    request_session = requests.session()
    cached_session = cachecontrol.CacheControl(request_session)
    token_request = google.auth.transport.requests.Request(session=cached_session)

    id_info = id_token.verify_oauth2_token(
        id_token=credentials._id_token,
        request=token_request,
        audience=GOOGLE_CLIENT_ID
    )

    session["google_id"] = id_info.get("sub")  #defing the results to show on the page
    session["name"] = id_info.get("name")

    clear_list(name_google)
    clear_list(email_google)
    name_google.append(id_info.get("name"))
    email_google.append(id_info.get("email"))

    print(name_google, email_google)
    return redirect("/protected_area")

@app.route("/protected_area", methods=['POST','GET'])  #the page where only the authorized users can go to
@login_is_required
def protected_area():
    return render_template('home_user.html', 
        email = email_google[0], username = name_google[0])

@app.route('/admin',methods=['POST','GET'])
def login_admin():
    if request.method == "POST":
        email=request.form.get('email')
        password=request.form.get('password')
        user=User.query.filter_by(email=email).first()

        if email == 'admin@admin.com' and check_password_hash(user.password,password):
            login_user(user)
            flash("Login Successful","primary")
            return redirect(url_for('dashboard'))

        # elif email != 'admin@admin.com' and check_password_hash(user.password,password):
        #     login_user(user)
        #     flash("Login Successful","primary") 
        #     return redirect(url_for('prediction_user'))

        else:
            flash("invalid credentials","danger")
            return render_template('login_admin.html')

    return render_template('login_admin.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("Logout Successful","warning")
    return redirect(url_for('login'))


# Patient
@app.route('/patientdetails')
@login_required
def patientdetails():
    query=db.engine.execute(f"SELECT * FROM `patient`") 
    return render_template('patientdetails.html',query=query)

@app.route('/addpatient',methods=['POST','GET'])
@login_required
def addpatient():
    cat=db.engine.execute("SELECT * FROM `categories`")
    if request.method=="POST":
        nik=request.form.get('nik')
        pname=request.form.get('pname')
        dob=request.form.get('dob')
        gender=request.form.get('gender')
        service=request.form.get('service')
        email=request.form.get('email')
        num=request.form.get('num')
        address=request.form.get('address')
        query=db.engine.execute(f"INSERT INTO `patient` (`nik`,`pname`,`dob`,`gender`,`service`,`email`,`number`,`address`) VALUES ('{nik}','{pname}','{dob}','{gender}','{service}','{email}','{num}','{address}')")
        flash("Patient Added Successfully","info")
    return render_template('patient.html',cat=cat)

@app.route("/deletepatient/<string:id>",methods=['POST','GET'])
@login_required
def deletepatient(id):
    db.engine.execute(f"DELETE FROM `patient` WHERE `patient`.`id`={id}")
    flash("patient Deleted Successfully","danger")
    return redirect('/patientdetails')

@app.route("/editpatient/<string:id>",methods=['POST','GET'])
@login_required
def editpatient(id):
    cat=db.engine.execute("SELECT * FROM `categories`")
    posts=Patient.query.filter_by(id=id).first()
    if request.method=="POST":
        nik=request.form.get('nik')
        pname=request.form.get('pname')
        dob=request.form.get('dob')
        gender=request.form.get('gender')
        service=request.form.get('service')
        email=request.form.get('email')
        num=request.form.get('num')
        address=request.form.get('address')
        query=db.engine.execute(f"UPDATE `patient` SET `nik`='{nik}',`pname`='{pname}',`dob`='{dob}',`gender`='{gender}',`service`='{service}',`email`='{email}',`number`='{num}',`address`='{address}'")
        flash("Patient Updated successfully","success")
        return redirect('/patientdetails')
    
    return render_template('editpatient.html',posts=posts,cat=cat)

@app.route('/triggers')
@login_required
def triggers():
    query=db.engine.execute(f"SELECT * FROM `trig`") 
    return render_template('triggers.html',query=query)

@app.route('/categories',methods=['POST','GET'])
@login_required
def categories():
    if request.method=="POST":
        cat=request.form.get('cat')
        query=Categories.query.filter_by(service=cat).first()
        if query:
            flash("Categories Already Exists","warning")
            return redirect('/categories')
        cate=Categories(service=cat)
        db.session.add(cate)
        db.session.commit()
        flash("Categories Added successfullly","success")
    return render_template('categories.html')

@app.route('/addprediction',methods=['POST','GET'])
@login_required
def addprediction():
    query=db.engine.execute(f"SELECT * FROM `patient`") 
    if request.method=="POST":
        nik=request.form.get('nik')
        age=request.form.get('age')
        sistole=request.form.get('sistole')
        diastole=request.form.get('diastole')
        bs=float(request.form.get('bs')) / 18
        bs="{:.2f}".format(bs)
        heart_rate=request.form.get('heart_rate')
        bod_temp=request.form.get('bod_temp')
        result=int(model.predict([[age,sistole,diastole,bs,heart_rate,bod_temp]]))
        proba = np.max(model.predict_proba([[age,sistole,diastole,bs,heart_rate,bod_temp]])) * 100
        print(nik, age, sistole, diastole, bs, heart_rate, bod_temp, result)
        predict=Prediction(nik=nik,age=age,sistole=sistole,diastole=diastole,bs=bs,
        heart_rate=heart_rate,bod_temp=bod_temp,result=result)
        db.session.add(predict)
        db.session.commit()
        # flash("Hasil prediksi :" + str(result), 'success')

 
        saran=db.engine.execute(f"SELECT * FROM `recommendation`") 

        return render_template('output_prediction.html', nik=nik,
            age=age,sistole=sistole,diastole=diastole,bs=bs,
            heart_rate=heart_rate,bod_temp=bod_temp,result=result,proba=proba, saran=saran)

    return render_template('prediction.html', query=query)

@app.route('/prediction_user',methods=['POST','GET'])
# @login_required
def prediction_user():
    print(email_google, name_google)

    try:
        email = email_google[-1]
        print(email)
    except (IndexError,AttributeError):
        email = str(current_user.email)
    else:
        pass

    query=db.engine.execute(f"SELECT * FROM `user`") 
    if request.method=="POST":
        email=request.form.get('email')
        age=request.form.get('age')
        sistole=request.form.get('sistole')
        diastole=request.form.get('diastole')
        bs=float(request.form.get('bs')) / 18
        bs="{:.2f}".format(bs)
        heart_rate=request.form.get('heart_rate')
        bod_temp=request.form.get('bod_temp')
        time = datetime.now()
        result=int(model.predict([[age,sistole,diastole,bs,heart_rate,bod_temp]]))
        proba = np.max(model.predict_proba([[age,sistole,diastole,bs,heart_rate,bod_temp]])) * 100
        print(email, age, sistole, diastole, bs, heart_rate, bod_temp, result)
        predict=PredictionUser(email=email,age=age,sistole=sistole,diastole=diastole,bs=bs,
        heart_rate=heart_rate,bod_temp=bod_temp,result=result,time=time)
        db.session.add(predict)
        db.session.commit()
        # flash("Hasil prediksi :" + str(result), 'success')

        saran=db.engine.execute(f"SELECT * FROM `recommendation`") 

        return render_template('output_prediction2.html', email=email,
            age=age,sistole=sistole,diastole=diastole,bs=bs,
            heart_rate=heart_rate,bod_temp=bod_temp,result=result,
            proba=proba, time=time,saran=saran)

    return render_template('prediction_user.html', query=query, email=email)

@app.route('/history_user')
# @login_required
def history_user():

    email = None
    try:
        email = str(current_user.email)

    except:
        email = email_google[0]

    print(email)
    query=db.engine.execute(f"SELECT * FROM `prediction_user` WHERE email = '{email}' ")
    data = query.fetchall()
    df = pd.DataFrame(data)
    print(df)
    df.columns = query.keys()
    df = df.drop(columns=['pid'])
    return render_template('history_user.html', email=email,
        tables=[df.to_html(index=False, classes='data')], titles=[])

#halaman trainingdata
import sqlalchemy

engine = sqlalchemy.create_engine('mysql://root:@localhost/clinics')
# engine = sqlalchemy.create_engine('mysql://intelli3_root:Fahmi_123@localhost/intelli3_clinics')

@app.route('/training', methods=['POST', 'GET'])
@login_required
def training():
    # data=db.engine.execute(f"SELECT * FROM `train`")
    from sklearn.model_selection import train_test_split
    from sklearn.metrics import classification_report, accuracy_score, ConfusionMatrixDisplay
    from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
    import matplotlib.pyplot as plt
    from imblearn.over_sampling import RandomOverSampler
    sm = RandomOverSampler(random_state=0)


    # query = 'SELECT * FROM `train`'
    # print(db)
    df = pd.read_csv('Data.csv')
    print(df)

    X = df.drop('RiskLevel',axis=1)
    y = df['RiskLevel']

    X_res, y_res = sm.fit_resample(X, y)

    X_train, X_test, y_train, y_test = train_test_split(X_res, y_res, test_size=0.2, random_state=42)

    if request.method=="POST":
        model=request.form.get('model')
        # print(model)
        if model == 'RandomForest':
            from sklearn.ensemble import RandomForestClassifier
           
            #Create Random Forest object
            random_forest = RandomForestClassifier(criterion='entropy')

            #Train model
            random_forest.fit(X_train, y_train)

            y_pred = random_forest.predict(X_test)
            akurasi = accuracy_score(y_test, y_pred)
            
            conf_matrix = confusion_matrix(y_true=y_test, y_pred=y_pred)
            #
            # Print the confusion matrix using Matplotlib
            #
            fig, ax = plt.subplots(figsize=(10, 10))
            ax.matshow(conf_matrix, cmap=plt.cm.Blues, alpha=0.3)
            for i in range(conf_matrix.shape[0]):
                for j in range(conf_matrix.shape[1]):
                    ax.text(x=j, y=i,s=conf_matrix[i, j], va='center', ha='center', size='xx-large')
             
            plt.xlabel('Predictions', fontsize=18)
            plt.ylabel('Actuals', fontsize=18)
            plt.title('Confusion Matrix', fontsize=18)
            # plt.show()
            plt.savefig('static/images/hasil_model_rf.png')

        elif model == 'DecisionTree':
            from sklearn.tree import DecisionTreeClassifier

            #Create Random Forest object
            decision_tree = DecisionTreeClassifier(criterion='entropy')

            #Train model
            decision_tree.fit(X_train, y_train)

            y_pred = decision_tree.predict(X_test)
            akurasi = accuracy_score(y_test, y_pred)
            
            conf_matrix = confusion_matrix(y_true=y_test, y_pred=y_pred)
            print(conf_matrix)
            #
            # Print the confusion matrix using Matplotlib
            #
            fig, ax = plt.subplots(figsize=(10, 10))
            ax.matshow(conf_matrix, cmap=plt.cm.Blues, alpha=0.3)
            for i in range(conf_matrix.shape[0]):
                for j in range(conf_matrix.shape[1]):
                    ax.text(x=j, y=i,s=conf_matrix[i, j], va='center', ha='center', size='xx-large')
             
            plt.xlabel('Predictions', fontsize=18)
            plt.ylabel('Actuals', fontsize=18)
            plt.title('Confusion Matrix', fontsize=18)
            # plt.show()
            plt.savefig('static/images/hasil_model_dt.png')

        else:
            pass

        return render_template('output_training.html', model=model, akurasi=akurasi)

    return render_template('training.html')

@app.route('/visualisasi')
@login_required
def visualisasi():
    return render_template('visualisasi.html')

# Doctor
@app.route('/adddoctor',methods=['POST','GET'])
@login_required
def adddoctor():
    if request.method=="POST":
        nip=request.form.get('nip')
        dname=request.form.get('dname')
        dob=request.form.get('dob')
        gender=request.form.get('gender')
        medical_specialty=request.form.get('specialty')
        email=request.form.get('email')
        num=request.form.get('num')
        address=request.form.get('address')
        query=db.engine.execute(f"UPDATE `doctor` SET (`nip`,`dname`,`dob`,`gender`,`medical_specialty`,`email`,`number`,`address`) VALUES ('{nip}','{dname}','{dob}','{gender}','{medical_specialty}','{email}','{num}','{address}')")
        flash("Doctor Added Successfully","info")
    return render_template('doctor.html')

@app.route('/doctordetails')
@login_required
def doctordetails():
    query=db.engine.execute(f"SELECT * FROM `doctor`") 
    return render_template('doctordetails.html',query=query)



@app.route("/deletedoctor/<string:did>",methods=['POST','GET'])
@login_required
def delete(did):
    db.engine.execute(f"DELETE FROM `doctor` WHERE `doctor`.`did`={did}")
    flash("doctor Deleted Successfully","danger")
    return redirect('/doctordetails')

@app.route("/editdoctor/<string:did>",methods=['POST','GET'])
@login_required
def editdoctor(did):
    posts=Doctor.query.filter_by(did=did).first()
    if request.method=="POST":
        nip=request.form.get('nip')
        dname=request.form.get('dname')
        dob=request.form.get('dob')
        gender=request.form.get('gender')
        medical_specialty=request.form.get('specialty')
        email=request.form.get('email')
        num=request.form.get('num')
        address=request.form.get('address')
        query=db.engine.execute(f"UPDATE `doctor` SET `nip`='{nip}',`dname`='{dname}',`dob`='{dob}',`gender`='{gender}',`medical_specialty`='{medical_specialty}',`email`='{email}',`number`='{num}',`address`='{address}'")
        flash("Doctor Updated successfully","success")
        return redirect('/doctordetails')
    
    return render_template('editdoctor.html',posts=posts)

@app.route('/addschedule',methods=['POST','GET'])
@login_required
def addschedule():
    query=db.engine.execute(f"SELECT * FROM `doctor`") 
    if request.method=="POST":
        nip=request.form.get('nip')
        day=request.form.get('day')
        start_time=request.form.get('start')
        end_time=request.form.get('end')
        print(nip, day, start_time, end_time)
        sche=Schedule_doctor(nip=nip,day=day,start_time=start_time,end_time=end_time)
        db.session.add(sche)
        db.session.commit()
        flash("Schedule added","warning")

    return render_template('scheduledoctor.html', query=query)

@app.route('/schedule',methods=['POST','GET'])
@login_required
def schedule():
    jadwal=db.engine.execute(f"SELECT * FROM `schedule_doctor`") 
    return render_template('schedule.html',jadwal=jadwal)
    


if __name__ == '__main__':
    app.run(debug=True)   