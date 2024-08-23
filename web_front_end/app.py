# file: app.py

# Importing the necessary libraries and Flask boilerplate
from flask import Flask, render_template, make_response, send_file, request, redirect, url_for, jsonify, flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import or_
from sqlalchemy import func
from wtforms import SelectField
from flask_wtf import FlaskForm
import pdfkit
import os


app = Flask(__name__)
app.static_folder = 'static'
app.secret_key = "secret_key"

# Configure SQLAlchemy to connect to your MySQL database
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:0964475128@127.0.0.1/hospital_sys_dbs'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['PDF_FOLDER'] = os.path.join(app.root_path, 'PDF_FOLDER')

db = SQLAlchemy(app)





# PATIENT: Defining the model
class Patient(db.Model):
    __tablename__ = 'patient'
    patient_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(255))
    initials = db.Column(db.String(2))
    sex = db.Column(db.String(1))
    address = db.Column(db.String(255))
    post_code = db.Column(db.String(5))
    admission = db.Column(db.Date)
    DOB = db.Column(db.Date)
    ward_id = db.Column(db.String(2))
    next_of_kin = db.Column(db.String(255))

    def __init__(self, patient_id, name, initials, sex, address, post_code, admission, DOB, ward_id, next_of_kin):
        self.patient_id = patient_id
        self.name = name
        self.initials = initials
        self.sex = sex
        self.address = address
        self.post_code = post_code
        self.admission = admission
        self.DOB = DOB
        self.ward_id = ward_id
        self.next_of_kin = next_of_kin

# WARD: Defining the model
class Ward(db.Model):
    __tablename__ = 'ward'
    ward_id = db.Column(db.String(2), primary_key=True)
    ward_name = db.Column(db.String(255))
    number_beds = db.Column(db.Integer)
    free_beds = db.Column(db.Integer)
    nurse_in_charge = db.Column(db.String(255))
    ward_type = db.Column(db.String(255)) 

    def __init__(self, ward_id, ward_name, number_beds, nurse_in_charge, ward_type):
            self.ward_id = ward_id
            self.ward_name = ward_name
            self.number_beds = number_beds
            self.free_beds = free_beds  # Initialize as None
            self.nurse_in_charge = nurse_in_charge
            self.ward_type = ward_type

# PATIENT-FORM: Defining model for dropdown-menu
class Form(FlaskForm):
    ward = SelectField("Ward", choices=[])




# PATIENT-LIST: Fetch data from the database and pass it to the template
@app.route('/patientList')
def PatientList():
    patients = Patient.query.all()
    form = Form()
    wards = Ward.query.all()
    form.ward.choices = [(ward.ward_id, f"{ward.ward_id} - {ward.ward_name}") for ward in wards]
    return render_template('patientList.html', patients=patients, form=form, wards=wards, pageTitle='Patients')

# PATIENT-VIEW: Fetch data from the database and pass it to the template
@app.route('/patientView')
def PatientView():
    patients = Patient.query.all()
    form = Form()
    wards = Ward.query.all()
    form.ward.choices = [(ward.ward_id, f"{ward.ward_id} - {ward.ward_name}") for ward in wards]
    return render_template('patientView.html', patients=patients, form=form, wards=wards, pageTitle='Patients')

# SQLAlchemy route for viewing patient details
@app.route("/viewP/<patient_id>", methods=['GET'])
def viewP(patient_id):
    user = Patient.query.filter_by(patient_id=patient_id).first()
    if user:
        return render_template("viewP.html", patient=user)
    else:
        return "Patient not found.", 404

# PATIENT-VIEW-PRINTING: Fetch data from the database and pass it to the template
@app.route("/generate_patient_pdf/<patient_id>")
def generate_patient_pdf(patient_id):
    patient = Patient.query.filter_by(patient_id=patient_id).first()
    if not patient:
        return "Patient not found", 404

    # Fetch the necessary patient details
    patient_details = {
        "patient_id": patient.patient_id,
        "name": patient.name,
        "sex": patient.sex,
        "address": patient.address,
        # Add more fields as required
    }

    # Render the patient's details in a separate HTML template
    html = render_template("patient_pdf_template.html", patient=patient_details)

    # Try to generate the PDF file using the wkhtmltopdf_path keyword argument
    try:
        config = pdfkit.configuration(wkhtmltopdf_path="C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe")
        pdf = pdfkit.from_string(html, False, config=config)

    # If the wkhtmltopdf_path keyword argument is not supported, generate the PDF file without it
    except TypeError:
        pdf = pdfkit.from_string(html, False)

    # Return the PDF file as a response
    response = make_response(pdf)
    response.headers["Content-Type"] = "application/pdf"
    response.headers["Content-Disposition"] = f"attachment; filename=patient_{patient_id}.pdf"
    return response






