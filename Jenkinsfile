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
	  
	emailext body: """yatin.sawant@officedepot.com,

 
Your snowflake test using CI/CD Pipeline has started with build # ${BUILD_TAG} for the following objects(s)
 
Auto Generated Email by Jenkins""", subject: "Datastage Deployment Notice: ${BUILD_TAG}", to: "yatin.sawant@officedepot.com"
    }	  
  }
}
