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
				git branch: 'qa', credentialsId: '1ba6fd69-fc26-4fe2-8054-8e35163df090', url: 'https://github.com/devopsyatin/snowflake.git'
				sh 'ls -lrth'
				
				}
			}
		}
	}
