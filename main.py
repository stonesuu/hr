#!/bin/env python2.7
#coding=utf-8
import os,xlrd
import datetime
from flask import Flask,session,request,render_template,redirect,json,url_for
import dbutil,time
from werkzeug import secure_filename
try:
	conn = dbutil.DB('hr','10.99.160.36','root','root')
	conn.connect()
except Exception as e:
	print e
	print 'connect error'
else:
	print 'connect success'
SN_dict = {}
date_list = []
UPLOAD_FOLDER = 'D:\upload'
ALLOWED_EXTENSIONS = set(['xls','xlsx'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.secret_key = 'sadfagraegrgaregareghhqare'


def getjson(sql):
	try:
		tmp = conn.execute(sql)
		res = json.dumps(tmp)
	except Exception as e:
		return 'error'
	else:
		return res
def allowed_file(filename):
	return '.' in filename and \
		filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

def excel_to_db_stuff(file):
	book = xlrd.open_workbook(file)
	sheet = book.sheet_by_index(0)
	col_num = sheet.ncols
	row_num = sheet.nrows
	if col_num == 0:
		print 'error,the column is %s' % (col_num)
		return '-1'
	else:
		print 'the column is %s' % (col_num,)
		val = ''
		for i in range(0,col_num):
			val += '%s,'
		dfun = []
		for i in range(1,row_num):
			row_values = sheet.row_values(i) 
			in_work_date = xlrd.xldate.xldate_as_datetime(sheet.cell(i,14).value,0)
			in_company_date = xlrd.xldate.xldate_as_datetime(sheet.cell(i,21).value,0)
			# Convert an Excel date/time number into a datetime.datetime object.  
			# @param xldate The Excel number  
			# @param datemode 0: 1900-based, 1: 1904-based.  
			row_values[14] = in_work_date
			row_values[21] = in_company_date
			#print row_values
			dfun.append(row_values)
		sql = '''insert into stuff(name,pre_name,sex,MZ,id,ZZMM,learn,health,HKLB,
			merriage,JG,HKSZD,home_phone,cell_phone,in_work_date,home_add1,home_add2,company,job_status,department,
			job_name,in_company_date,LWPQGS,JT_department,RYXL,conn_name,conn_phone,JTXZ,
			XSBZ,GZBZ,base_salary,high_temp_base,special_job_base,night_job_base,leader_salary,age_salary,meal_base
			,SB_base,YB_base,env_salary,switch,other,order_num) values ('''
		#cursor.executemany("insert into resources_networkdevice values("+val[:-1]+");" ,dfun)
		try: 
			conn.cursor.execute('delete from stuff')
			#conn.cursor.execute('truncate table stuff;')
			conn.cursor.executemany(sql+val[:-1]+");",dfun)
			conn.cursor.execute('commit')
		except Exception as e:
			print e
			return '-1'
		else:
			return '1'
def excel_to_check(file):
	book = xlrd.open_workbook(file)
	sheet = book.sheet_by_index(0)
	col_num = sheet.ncols
	row_num = sheet.nrows
	try:
		conn.cursor.execute('start transaction')
		for i in range(1,row_num):
			row_values = sheet.row_values(i)
			row_values_change = row_values[3:]
			row_values_change.append(row_values[2])
			#print row_values_change
			row_values_tuple = tuple(row_values_change)
			#print row_values_tuple
			sql = '''update check_once set BJ=%s,SJ=%s,KG=%s,TQJ=%s,HSJ=%s,CJ=%s,GSJ=%s,QTJ=%s,
			JHSYJ=%s,GJ=%s,NXJ=%s,full_night_job=%s,holiday_job=%s,sunday_job=%s,add_job=%s,
			JT_days=%s,reward_salary=%s,check_salary=%s,BX_check=%s where id="%s"''' % row_values_tuple
			#print sql
			conn.cursor.execute(sql)
	except Exception as e:
		print e
		return '-1'
	else:
		conn.cursor.execute('commit')
		return '1'

def get_time():
	cur = datetime.datetime.now()
	year = cur.year
	month = cur.month
	day = cur.day
	if month != 1:
		return ('%s-%s-%s' %(year,month,day),'%s-%s' %(year,month-1))
	else:
		return ('%s-%s-%S' %(year,month,day),'%s-12' %(year-1,))





@app.route('/upload',methods=['GET','POST'])
def upload():
	if request.method == 'GET':
		return render_template('upload.html')
	else:
		file = request.files['file']
    	if file and allowed_file(file.filename):
        	#filename = secure_filename(file.filename)
        	filename = file.filename
        	ab_path_file = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        	file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            #return redirect(url_for('uploaded_file',filename=filename))
        	res = excel_to_db_stuff(ab_path_file)
        	return res

@app.route('/getime')#供所有页面获取时间，调用get_time函数
def getime():
	res = get_time()
	return json.dumps(res)

@app.route('/')
def login_r():
	return redirect('/signin')

@app.route('/signin',methods=['GET','POST'])
def signin():
	if request.method == 'GET':
		return render_template('signin.html')
	elif request.method == 'POST':
		username = request.form.get('username')
		password = request.form.get('password')
		if username == 'root':
			session['user'] = 'root'
			return redirect('/common/stuff')
	# 	sql = "SELECT COMPANY FROM user WHERE (NAME='%s' AND PASSWORD='%s')" % (username,password)
	# 	res = conn.execute(sql)
	# 	if len(res) == 0:
	# 		return render_template('signin.html',message="error")
	# 	else:
	# 		session['user'] = username
	# 		session['group'] = res[0][0]
	# 		if session['group'] == 0:
	# 			return redirect('/super/user')
	# 		else:
	# 			return redirect('/common/stuff')

@app.route('/logout')
def logout():
	session.pop('user')
	session.pop('group')
	return redirect('/signin')


# @app.route('/signup')
# def signup():
# 	return render_template('signup.html')

# @app.route('/common/getC',methods=['GET','POST'])
# def com_getC():
# 	if request.method == 'GET':
# 		sql = 'SELECT NAME FROM COMPANY'
# 		res = getjson(sql)
# 		return res
# 	else:
# 		sql = 'SELECT NAME FROM COMPANY WHERE ID_C=%s' %(session['group'])
# 		res = conn.execute(sql)
# 		return res[0][0]

# @app.route('/common/signup',methods=['post'])
# def com_signup():
# 	username = request.form.get('username')
# 	password = request.form.get('password')
# 	company = request.form.get('company')
# 	sql = "INSERT INTO user(NAME,PASSWORD,COMPANY) SELECT '%s','%s',ID_C FROM company WHERE NAME='%s'" %(username,password,company)
# 	res = conn.execute(sql)
# 	if not res:
# 		return 'ok'
# 	else:
# 		return 'error'


@app.route('/common/stuff')
def com_stuff():
	if 'user' in session:
		return render_template('stuff.html')
	else:
		return redirect('/signin')

# @app.route('/common/stuff/getmessage')
# def com_stuff_getm():
# 	print session['user']
# 	return json.dumps((session['user'],session['group']))

# @app.route('/common/stuff/add',methods=['POST'])
# def com_stuff_add():
# 	name = request.form.get('name')
# 	age = int(request.form.get('age'))
# 	sex = request.form.get('sex')
# 	tele = int(request.form.get('tele'))
# 	address = request.form.get('address')
# 	company = int(request.form.get('company'))
# 	salary = int(request.form.get('salary'))
# 	sql = "INSERT INTO stuff(NAME,SEX,AGE,COMPANY,TEL,ADDRESS,SALARY) VALUES ('%s','%s',%s,%s,'%s','%s',%s)" %(name,sex,age,company,tele,address,salary)
# 	res = conn.execute(sql)
# 	if not res:
# 		return 'ok'
# 	else:
# 		return 'error'

@app.route('/common/stuff/get')
def com_stuff_get():
	res_for_json = [] 
	year = datetime.datetime.now().year
	sql = 'select name,sex,id,company,job_name,GZBZ from stuff order by order_num'
	res = conn.execute(sql)
	for tmp_tuple in res:
		tmp_id = tmp_tuple[2]
		birth = '.'.join([tmp_id[6:10],tmp_id[10:12],tmp_id[12:14]])
		age = str(year - int(tmp_id[6:10]))
		tmp_res_for_json = (tmp_tuple[0],age,tmp_tuple[1],tmp_tuple[2],tmp_tuple[3],tmp_tuple[4],tmp_tuple[5])
		#print tmp_res_for_json
		res_for_json.append(tmp_res_for_json)
	return json.dumps(res_for_json)

# @app.route('/common/stuff/del',methods=['POST'])
# def com_stuff_del():
# 	ID_I = request.form.get('id')
# 	sql = "DELETE FROM stuff WHERE ID_I=%s" % (ID_I)
# 	res = conn.execute(sql)
# 	if not res:
# 		return 'ok'
# 	else:
# 		return 'error'



# @app.route('/common/salary/getime')
# def com_salary_gt():
# 	sql = 'SELECT TIMELOK FROM company_lock WHERE ID_C=%s' %(session['group'],)
# 	res = conn.execute(sql)
# 	#print type(res[0][0])
# 	date = res[0][0].strftime('%Y-%m-%d')
# 	return date
	
@app.route('/common/salary',methods=['GET','POST'])
def com_salary():
	if request.method == 'POST':
		file = request.files['check_file']
		#print file
		if file and allowed_file(file.filename):
			filename = file.filename
			print filename
			ab_path_file = os.path.join(app.config['UPLOAD_FOLDER'], filename)
	    	file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
	    	res = excel_to_check(ab_path_file)
	    	if res == '1':
	    		session['check_upload'] = 1
	        	return render_template('salary_after.html')
	        else:
	        	return 'error'
	else:
		if 'user' in session:
			if 'check_upload' in session:
				return redirect('/common/salary/check_file')
			else:
				return render_template('salary_before.html')
		else:
			return redirect('/signin')

@app.route('/common/salary/reupload')
def com_sal_reup():
	session.pop('check_upload')
	return redirect('/common/salary')

@app.route('/common/salary/check_file',methods=['GET','POST'])
def com_sal_file():
	if request.method == 'POST':
		pass
	else:
		return render_template('salary_after.html')

@app.route('/common/salary/getbase')
def com_salary_gb():
	sql = '''select name,c.id,BJ,SJ,KG,TQJ,HSJ,CJ,GSJ,QTJ,JHSYJ,GJ,NXJ,
	full_night_job,holiday_job,sunday_job,add_job,JT_days,reward_salary,check_salary,
	BX_check from check_once c join stuff s on c.id=s.id order by s.order_num
	'''
	tmp = conn.execute(sql)
	res = json.dumps(tmp)
	return res

@app.route('/common/salary/set',methods=['POST'])
def com_salary_set():
	ID_I = request.form.get('id')
	col = request.form.get('col')
	val = request.form.get('val')
	sql = "UPDATE set_i SET %s=%s WHERE ID=%s" % (col,val,ID_I)
	res = conn.execute(sql)
	if not res:
		return 'ok'
	else:
		return 'error'

@app.route('/common/salary/cal',methods=['GET','POST'])#在salary_after页面中，cal按钮先post提交到这，调用存储过程，再
def com_salary_cal():                                 #location.href = '/common/salary/cal'到这里，展示salary_cal页面。
	if request.method == 'POST':
		sql = "call hr_salary_cal()"
		res = conn.execute(sql)
		if not res:
			return 'ok'
		else:
			return 'error'
	else:
		return render_template('salary_cal.html')

@app.route('/common/salary/get_cal')#这是salary_cal.html页面上提交的展示整个工资表的视图
def com_salary_gc():
	sql = '''select name,t.id,ZG,a.base_salary,salary_XJ,check_salary,high_temp_salary,
	special_job_salary,a.leader_salary,add_job_salary,a.age_salary,night_job_salary,meal_salary,
	a.env_salary,reward_salary,salary_get,a.SB_base,a.YB_base,YL_C,YL_I,SY_C,SY_I,GS_C,YB_C,YB_I,
	BI_C,SI_C,BX_check,BX_XJ,tex,salary_sum from salary_once a join stuff t on a.id=t.id order by t.order_num;
	'''
	res = getjson(sql)
	return res

@app.route('/common/salary/submit',methods=['POST'])
def com_salary_sub():
	time = get_time()[1]
	sql01 = 'call hr_check_all("%s")' %(time,)
	sql02 = 'call hr_salary_all("%s")' %(time,)
	sql03 = '''update check_once set BJ=0,SJ=0,KG=0,TQJ=0,HSJ=0,CJ=0,GSJ=0,QTJ=0,
			JHSYJ=0,GJ=0,NXJ=0,full_night_job=0,holiday_job=0,sunday_job=0,add_job=0,
			JT_days=0,reward_salary=0,check_salary=0,BX_check=0'''
	print sql01,sql02
	try:
		conn.cursor.execute('start transaction')
		conn.cursor.execute(sql01)
		conn.cursor.execute(sql02)
		conn.cursor.execute(sql03)
	except Exception as e:
		conn.cursor.execute('rollback')
		print e
		return 'error'
	else:
		conn.cursor.execute('commit')
		session.pop('check_upload')
		return 'ok'
@app.route('/common/summary/check')#显示summary_check页面，显示的是考勤信息
def com_sum_chk():
	return render_template('summary_check.html')

@app.route('/common/summary/check/select')
def com_sum_check_select():
	string = request.args.get('arr')
	date_start = request.args.get('date_start')
	date_end = request.args.get('date_end')
	department = request.args.get('department')
	name = request.args.get('nam')
	idcard = request.args.get('id')
	arr = string.split(',')
	return 'ok'

@app.route('/common/summary/salary')
def com_sum_sal():
	return 'pass'

@app.route('/common/summary/table',methods=['GET','POST'])#GET：显示summary_table页面
def com_sum_table():
	if request.method == 'GET':
		if 'user' in session:
			return render_template('summary_table.html')

@app.route('/common/summary/bigtable')
def com_sum_bigtable():
	if 'user' in session:
		return render_template('summary_bigtable.html')#GET:显示报表的具体页面

@app.route('/common/summary/table_get',methods=['GET','POST'])#GET:summary_table页面，getable函数请求的内容，在表中展示了一部分
def com_sum_tabget():                                         #summary_bigtable页面，getable函数请求的内容，在包中展示全部内容。
	if request.method == 'GET':
		sql = '''select department,date_format(date,"%Y-%m-%d"),stf_num,sum_count,sum_salary,BX_XJ,YL,SY,GS,YB,
		BI,SH_XJ,ZZS,CJS,JYS,FJS,QYSDS,ticket,protect_tool,other,output_sum,last from baobiao order by 
		department,date desc
		'''
		res = getjson(sql)
		return res
	else:
		department
# @app.route('/common/summary/table_cal',methods=['GET','POST'])#POST:summary_table页面,button'#submit',使用baibiao_cal存储过程计算报表内容
# def com_sum_tabcal():                                         #产生的数据存在baobiao_once表中
# 	if request.method == 'GET':
# 		pass
# 	else:
# 		department = request.form.get('department')
# 		sum_count_input = request.form.get('sum_count_input')
# 		QYSDS_input = request.form.get('QYSDS_input')
# 		ticket_input = request.form.get('ticket_input')
# 		pro_tool_input = request.form.get('pro_tool_input')
# 		other_input = request.form.get('other_input')
# 		date = '%s-01' % (get_time()[1])
# 		sql = 'call baobiao_cal(%s,%s,%s,%s,%s,"%s","%s")' %(sum_count_input,ticket_input,pro_tool_input,other_input,QYSDS_input,department,date)
# 		try:
# 			print sql
# 			conn.cursor.execute(sql)
# 		except Exception as e:
# 			print e
# 			return 'error'
# 		else:
# 			return 'ok'

@app.route('/common/summary/table_cal',methods=['GET','POST'])#POST:summary_table页面,按钮'#cal',使用baibiao_cal存储过程计算报表内容
def com_sum_tabcal():                                         #产生的数据存在baobiao_once表中。
	if request.method == 'GET':                               #如果插入成功，则对baobiao_once执行查询，返回查询的json数据。在页面上
		department = request.args.get('department')           #调用模态框myModal显示出来。
		sum_count_input = request.args.get('sum_count_input')
		QYSDS_input = request.args.get('QYSDS_input')
		ticket_input = request.args.get('ticket_input')
		pro_tool_input = request.args.get('pro_tool_input')
		other_input = request.args.get('other_input')
		date = '%s-01' % (get_time()[1])
		sql = 'call baobiao_cal(%s,%s,%s,%s,%s,"%s","%s")' %(sum_count_input,ticket_input,pro_tool_input,other_input,QYSDS_input,department,date)
		try:
			print sql
			conn.cursor.execute(sql)
		except Exception as e:
			print e
			return 'error'
		else:
			sql = '''select department,date_format(date,"%Y-%m-%d"),stf_num,sum_count,sum_salary,BX_XJ,YL,SY,GS,YB,
		BI,SH_XJ,ZZS,CJS,JYS,FJS,QYSDS,ticket,protect_tool,other,output_sum,last from baobiao_once'''
			res = getjson(sql)
			return res

@app.route('/common/summary/submit',methods=['GET','POST'])#POST:summary_table页面，模态框myModal显示出来后，按钮sumbit，将baobiao_once的
def com_sum_submit():                                      #内容添加进baobiao中。如果产生异常，查看异常的内容是否包含Duplicate entry
	if request.method == 'GET':                            #如果包含，让前段提示之前已经插入过数据。
		pass
	else:
		sql = 'insert into baobiao select * from baobiao_once'
		try:
			conn.cursor.execute(sql)
		except Exception as e:
			print str(e)[8:23]
			if 'Duplicate entry' == str(e)[8:23]:
				return 'P'
			else:
				return 'error'
		else:
			return 'ok'

@app.route('/common/summary/table_sub',methods=['GET','POST'])
def com_sum_tabsub():
	if request.method == 'GET':
		pass
	else:
		sql = 'baobiao_sub()'
		return 'ok'


@app.route('/common/set',methods=['GET','POST'])
def com_set():
	if request.method == 'GET':
		if 'user' in session:
			return render_template('common_set.html')
@app.route('/common/set/depart_get')
def com_set_depget():
	sql = 'select id,name from department'
	res = getjson(sql)
	#print res
	return res


if __name__ == '__main__':
	app.run(host='0.0.0.0',port=9023,debug=True)