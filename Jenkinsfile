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
	       sh '''
		   pwd
		   ls -lrth
	           cat Objectlist.txt
		   Objectname=`cat Objectlist.txt | awk '{print $1}'`
		   snowsql -q "SELECT GET_DDL('TABLE','GDW_AUDIT.TEST_TABLE1')" | sed -n '1!p'
		   snowsql -q "SELECT GET_DDL('TABLE','$Objectname')" | sed -n '1!p' > BIDW.DBA.$Objectname
		   cat BIDW.DBA.$Objectname
		   '''
							}
				}
			}
	  stage('Review the Code') {
			steps {
	         emailext attachmentsPattern: BIDW.DBA*
			  body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n, 
			  subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}", 
			  to: 'yatin.sawant@officedepot.com'
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
