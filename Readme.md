
I have written a terraform code in terraform folder for launching an ubuntu instance and installing jenkins, java and docker in it. Used below commands to launch the jenkins server.

**alias tf=terraform**

**tf init**

**tf plan**

**tf apply**

Above commands will create an ec2 instance in your aws console, now head to the ec2 console on aws and find the public ip of the server.


![1724249812260](image/Readme/1724249812260.png)


Head to IP:8080 and see the below page to get the Initial password from the file "`/var/lib/jenkins/secrets/initialAdminPassword`", login to the ec2-instance using using either ssm or ec2-connect and use the below command to find the initpassword.

sudo cat `/var/lib/jenkins/secrets/initialAdminPassword`

![1724250011788](image/Readme/1724250011788.png)


Copy the password and paste it in jenkins-UI and click continue. and follow basic installation prompts.

![1724250106857](image/Readme/1724250106857.png)


Once the setup is done, go to plugins and install the below plugins,

![1724250597581](image/Readme/1724250597581.png)


Once we are done with these plugin installations, we need to go to manage jenkins > Tools to configure these installed tools, go to the path and scroll down to find out the name of these plugins like "SonarQube Scanner", "Dependency-Check installations"", "Docker installations" and others like that.


Open the Tools page is opened click on ass SonarQube Scanner and name it and allow jenkins to install in automatically click on apply and then save. We will Configure other tools like this only.

![1724251386482](image/Readme/1724251386482.png)


Do the same for docker but we will not install it automatically as we have already installed it in out jenkins server while provisioninig via install.sh script, click apply and save.

![1724251572577](image/Readme/1724251572577.png)


Do the same for Dependency-checker.

![1724251705228](image/Readme/1724251705228.png)


Now head to "https://WORKSPACE.slack.com/apps/new/", > Select a channel where you want notifications to be delivered > Add Jenkins CI > Scroll down and click Save settings and follow the recommened steps.

![1724252573767](image/Readme/1724252573767.png)


![1724252850405](image/Readme/1724252850405.png)


Copy the token and create a secret text in Jenkins credentials and then test the connection.

Creating the Credentials, go to Dashboard > Manage Jenkins > Credentials > System > Global Credentials > Add new credentials, fill the details and then save it like below.

![1724253107675](image/Readme/1724253107675.png)

Setting up slack integration, go to Manage jenkins > system > scroll down to fine Slack section , give exact name of your workspace and select the correct token from credentials and test the connection.


![1724253224697](image/Readme/1724253224697.png)


we can see that the test connection result was sucess, now save it.

Moving to the next step, we will configure sonarqqube now, head to IP:9000 port where sonarqube is already runnning, which we are using in a docker container that we started while launching the container, default user and pass is admin:admin, login using it and reset the password.

![1724254541672](image/Readme/1724254541672.png)

Now we will be going to the Administration > security and will create a new token and copy it.

![1724254711270](image/Readme/1724254711270.png)


We will now create a crenetial of this token as a secret text with the name of sonar-token, like we created earlier. click on create.

![1724254923770](image/Readme/1724254923770.png)

Now go to manage jenkins > system and scroll down to sonarqube server section and configure it. click on save

![1724255054845](image/Readme/1724255054845.png)
