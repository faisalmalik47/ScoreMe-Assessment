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

Now Navigate to Projects → Create a local project → Fill in details and click next.

![1724445576074](image/Readme/1724445576074.png)


Use the global setting and click Create project

![1724445601533](image/Readme/1724445601533.png)


Once project is created click on Locally.

![1724445644025](image/Readme/1724445644025.png)

Select use existing token and click continue:

![1724445700520](image/Readme/1724445700520.png)

Select Others and copy the command, we will use it in our pipeline.

![1724445716515](image/Readme/1724445716515.png)


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


Got it fixed and pipeline failed again,

![1724444829904](image/Readme/1724444829904.png)![1724444857214](image/Readme/1724444857214.png)


Issue:  Incorrect SonarQube Server URL, let me fix it and rerun the pipeline.

It was a simple URL mismatch error, now that our COde Quality stage is passed and successful, let's fix OWASP FS SCAN stage.

![1724446386381](image/Readme/1724446386381.png)

![1724447913345](image/Readme/1724447913345.png)

It says "NO installation DP-Checker found",

![1724446473619](image/Readme/1724446473619.png)


Worked now, the issue was with wrong name of DP-Checker, i configured it as DP-Checker, its fixed.

![1724454012407](image/Readme/1724454012407.png)


![1724454369567](image/Readme/1724454369567.png)


Seems to be an issue with Dockerfile, fixed it. 


![1724454310866](image/Readme/1724454310866.png)


Lets configure, notifcation and Failture Handling now.

Configuring Slack,

go to the URL "https://yourworkspace.slack.com/apps/A0F7VRFKN-jenkins-ci?tab=more_info" to integrate Jenkins CI tool.


![1724454556926](image/Readme/1724454556926.png)


Click on Add to Slack


![1724454583367](image/Readme/1724454583367.png)


Click on create new channel and give it a name and click next and then click create.

Select the created Channel from the drop down menu.

![1724454716724](image/Readme/1724454716724.png)


Click on Add Jenkins CI Integration, scroll down and copy the generated token.


![1724454776593](image/Readme/1724454776593.png)



Click on save settings.

![1724454794185](image/Readme/1724454794185.png)


Lets Integrate Slack to our Jenkins.


In Jenkins Navigate to Manage Jenkins → Plugins →Available Plugins and install the slack notifiction plugin.


![1724454906519](image/Readme/1724454906519.png)


Now go to Manage Jenkins → Credentials → System → Global Credentials → Add Credential

Put token from Slack ins ecret and name it, then click on create.

![1724455070480](image/Readme/1724455070480.png)

Now go to Manage Jenkins → System and look for slack section, give Workspace name and select the previously created credential, then click on test connection.


![1724455257763](image/Readme/1724455257763.png)


The test is successful.

Lets test our pipeline now, for the time being i have commented the stages of pipeline where it takes too much time to only test this stage, build completed successfuly and we recieved the message, lets modify it a little bit. 

![1724455631018](image/Readme/1724455631018.png)


![1724455851824](image/Readme/1724455851824.png)