# WARD-LIST: Fetch data from the database and pass it to the template
@app.route('/wardList')
def WardList():
    wards = Ward.query.all()
    return render_template('wardList.html', wards=wards, pageTitle='Wards')

# WARD-VIEW: Fetch data from the database and pass it to the template
@app.route('/wardView')
def WardView():
    wards = Ward.query.all()
    return render_template('wardView.html', wards=wards, pageTitle='Wards')

# SQLAlchemy route for viewing patient details
@app.route("/viewW/<ward_id>", methods=['GET'])
def viewW(ward_id):
    user = Ward.query.filter_by(ward_id=ward_id).first()
    if user:
        return render_template("viewW.html", ward=user)
    else:
        return "Ward not found.", 404

# WARD-VIEW-PRINTING: Fetch data from the database and pass it to the template
@app.route('/printW/<ward_id>')
def printWard(ward_id):
    # Get the ward details
    ward = Ward.query.get(ward_id)

    # Render the HTML template for the ward details
    html = render_template('wardView.html', ward=ward)

    # Convert the HTML to PDF using pdfkit
    pdf = pdfkit.from_string(html, False)

    # Send the PDF to the user
    return send_from_directory(app.config['PDF_FOLDER'], filename=pdf)



# PATIENT-LIST: Search capability
@app.route('/patientList/search', methods=['GET', 'POST'])
def patientListSearch():
    if request.method == "POST":
        patientSearch_value = request.form.get('patient_search_string')
        form = Form()  # Create an instance of the Form class
        wards = Ward.query.all()
        form.ward.choices = [(ward.ward_id, f"{ward.ward_id} - {ward.ward_name}") for ward in wards]
        patientSearch = f"%{patientSearch_value}%"
        results = Patient.query.filter(
            or_(
                Patient.patient_id.like(patientSearch),
                Patient.name.like(patientSearch),
                Patient.initials.like(patientSearch),
                Patient.sex.like(patientSearch),
                Patient.address.like(patientSearch),
                Patient.post_code.like(patientSearch),
                Patient.admission.like(patientSearch),
                Patient.DOB.like(patientSearch),
                Patient.ward_id.like(patientSearch),
                Patient.next_of_kin.like(patientSearch)
            )
        ).all()
        return render_template('patientList.html', patients=results, form=form, pageTitle='Patients', legend="Search Results")
    else:
        return redirect('/patientList')

# PATIENT-VIEW: Search capability
@app.route('/patientView/search', methods=['GET', 'POST'])
def patientViewSearch():
    if request.method == "POST":
        patientSearch_value = request.form.get('patient_search_string')
        form = Form()  # Create an instance of the Form class
        wards = Ward.query.all()
        form.ward.choices = [(ward.ward_id, f"{ward.ward_id} - {ward.ward_name}") for ward in wards]
        patientSearch = f"%{patientSearch_value}%"
        results = Patient.query.filter(
            or_(
                Patient.patient_id.like(patientSearch),
                Patient.name.like(patientSearch),
                Patient.initials.like(patientSearch),
                Patient.sex.like(patientSearch),
                Patient.address.like(patientSearch),
                Patient.post_code.like(patientSearch),
                Patient.admission.like(patientSearch),
                Patient.DOB.like(patientSearch),
                Patient.ward_id.like(patientSearch),
                Patient.next_of_kin.like(patientSearch)
            )
        ).all()
        return render_template('patientView.html', patients=results, form=form, pageTitle='Patients', legend="Search Results")
    else:
        return redirect('/patientView')

    
# WARD-LIST: Search capability
@app.route('/wardList/search', methods=['GET', 'POST'])
def wardListSearch():
    if request.method == "POST":
        form = request.form
        wardSearch_value = form['ward_search_string']
        wardSearch = "%{0}%".format(wardSearch_value)
        results = Ward.query.filter(or_(Ward.ward_id.like(wardSearch),
                                           Ward.ward_name.like(wardSearch),
                                           Ward.number_beds.like(wardSearch),
                                           Ward.nurse_in_charge.like(wardSearch),
                                           Ward.ward_type.like(wardSearch))).all()
        return render_template('wardList.html', wards=results, pageTitle='Patients', legend="Search Results")
    else:
         return redirect('/wardList')

# WARD:-VIEW Search capability
@app.route('/wardView/search', methods=['GET', 'POST'])
def wardViewSearch():
    if request.method == "POST":
        form = request.form
        wardSearch_value = form['ward_search_string']
        wardSearch = "%{0}%".format(wardSearch_value)
        results = Ward.query.filter(or_(Ward.ward_id.like(wardSearch),
                                           Ward.ward_name.like(wardSearch),
                                           Ward.number_beds.like(wardSearch),
                                           Ward.nurse_in_charge.like(wardSearch),
                                           Ward.ward_type.like(wardSearch))).all()
        return render_template('wardView.html', wards=results, pageTitle='Patients', legend="Search Results")
    else:
         return redirect('/wardView')





