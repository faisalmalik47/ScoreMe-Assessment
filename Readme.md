I have written a terraform code in terraform folder for launching an ubuntu instance and installing jenkins, java and docker, docker-copose in it, we are going to use sonarqube and sonar-scanner utility in a container with the help of docker-compose.yaml file in this repo. Used below commands to launch the jenkins server.

**alias tf=terraform**

**tf init**

**tf plan**

**tf apply**

Above commands will create an ec2 instance in your aws console, now head to the ec2 console on aws and find the public ip of the server. Connect to the server using SSH.

![1724272429192](image/Readme/1724272429192.png)

Access jenkins on port 8080 of ec2 public IP, and see the below page to get the Initial password from the file "`/var/lib/jenkins/secrets/initialAdminPassword`", login to the ec2-instance using using either ssm or ec2-connect and use the below command to find the initpassword.

**Configure Jenkins server.**

sudo cat `/var/lib/jenkins/secrets/initialAdminPassword`

![1724441908651](image/Readme/1724441908651.png)

Copy the password and paste it in jenkins-UI and click continue. and follow basic installation prompts.

![1724441924108](image/Readme/1724441924108.png)


Install suggested plugins.


![1724441956791](image/Readme/1724441956791.png)


Create user help us customize username and password of Jenkins.


![1724442254875](image/Readme/1724442254875.png)


Access SonarQube on port 9000 of Same Jenkins server. Server running inside the container.

Username: admin
Password: admin

![1724442294046](image/Readme/1724442294046.png)


Customize the password.

![1724442314937](image/Readme/1724442314937.png)


Navigate to Administrator → Security → Users.

![1724442379244](image/Readme/1724442379244.png)


Click on Tokens, Create one and save it. 

"squ_2e7192a210d22c5342986270d4a8b992321b8825"

![1724442421488](image/Readme/1724442421488.png)


Now in Jenkins Navigate to Manage Jenkins → Plugins →Available Plugins and install the following.


* SonarQube Scanner
* Docker
* Docker commons
* Docker pipeline
* Eclipse Temurin Installer
* NodeJs Plugin
* Owasp Dependency-Check
* AWS Credentials
* Pipeline: AWS Steps
* Pipeline: Stage View


![1724442782121](image/Readme/1724442782121.png)


Restart Jenkins after they got installed.


![1724442808462](image/Readme/1724442808462.png)


Go to Manage Jenkins → Tools → Install JDK(17) and NodeJs(19)→ Click on Apply and Save.


![1724442935144](image/Readme/1724442935144.png)


![1724442977522](image/Readme/1724442977522.png)


Similarly install DP-check, Sonar-Scanner and Docker.


![1724443075185](image/Readme/1724443075185.png)


![1724443124889](image/Readme/1724443124889.png)


Go to Jenkins Dashboard → Manage Jenkins → Credentials. Add

Sonar-token as secret text.

![1724443198975](image/Readme/1724443198975.png)


Docker credentials.

![1724443368425](image/Readme/1724443368425.png)



Manage Jenkins → Tools → SonarQube Scanner. Then add sonar-server and created sonar-token.

![1724443470609](image/Readme/1724443470609.png)

**Create Jenkins Pipeline**

Up to this Let’s create a pipeline and see if anything gone wrong.
Click on “New Item” and give it a name selecting pipeline and then ok


![1724443512305](image/Readme/1724443512305.png)


Under Pipeline section Provide

Definition:Pipeline script from SCM
SCM :Git
Repo URL : Github Repo
Branch: master
Path:Jenkins file path in GitHub repo.

![1724443628202](image/Readme/1724443628202.png)

Click on “Build”.

Got an error., most probably syntax or indentation:

![1724444459537](image/Readme/1724444459537.png)


Lets fix it,
