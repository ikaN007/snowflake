pipeline {
    options {
      timeout(time: 1, unit: 'HOURS') 
  }
    agent {
        node {
            label 'snowflake'
        }
    }
  stages {
    stage('Moving .snowsql to workspace and replacing snowsql in /bin') {
         steps {
           container('sqitch'){
	     sh '''
	     cp -r /root/bin/snowsql /bin/
	     cp -r ~/.snowsql ./
	     cp -r ~/.snowsql/config ./.snowsql/config
	     cat ./.snowsql/config
	     chmod -R 777 .
	     apt-get install -y dos2unix
             ''' 
         }
       }
      }
    stage('Fetch the DDL from TEST_DEV DB') {
      	  steps {
	      container('sqitch'){
		      sh '''
		      pwd
		      ls -lrth
		      cat Objectlist.txt
		      dos2unix fetch_ddl.sh
		      ./fetch_ddl.sh
		      ls -lrth
		         '''
	       				}
				}
			}
	  stage('Review the Code') {
			steps {
				emailext attachmentsPattern: "*.sql", 
					 body: "Review the Attached DDL Files to be deployed to TEST_QA DB.\n If no changes required. Please approve the Job in the below given URL Build URL: ${env.BUILD_URL}", 
					 subject: "Build Number: ${env.BUILD_NUMBER} Job Name: ${env.JOB_NAME}", to: 'yatin.sawant@officedepot.com'
				  }
			}

	  stage('Approve the Review for Deployment to QA') {
			steps {
		    input 'Approve the DDL to Deploy to QA'
					}
			}
	   
	  stage('Git SCM Commit to QA Branch') {
			steps {
				container('sqitch') {
			
		withCredentials([usernamePassword(credentialsId: 'yatin_git_creds', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
			
		    sh 'pwd'
		    sh 'ls -lrth'
		    sh 'apt-get install -y git'
		    sh 'git clone https://github.com/devopsyatin/snowflake.git -b qa'
		    sh 'cd snowflake'
		    sh 'ls -lrth'
		    sh 'pwd'
		    sh 'git branch'
		    sh 'git branch -a'
		    sh 'git checkout qa'
		    sh 'git config --global user.email "sawant.yatin@yahoo.in"'
		    sh 'git config --global user.name "devopsyatin"'
		    sh 'cp /home/jenkins/agent/workspace/Snowflake_test_test_dev/BIDW* .'
		    sh 'git add .'
		    sh 'git commit -m "adding the reviewed file"'
		    #git push https://devopsyatin:Dattaprasad%4010@github.com/devopsyatin/snowflake.git qa
		    sh 'git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/devopsyatin/snowflake.git qa
		}
					}
				}
			}
		}
	}
