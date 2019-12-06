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
	     chmod -R 777 .
             ''' 
         }
       }
      }
    stage('Fetch the DDL from TEST_DEV DB') {
      	  when {
	      branch 'TEST_DEV'
	      }
	  steps {
	      container('sqitch'){
	           sh '''
		   pwd
		   ls -lrth
	           cat Objectlist.txt
		   #Objectname=`cat Ojectlist.txt | awk '{print $1}'`
		   snowsql -q "SELECT GET_DDL('TABLE','GDW_AUDIT.TEST_TABLE1')" | sed -n '1!p'
		   #snowsql -q "SELECT GET_DDL('TABLE','$Objectname')" | sed -n '1!p' > BIDW.DBA.$objectname
		   #cat BIDW.DBA.$objectname
		   '''
		}
	}
     }
    stage ('Email for Review') {
	  
	  emailext (
	    to: 'yatin.sawant@officedepot.com'	  
            subject: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            body: """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
              <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
            recipientProviders: [[$class: 'DevelopersRecipientProvider']]
          )  
    }
  }	  
  }
}