# PATIENT: Insert data from the template to the database
@app.route('/patientList/insert', methods=['POST'])
def patientInsert():
    if request.method == "POST":
        max_id = db.session.query(func.max(func.substr(Patient.patient_id, 2))).scalar()
        if max_id:
            next_id = f'P{int(max_id) + 1:02}'
        else:
            next_id = 'P01'  # If there are no existing IDs, start from P01
        
        name = request.form['name']
        initials = request.form['initials']
        sex = request.form['sex']
        address = request.form['address']
        post_code = request.form['post_code']
        admission = request.form['admission']
        DOB = request.form['DOB']
        ward_id = request.form['ward']
        next_of_kin = request.form['next_of_kin']

        my_patient = Patient(next_id, name, initials, sex, address, post_code, admission, DOB, ward_id, next_of_kin)
        db.session.add(my_patient)
        db.session.commit()

        flash("Patient Inserted Successfully")

        return redirect(url_for('PatientList'))
    
# WARD: Insert data from the template to the database
@app.route('/wardList/insert', methods=['POST'])
def wardInsert():
    if request.method == "POST":
        ward_name = request.form['ward_name']
        number_beds = request.form['number_beds']
        nurse_in_charge = request.form['nurse_in_charge']
        ward_type = request.form['ward_type']
        
        max_ward = Ward.query.order_by(Ward.ward_id.desc()).first()
        if max_ward:
            current_id = int(max_ward.ward_id[1:])
            next_id = current_id + 1
            ward_id = f'W{next_id:02}'
        else:
            ward_id = 'W01'

        my_ward = Ward(ward_id, ward_name, number_beds, nurse_in_charge, ward_type)
        db.session.add(my_ward)
        db.session.commit()

        flash("Ward Inserted Successfully")

        return redirect(url_for('WardList'))





# PATIENT: Update data from the template to the database
@app.route('/patientList/update', methods=['POST'])
def patientUpdate():
    if request.method == "POST":
        my_patient = Patient.query.get(request.form.get('id'))

        # Update the patient information
        my_patient.name = request.form['name']
        my_patient.initials = request.form['initials']
        my_patient.sex = request.form['sex']
        my_patient.address = request.form['address']
        my_patient.post_code = request.form['post_code']
        my_patient.admission = request.form['admission']
        my_patient.DOB = request.form['DOB']
        my_patient.ward_id = request.form['ward']
        my_patient.next_of_kin = request.form['next_of_kin']

        db.session.commit()
        flash("Patient Updated Successfully")

        return redirect(url_for('PatientList'))

    
# WARD: Update data from the template to the database
@app.route('/wardList/update', methods=['POST'])
def wardUpdate():
    if request.method == "POST":
        my_ward = Ward.query.get(request.form.get('id'))

        # Update the ward information
        my_ward.ward_name = request.form['ward_name']
        my_ward.number_beds = request.form['number_beds']
        my_ward.nurse_in_charge = request.form['nurse_in_charge']
        my_ward.ward_type = request.form['ward_type']

        db.session.commit()
        flash("Ward Updated Successfully")

        return redirect(url_for('WardList'))



    




# PATIENT: Delete data from the template to the database
@app.route('/patientList/delete/<id>/', methods = ['GET', 'POST'])
def patientDelete(id):
    my_patient = Patient.query.get(id)
    db.session.delete(my_patient)
    db.session.commit()
    flash("Patient Deleted Successfully")

    return redirect(url_for('PatientList'))

# WARD: Delete data from the template to the database
@app.route('/wardList/delete/<id>/', methods = ['GET', 'POST'])
def wardDelete(id):
    my_ward = Ward.query.get(id)
    db.session.delete(my_ward)
    db.session.commit()
    flash("Ward Deleted Successfully")

    return redirect(url_for('WardList'))





# Rendering of supporting template files with flask application
@app.route('/signup')
def Signup():
    return render_template('signup.html')

@app.route('/login')
def Login():
    return render_template('login.html')

@app.route('/welcome')
def Welcome():
    return render_template('welcome.html')

@app.route('/dashboard')
def Dashboard():
    return render_template('dashboard.html')

@app.route('/')
def Index():
    return render_template('index.html')

@app.route('/patient_pdf_template')
def Patient_pdf_template():
    return render_template('patient_pdf_template.html')





if __name__ == '__main__':
    app.run(debug=True)


