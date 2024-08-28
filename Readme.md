**Requirements:**

*DevOps Engineer Assignment:* 

Constructing a Jenkins CI/CD Pipeline

*Objective:*
The goal of this assignment is to create a Jenkins pipeline that integrates various open-source tools to assess code coverage, code quality, cyclomatic complexity, and security vulnerabilities. You will be demonstrating your ability to create an effective CI/CD process that aids in maintaining high-quality code standards in a software development project.
Requirements:

1. Jenkins Setup:
   ○ Install and configure Jenkins on a virtual machine or use a cloud-based service.
   ○ Ensure Jenkins is configured with the necessary plugins for Git and any other
   SCM tools you decide to use.
2. Source Code Management:
   ○ Use Git as the source code management tool.
   ○ Configure Jenkins to pull code from a Git repository (GitHub, GitLab, etc.).
3. Pipeline Creation:
   ○ Create a Jenkinsfile that defines the pipeline stages.
   ○ The pipeline should be triggered on every commit to the main branch of the
   repository.
4. Code Quality Checks:
   ○ Integrate SonarQube to analyze code quality and technical debt.
   ○ Configure the pipeline to break if the code quality gates are not met.
5. Code Coverage:
   ○ Integrate a tool like JaCoCo (for Java applications) or another relevant tool based
   on the programming language used.
   ○ Ensure that the code coverage report is published and accessible through
   Jenkins.
6. Cyclomatic Complexity:
   ○ Integrate a tool that can calculate and report the cyclomatic complexity of the
   code.
   ○ Tools such as Lizard (for C/C++, Java, Python, etc.) can be used.
7. Security Vulnerability Scan:
   ○ Integrate OWASP Dependency-Check or another similar tool to scan for known
   security vulnerabilities in the project dependencies.
   ○ Ensure that the vulnerability reports are accessible and that builds fail if critical
   vulnerabilities are found.
8. Notifications:
   ○ Configure Jenkins to send notifications (email, Slack, etc.) on build success or
   failure.
9. Documentation:

○ Document the pipeline steps, tools integrated, and any configurations needed for
the setup.
○ Include troubleshooting steps for common issues that might occur during the
build process.

Deliverables:

1. Jenkinsfile with complete pipeline configuration.
2. Documentation covering setup, configuration, and usage of the pipeline.
3. A report outlining the results of the initial run of the pipeline, including screenshots of the dashboard of each tool used. Evaluation Criteria:
   ● Completeness of the pipeline setup.
   ● Ability to integrate multiple tools effectively.
   ● Clarity and completeness of documentation.
   ● Handling of different scenarios (e.g., build failures due to quality checks).


**IMPLEMENTATION**

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


Much better now.


![1724456252456](image/Readme/1724456252456.png)


![1724456260247](image/Readme/1724456260247.png)


As a final thing, lets Ensure we handle failure, in this pipeline in the case of a failure i will revert the container.

I've made a mistake in Dockerfile knowingly to test the failure handling.

![1724459953278](image/Readme/1724459953278.png)

![1724459999356](image/Readme/1724459999356.png)


As we can see below the current build number is 37, but in failure it reverted to the previous successfully build image which was done in build no. 36.

![1724460098361](image/Readme/1724460098361.png)


**ADDONS:**

Lets add a stage and we will be using trivy in a container for cleaner approach. Simple command is being used in this stage.

docker run aquasec/trivy image faisalmaliik/reddit:`<tag>`

Perfect!!


![1724463713757](image/Readme/1724463713757.png)


![1724466008539](image/Readme/1724466008539.png)


Scan report:


![1724466060496](image/Readme/1724466060496.png)


Now for the final part lets make this pipeline auto trigger on every new commit on Master branch.


Navigate to githubRepo --> Settings --> Webhooks --> Add Webhook


![1724466188947](image/Readme/1724466188947.png)


Populate the details like below:

![1724466292437](image/Readme/1724466292437.png)


click Add Webhook, and its successful.

![1724466321221](image/Readme/1724466321221.png)


Now in jenkins Navigate to pipeline --> configure --> in build trigger section select the "GitHub hook trigger for GITScm polling" option and we're done.


![1724466668415](image/Readme/1724466668415.png)

Lets test it now.

It works perfectly!!


![1724466547353](image/Readme/1724466547353.png)


![1724466556134](image/Readme/1724466556134.png)
