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
	     cat ~/.snowsql/config
	     apt-get install -y dos2unix
	     apt-get install -y git
	     chmod -R 777 .
             ''' 
         }
       }
      }
    stage('In QA trigger') {
      	  steps {
	      container('sqitch'){
	           sh '''
		   pwd
		   ls -lrth
		   dos2unix deploy.sh
		   ./deploy.sh
		   ls -lrth
	      '''
				}
			}
		}  
	}
  }
