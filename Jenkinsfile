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
             ''' 
         }
       }
      }
    stage('Fetch the DDL from TEST_DEV DB') {
      	  steps {
	      container('sqitch'){
		      sh 'pwd'
		      sh 'ls -lrth'
		      sh 'cat Objectlist.txt'
		      sh '/home/jenkins/agent/workspace/Snowflake_test_test_dev/fetch_ddl.sh'
		      sh 'cat BIDW.DBA*.sql'
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
			sh '''
		    pwd
		    ls -lrth
		    apt-get install -y git
		    git clone https://github.com/devopsyatin/snowflake.git -b qa
		    cd snowflake
		    ls -lrth
		    pwd
		    git branch
		    git branch -a
		    git checkout qa
		    git config --global user.email "yatin.sawant@officedepot.com"
		    git config --global user.name "yatin-sawant-od"
		    cp /home/jenkins/agent/workspace/Snowflake_test_test_dev/BIDW* .
		    git add .
		    git commit -m "adding the reviewed file"
		    git push https://yatin-sawant-od:Max%40min1@github.com/devopsyatin/snowflake.git qa
		    	   ''' 
					}
				}
			}
		}
	}
