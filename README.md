# Djangular 3

Django and AngularJS starter app.

* [(Video) Project setup](https://youtu.be/okWBei-rK_A)
* [More detailed explanations about what happen in the frontend](https://dicasdolampada.wordpress.com/2015/06/25/a-awesome-setup-for-your-angularjs-project-13/)
* [(Video) Google Hangout explaining more details about this project](https://www.youtube.com/watch?v=rKwpU7_10XI)

# OS setup

You'll need to install a few thing on your system. It may be the case that some of those thing are already there.
You only need to do this once in a lifetime.

* 1) Install the packages below with apt-get (node, npm, postgres and a few libraries)

```bash
sudo apt-get install python3-dev nodejs npm postgresql-9.3 postgresql-server-dev-all
```

* 2) Install gulp

```shell
sudo npm install -g gulp
```

* 3) Make sure you have python3 (my ubuntu already comes with python 2 and 3, 2 is the default)

* 4) Install virtualenvwrapper, [according to the instructions on the web site](http://virtualenvwrapper.readthedocs.org/en/latest/install.html)

# Project setup

Now you need to do the project setup. This means that if you have another project like this one, you'd have to do this part again.

* 1) Create the user and database inside postgres

```bash
sudo su postgres  # log in as user postgres on your terminal
createuser -d -SRP djangular3  # type djangular3 as password
createdb -O djangular3 djangular3
exit  # go back to your user

# If you want to change database_name/username/password,
# then you need to change this file --> djangular3/settings.py
```

* 2) Create the project's virtualenv and download python dependencies

```shell
mkvirtualenv --python=/usr/bin/python3 djangular3  
# You can use a different name on your project
deactivate  # This is how you exit the virtualenv
workon djangular3  # Activate the virtualenv again
pip install -r requirements.txt
```

* 3) Create tables on your database

```shell
./manage.py migrate
```

* 4) Create a superuser on that database

```shell
./manage.py createsuperuser
```

* 5) Download frontend dependencies

```shell
cd frontend
npm install
```

* 6) Import bash functions on your terminal

```shell
cd ..
source dev.sh
devhelp  # Those commands should all work now
#  That help there is the best part. It will help you from now on.
#  Take care of it so that your project will have all of its commands up to date.
```
